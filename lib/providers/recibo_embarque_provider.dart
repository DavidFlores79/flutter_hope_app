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
  bool _isLoadingCatalogs = false;
  bool get isLoadingCatalogs => _isLoadingCatalogs;

  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  ReciboEmbarqueResponse? reciboEmbarqueResponse;
  bool result = false;
  List<Centros>? centrosUsuario = [];
  List<Embarque>? embarques = [];
  String _centroDefault = '';
  String palletCaptured = '';
  late Embarque embarqueSelected;
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
  }

  //Peticiones API
  Future<List<Centros>> getCatalogs() async {
    _isLoadingCatalogs = true;
    result = false;
    print('Peticion ReciboEmbarque - Get Catalogs');
    _endPoint = '/api/v1/reciboembarque';
    embarques = [];

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
          _isLoadingCatalogs = false;
          print('200: Catalogs ${response.body}');
          reciboEmbarqueResponse =
              ReciboEmbarqueResponse.fromJson(response.body);
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
          _isLoadingCatalogs = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showFloatingSnackBar(
            (serverResponse?.message != null || serverResponse?.message != '')
                ? serverResponse!.message!
                : 'Error de Autenticación.',
          );
          break;
        case 404:
          _isLoadingCatalogs = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showFloatingSnackBar(serverResponse?.message ?? 'Error 404.');
          notifyListeners();
          print('404: ${response.body}');
          break;
        case 422:
          _isLoadingCatalogs = false;
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

          Notifications.showFloatingSnackBar(messages);
          notifyListeners();
          break;
        case 500:
          _isLoadingCatalogs = false;
          result = false;
          Notifications.showFloatingSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          _isLoadingCatalogs = false;
          result = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      _isLoadingCatalogs = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showFloatingSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return centrosUsuario ?? [];
  }

  Future<List<Embarque>> searchEmbarques() async {
    print('Peticion ReciboEmbarque Search');
    _endPoint = '/api/v1/reciboembarque/search';
    embarques = [];

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
          .post(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          isLoading = false;
          print('200: ${response.body}');
          reciboEmbarqueResponse =
              ReciboEmbarqueResponse.fromJson(response.body);
          embarques = reciboEmbarqueResponse!.datos;
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
          Notifications.showFloatingSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showFloatingSnackBar(Preferences.truncateMessage(
              serverResponse?.message ?? 'Error Desconocido.'));
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
          Notifications.showFloatingSnackBar('500 Server Error.');
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
        Notifications.showFloatingSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return embarques ?? [];
  }

  Future<bool> guardarEmbarque() async {
    print('Peticion ReciboEmbarque Search');
    _endPoint = '/api/v1/reciboembarque';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    embarqueSelected.horaInicio = (embarqueSelected.id != null) ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(embarqueSelected.horaInicio!)) : DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    print(embarqueSelected.toJson());

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');
    
    try {
      isLoading = true;

    final response = await http
          .post(url, headers: headers, body: embarqueSelected.toJson())
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          isLoading = false;
          print('200: ${response.body}');
          reciboEmbarqueResponse = ReciboEmbarqueResponse.fromJson(response.body);
          embarqueSelected = reciboEmbarqueResponse!.dato!;
          notifyListeners();
          print('embarque guardado ${embarqueSelected.id}');
          searchEmbarques();
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showFloatingSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showFloatingSnackBar(Preferences.truncateMessage(
              serverResponse?.message ?? 'Error Desconocido.'));
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
          Notifications.showFloatingSnackBar(messages);
          break;
        case 500:
          isLoading = false;
          Notifications.showFloatingSnackBar('500 Server Error.');
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
        Notifications.showFloatingSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }

  Future<bool> isPalletCapturedValid() async {
    print('Captured Value $palletCaptured');
    print('Cuantos Pallets ${embarqueSelected.pallets!.length}');
    palletCaptured = Preferences.padNumberWithZeros(palletCaptured, 20);
    // Verificar si el palletCaptured está dentro de la lista de pallets
    var foundPallet = embarqueSelected.pallets!.firstWhere(
      (pallet) => pallet.numeroContenedor == palletCaptured,
      orElse: () => Pallet(),
    );
    print('foundPallet ${foundPallet.toJson()}');

    if (foundPallet.numeroContenedor != null) {
      if (foundPallet.estatus == 'DESCARGADO') {
        Notifications.showFloatingSnackBar(
            'El pallet $palletCaptured ya se encuentra registrado.');
        return false;
      }
      // Si encontramos el pallet, actualizamos su estatus a "DESCARGADO"
      foundPallet.estatus = 'DESCARGADO';
      final result = await guardarEmbarque();
      if(result) {
          Notifications.showFloatingSnackBar(
              'Pallet $palletCaptured fue Descargado correctamente.');
          notifyListeners(); // Notificamos a los oyentes que el estado ha cambiado
      } else {
        foundPallet.estatus = null;
      }
      return true; // Indicamos que el palletCaptured es válido
    } else {
      Notifications.showFloatingSnackBar(
          'El número de Pallet no se encuentra en el embarque.');
      return false; // Indicamos que el palletCaptured no está en la lista
    }
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

    print('******** EMBARQUE A CONTABILIZAR **********');
    print(embarqueSelected.toJson());

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .put(url, headers: headers, body: embarqueSelected.toJson())
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Contabilizar Embarque ${response.body}');
          Notifications.showFloatingSnackBar(serverResponse!.message!);
          searchEmbarques();
          notifyListeners();
          break;
        case 400:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showFloatingSnackBar(
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
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showFloatingSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showFloatingSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
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

          Notifications.showFloatingSnackBar(messages);
          notifyListeners();
          break;
        case 500:
          isLoading = false;
          print('500: ${response.body}');
          Notifications.showFloatingSnackBar('500 Server Error.');
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
        Notifications.showFloatingSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }

  logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    _navigationService.navigateTo(LoginScreen.routeName);
  }
}
