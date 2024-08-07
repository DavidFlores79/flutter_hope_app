import 'dart:async';
import 'dart:convert';

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

class SolpedProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _inProgress = false;
  bool _isLoading = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  bool result = false;
  SolpedResponse? solpedResponse;
  MaterialResponse? materialResponse;
  List<Centro>? centrosUsuario = [];
  String centroDefault = Preferences.defaultCenter;
  String claseDocumento = 'NB';
  List<Posicion>? posiciones = [];
  List<Posiciones> posicionesSelected = [];
  List<Materials>? materials = [];
  Materials _materialSelected = Materials();
  String quantity = '';

  Materials get materialSelected => _materialSelected;

  set materialSelected(Materials value) {
    _materialSelected = value;
    notifyListeners();
  }

  final debouncer = Debouncer(duration: const Duration(milliseconds: 700));

  final StreamController<List<Materials>> _materialStreamController =
      new StreamController.broadcast();

  Stream<List<Materials>> get materialStream =>
      this._materialStreamController.stream;

  final NavigationService _navigationService = locator<NavigationService>();

  final storage = const FlutterSecureStorage();

  SolpedProvider() {
    print('Solped provider inicializado');
    getCatalogs();
  }

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
  }

  get inProgress => _inProgress;
  set inProgress(value) {
    _inProgress = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<bool> getCatalogs() async {
    isLoading = true;
    result = false;
    print('Peticion Solped - Get Catalogs');
    _endPoint = '/api/v1/solped';

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
      posicionesSelected = [];
      posiciones = [];

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: get Catalogs ${response.body}');
          solpedResponse = SolpedResponse.fromJson(response.body);
          posiciones = solpedResponse?.posiciones;
          centrosUsuario = solpedResponse?.centrosUsuario;
          claseDocumento = solpedResponse?.claseDocumento?.code ?? 'NB';

          if (centrosUsuario != null) {
            centroDefault = centrosUsuario![0].idcentro!;
            print('CentroDefault $centroDefault');
          }
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
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
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

  Future<List<Posicion>> getSolpeds() async {
    isLoading = true;
    result = false;
    print('Peticion Solped - Get Catalogs');
    _endPoint = '/api/v1/solped';

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
      posicionesSelected = [];
      posiciones = [];

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: getSolpeds ${response.body}');
          solpedResponse = SolpedResponse.fromJson(response.body);
          posiciones = solpedResponse?.posiciones;
          centrosUsuario = solpedResponse?.centrosUsuario;
          if (centrosUsuario != null) {
            centroDefault = centrosUsuario![0].idcentro!;
          }
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
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
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
    return posiciones!;
  }

  Future<bool> createSolped() async {
    isLoading = true;
    result = false;
    print('Peticion Solped - Create');
    _endPoint = '/api/v1/solped';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'centro': centroDefault,
      'clase_doc': claseDocumento,
      'cuenta_mayor': materialSelected.cuentamayor,
      'texto_breve': materialSelected.textoBreve,
      'gpo_articulo': materialSelected.grupoArticulo,
      'gpo_compras': materialSelected.grupoCompras,
      'material': materialSelected.numeroMaterial,
      'tipo_material': materialSelected.tipoMaterial,
      'unidad_medida': materialSelected.unidadMedidaTexto,
      'cantidad': quantity,
      'activo_fijo': null,
      'comentarios': null,
    };

    print(dataRaw);

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Create Solped ${response.body}');
          solpedResponse = SolpedResponse.fromJson(response.body);
          posiciones = solpedResponse!.posiciones;
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
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
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
            print('error: $error');
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
          print('500: ${response.body}');
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

  Future<bool> updateSolped(Posicion posicion) async {
    isLoading = true;
    result = false;
    print('Peticion Solped - Update');
    _endPoint = '/api/v1/solped';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    if (quantity == '') {
      Notifications.showSnackBar('No se realizó ningún cambio');
      return false;
    }

    Map<String, dynamic> dataRaw = {
      'id': posicion.id,
      'cantidad': quantity,
      'activo_fijo': null,
      'comentarios': null,
    };

    print(dataRaw);

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');
    print('url: $url');
    try {
      final response = await http
          .put(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Update Solped ${response.body}');
          solpedResponse = SolpedResponse.fromJson(response.body);
          posiciones = solpedResponse!.posiciones;
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
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
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

          Notifications.showSnackBar(messages);
          notifyListeners();
          break;
        case 500:
          isLoading = false;
          print('500: ${response.body}');
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

  Future<bool> deleteSolped(int id) async {
    isLoading = true;
    result = false;
    print('Peticion Solped - Delete');
    _endPoint = '/api/v1/solped';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'id': '$id',
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .delete(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: DeleteSolped ${response.body}');
          solpedResponse = SolpedResponse.fromJson(response.body);
          posiciones = solpedResponse?.posiciones;
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
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
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

          Notifications.showSnackBar(messages);
          notifyListeners();
          break;
        case 500:
          isLoading = false;
          print('500: ${response.body}');
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

  bool queryHasNumbers(String query) {
    // Comprueba si el String solo contiene números
    if (RegExp(r'^[0-9]+$').hasMatch(query)) {
      return true;
    } else {
      return false;
    }
  }

  logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    _navigationService.navigateTo(LoginScreen.routeName);
  }
}
