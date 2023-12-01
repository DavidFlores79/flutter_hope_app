import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReciboEmbarqueProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  ReciboEmbarqueResponse? reciboEmbarqueResponse;
  bool result = false;
  List<Centros>? centrosUsuario = [];
  String _centroDefault = '';
  late String fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final NavigationService _navigationService = locator<NavigationService>();
  final storage = const FlutterSecureStorage();

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  get isLoading => _isLoading;

  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  String get centroDefault => _centroDefault;

  set centroDefault(String value) {
    _centroDefault = value;
    notifyListeners();
  }

  ReciboEmbarqueProvider() {
    print('ReciboEmbarqueProvider inicializado');
    getCatalogs();
  }

  //Peticiones API
  Future<bool> getCatalogs() async {
    isLoading = true;
    result = false;
    print('Peticion ReciboEmbarque - Get Catalogs');
    _endPoint = '/api/v1/reciboembarque';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Catalogs ${response.body}');
          reciboEmbarqueResponse = ReciboEmbarqueResponse.fromJson(response.body);
          centrosUsuario = reciboEmbarqueResponse!.centrosUsuario;
          centroDefault = centrosUsuario!.first.idcentro!;
          notifyListeners();
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoading = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
            (serverResponse?.message != null || serverResponse?.message != '')
                ? serverResponse!.message!
                : 'Error de Autenticación.',
          );
          break;
        case 404:
          isLoading = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(serverResponse?.message ?? 'Error 404.');
          notifyListeners();
          print('404: ${response.body}');
          break;
        case 422:
          isLoading = false;
          result = false;
          print('422: ${response.body}');
          ValidatorResponse validatorResponse =
              ValidatorResponse.fromJson(response.body);
          final Map<String, dynamic> errors = validatorResponse.errors.toMap();
          String messages = '${validatorResponse.message}\n';

          Iterable<dynamic> values = errors.values;
          for (final error in values) {
            Iterable<dynamic> errorStrings = error;
            for (final errorString in errorStrings) {
              print('error: $errorString');
              messages = '${messages + errorString}\n';
            }
          }

          Notifications.showSnackBar(messages);
          notifyListeners();
          break;
        case 500:
          isLoading = false;
          result = false;
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoading = false;
          result = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isLoading = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }

  Future<List> searchEmbarques() async {
    print('Peticion ReciboEmbarque Search');
    _endPoint = '/api/v1/reciboembarque/search';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final Map<String, dynamic> queryParameters = {
      'fecha_recepcion': fecha,
      'centro': centroDefault,
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint', queryParameters);

    try {
      isLoading = true;

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          isLoading = false;
          print('200: ${response.body}');
          notifyListeners();
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message?.substring(0, 60) ??
                  'Error Desconocido.');
          notifyListeners();
          print('404 ${serverResponse?.message}');
          break;
        case 422:
          isLoading = false;
          result = false;
          print('422: ${response.body}');
          ValidatorResponse validatorResponse =
              ValidatorResponse.fromJson(response.body);
          final Map<String, dynamic> errors = validatorResponse.errors.toMap();
          String messages = '${validatorResponse.message}\n';

          Iterable<dynamic> values = errors.values;
          for (final error in values) {
            Iterable<dynamic> errorStrings = error;
            for (final errorString in errorStrings) {
              print('error: $errorString');
              messages = '${messages + errorString}\n';
            }
          }
          break;
        case 500:
          isLoading = false;
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoading = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isLoading = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return [];
  }

  Future<bool> contabilizarEmbarque() async {
    isLoading = true;
    result = false;
    print('Peticion ReciboEmbarque - Store');
    _endPoint = '/api/v1/reciboembarque';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    // Modificar la lista antes de enviarla al backend
    // List<PosicionZSTT> listaModificada = posiciones!.map((posicion) {
    //   return PosicionZSTT(
    //     cantidad: posicion.cantidad,
    //     numeroMaterial: posicion.numeroMaterial,
    //     centroReceptor: posicion.centroReceptor,
    //     unidadMedida: posicion.unidadMedida,
    //     esDevolucion: posicion.esDevolucion,
    //     almacen: posicion.almacen,
    //   );
    // }).toList();

    // final CreateOrderRequest pedido = CreateOrderRequest(
    //   pedido: PedidoME21N(
    //     cabeceraPedido: Cabecera(
    //       gpoCompras: gpoCompras,
    //       tipoPedido: claseDocumentoSelected,
    //       proveedorMercancias: numeroProveedor,
    //       cuentaProveedor: numeroProveedor,
    //       orgCompras: orgComprasSelected,
    //     ),
    //     posiciones: listaModificada,
    //   ),
    // );

    // print(pedido.toJson());

    // final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    // try {
    //   final response = await http
    //       .post(url, headers: headers, body: pedido.toJson())
    //       .timeout(const Duration(seconds: 20));

    //   switch (response.statusCode) {
    //     case 200:
    //       result = true;
    //       isLoading = false;
    //       print('200: Create ME21N ${response.body}');
    //       createOrderResponse = CreateOrderResponse.fromJson(response.body);
    //       Notifications.showSnackBar(
    //         createOrderResponse!.trace ?? 'Creacion Satisfactoria.',
    //       );
    //       notifyListeners();
    //       break;
    //     case 400:
    //       isLoading = false;
    //       serverResponse = ServerResponse.fromJson(response.body);
    //       Notifications.showSnackBar(
    //           serverResponse?.message ?? 'Error Desconocido.');
    //       notifyListeners();
    //       print('400: ${response.body}');
    //       break;
    //     case 401:
    //       if (!response.body.contains('code')) {
    //         logout();
    //         print('logout');
    //         break;
    //       }
    //       isLoading = false;
    //       result = false;
    //       serverResponse = ServerResponse.fromJson(response.body);
    //       Notifications.showSnackBar(
    //           serverResponse?.message ?? 'Error de Autenticación.');
    //       break;
    //     case 404:
    //       isLoading = false;
    //       serverResponse = ServerResponse.fromJson(response.body);
    //       Notifications.showSnackBar(
    //           serverResponse?.message ?? 'Error Desconocido.');
    //       notifyListeners();
    //       print('404: ${response.body}');
    //       break;
    //     case 422:
    //       isLoading = false;
    //       result = false;
    //       print('422: ${response.body}');
    //       ValidatorResponse validatorResponse =
    //           ValidatorResponse.fromJson(response.body);
    //       final Map<String, dynamic> errors = validatorResponse.errors.toMap();
    //       String messages = '${validatorResponse.message}\n';

    //       Iterable<dynamic> values = errors.values;
    //       for (final error in values) {
    //         Iterable<dynamic> errorStrings = error;
    //         for (final errorString in errorStrings) {
    //           print('error: $errorString');
    //           messages = '${messages + errorString}\n';
    //         }
    //       }

    //       Notifications.showSnackBar(messages);
    //       notifyListeners();
    //       break;
    //     case 500:
    //       isLoading = false;
    //       print('500: ${response.body}');
    //       Notifications.showSnackBar('500 Server Error.');
    //       break;
    //     default:
    //       print('Default: ${response.body}');
    //       isLoading = false;
    //       result = false;
    //   }
    //   notifyListeners();
    // } catch (e) {
    //   print('Error $e');
    //   isLoading = false;
    //   if (e.toString().contains('TimeoutException')) {
    //     Notifications.showSnackBar(
    //         'Tiempo de espera agotado. Favor de reintentar');
    //   }
    //   notifyListeners();
    // }
    return result;
  }

  logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    _navigationService.navigateTo(LoginScreen.routeName);
  }
}
