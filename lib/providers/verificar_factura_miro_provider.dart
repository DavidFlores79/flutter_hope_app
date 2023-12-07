import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/helpers/debouncer.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/login_screen.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class VerificacionFacturaMiroProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  bool _isLoading = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  bool result = false;
  bool verificarFactura = false;
  String numeroPedido = '';
  VerificacionFacturaMiroResponse? verificacionResponse;
  PedidoMiro? pedido;
  List<Posicione> posicionesSelected = [];
  late String fecha1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
  late String fecha2 = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final debouncer = Debouncer(duration: const Duration(milliseconds: 700));
  final NavigationService _navigationService = locator<NavigationService>();
  final storage = const FlutterSecureStorage();
  String referenciaInput = "";
  String importeInput = "";

  VerificacionFacturaMiroProvider() {
    // ignore: avoid_print
    print('VerificacionFacturaMiroProvaider inicializado');
    result = false;
  }

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    //print('$email - $password');
    return formKey.currentState?.validate() ?? false;
  }

  bool isValidForm2() {
    //print('$email - $password');
    return formKey2.currentState?.validate() ?? false;
  }

  bool isValidForm3() {
    //print('$email - $password');
    return formKey3.currentState?.validate() ?? false;
  }

  // Funcion para traer Pedidos miro con un doc en especifico
  Future<bool> getPedido(numeroPedido) async {
    //Reseteamos fechas
    isLoading = true;
    result = false;
    resetVarResponse();
    // ignore: avoid_print
    print('Peticion API verificacion-factura/get-pedido');
    _endPoint = '/api/v1/verificacion-factura/get-pedido/';
    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final Map<String, dynamic> queryParameters = {
      'pedido': numeroPedido,
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint', queryParameters);
    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          isLoading = false;
          verificacionResponse =
              VerificacionFacturaMiroResponse.fromJson(response.body);
          pedido = verificacionResponse!.pedidoMiro;
          result = true;
          break;
        case 400:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('400: ${response.body}');
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
    return result;
  }

  Future<bool> verificacionFactura() async {
    isLoading = true;
    verificarFactura = false;
    print('Peticion API');
    _endPoint = '/api/v1/verificacion-factura';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';
    print('Verificar Factura Token: $jwtToken');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    verificacionResponse!.pedidoMiro!.cabeceraPedido!.referencia =
        referenciaInput;
    verificacionResponse!.pedidoMiro!.importeTotal = double.parse(importeInput);
    final VerificacionFacturaMiroRequest pedidoRequest =
        VerificacionFacturaMiroRequest(
            cabeceraPedido: verificacionResponse!.pedidoMiro!.cabeceraPedido,
            documentoPedido: verificacionResponse!.pedidoMiro!.documentoPedido!,
            estatus: verificacionResponse!.pedidoMiro!.estatus!,
            historial: verificacionResponse!.pedidoMiro!.historial!,
            trace: verificacionResponse!.pedidoMiro!.trace!,
            posiciones: posicionesSelected,
            importeTotal: verificacionResponse!.pedidoMiro!.importeTotal!,
            fechaContabilizacion: fecha1,
            fechaFactura: fecha2);

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');
    try {
      final response = await http
          .put(url, headers: headers, body: pedidoRequest.toJson())
          .timeout(const Duration(seconds: 30));
      switch (response.statusCode) {
        case 200:
          isLoading = false;
          VerificacionFacturaMiroRequestResponse respuesta =
              VerificacionFacturaMiroRequestResponse.fromJson(response.body);
          Notifications.showSnackBar(
              'Factura generada:  ${respuesta.documentoSap}');
          resetVarRequest();
          break;
        case 400:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('400: ${response.body}');
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoading = false;
          verificarFactura = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('404 - $serverResponse');
          break;
        case 422:
          isLoading = false;
          // ignore: avoid_print
          print('422: ${response.body}');
          ValidatorResponse validatorResponse =
              ValidatorResponse.fromJson(response.body);
          final Map<String, dynamic> errors = validatorResponse.errors.toMap();
          String messages = '${validatorResponse.message}\n';
          Iterable<dynamic> values = errors.values;
          for (final error in values) {
            Iterable<dynamic> errorStrings = error;
            for (final errorString in errorStrings) {
              // ignore: avoid_print
              print('error: $errorString');
              messages = '${messages + errorString}\n';
            }
          }
          break;
        case 500:
          posicionesSelected = [];
          isLoading = false;
          break;
        default:
          print('Default: ${response.body}');
          isLoading = false;
          verificarFactura = false;
      }
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error $e');
      isLoading = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return verificarFactura;
  }

  updateSelected(Posicione posicion) {
    posicion.isSelected = posicion.isSelected == true ? false : true;
    notifyListeners();
  }

  resetVarResponse() {
    fecha1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    fecha2 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    posicionesSelected = [];
    referenciaInput = "";
    importeInput = "";
  }

  resetVarRequest() {
    verificarFactura = true;
    result = false;
    formKey.currentState!.reset();
    formKey2.currentState!.reset();
    formKey3.currentState!.reset();
    numeroPedido = '';
    fecha1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    fecha2 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    posicionesSelected = [];
    referenciaInput = "";
    importeInput = "";
  }

  logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    _navigationService.navigateTo(LoginScreen.routeName);
  }
}
