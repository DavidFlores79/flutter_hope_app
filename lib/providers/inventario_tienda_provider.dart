import 'dart:async';
import 'dart:convert';
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

class InventarioTiendaProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoadingCatalogs = false;
  bool _isSaving = false;
  bool _isLoading = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  ValidateBarcodeResponse? validateBarcodeResponse;
  ValidateMaterialWithCenterResponse? validateMaterialCenter;
  InventarioResponse? inventarioResponse;
  bool result = false;
  List<Centros>? centrosUsuario = [];
  List<InventarioSAP>? inventarios = [];
  String _centroDefault = '';
  String _material = '';
  String _rack = '';
  String _barCode = '';
  IMdetalle _materialContado = IMdetalle();
  InventarioSAP cabecera = InventarioSAP();
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

  bool get isLoadingCatalogs => _isLoadingCatalogs;

  set isLoadingCatalogs(bool value) {
    _isLoadingCatalogs = value;
  }

  String get centroDefault => _centroDefault;

  set centroDefault(String value) {
    _centroDefault = value;
  }

  String get barCode => _barCode;

  set barCode(String value) {
    _barCode = value;
  }

  String get rack => _rack;

  set rack(String value) {
    _rack = value;
  }

  String get material => _material;

  set material(String value) {
    _material = value;
  }

  IMdetalle get materialContado => _materialContado;

  set materialContado(IMdetalle value) {
    _materialContado = value;
    notifyListeners();
  }

  bool get isSaving => _isSaving;

  set isSaving(bool value) {
    _isSaving = value;
  }

  InventarioTiendaProvider() {
    print('InventarioTienda Provider inicializado');
  }

  //Peticiones API
  Future<List<Centros>> getCatalogs() async {
    _isLoadingCatalogs = true;
    result = false;
    print('Peticion Inventario Tienda - Get Catalogs');
    _endPoint = '/api/v1/inventariotienda';

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
          inventarioResponse = InventarioResponse.fromJson(response.body);
          centrosUsuario = inventarioResponse!.centrosUsuario;
          centroDefault = centrosUsuario!.first.idcentro!;
          materialContado = IMdetalle();
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
          Notifications.showFloatingSnackBar(
              serverResponse?.message ?? 'Error 404.');
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

  Future<bool> searchInventory() async {
    isLoadingCatalogs = true;
    result = false;
    print('Inventario Tienda - Search');
    _endPoint = '/api/v1/inventariotienda/get-inventario';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'cabecera': {
        'fecha': fecha,
        'centro': centroDefault,
      }
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
          isLoadingCatalogs = false;
          print('200: Search Inventario ${response.body}');
          inventarioResponse = InventarioResponse.fromJson(response.body);
          inventarios = inventarioResponse!.respuestaSap!.inventarios;
          notifyListeners();
          break;
        case 400:
          isLoadingCatalogs = false;
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
          isLoadingCatalogs = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoadingCatalogs = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('404: ${response.body}');
          break;
        case 422:
          isLoadingCatalogs = false;
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
          isLoadingCatalogs = false;
          print('500: ${response.body}');
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              '500 Server Error. ${serverResponse!.message}');
          break;
        default:
          print('Default: ${response.body}');
          isLoadingCatalogs = false;
          result = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isLoadingCatalogs = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }

  Future<bool> validateBarcode() async {
    isLoadingCatalogs = true;
    result = false;
    print('Inventario Tienda - Validate Barcode');
    _endPoint = '/api/v1/inventariotienda/valida-codigo-barras';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'codigo_barra': barCode,
      'mueble': rack,
      'fecha': fecha,
      'centro': centroDefault,
    };

    if (dataRaw['codigo_barra'].isEmpty ||
        dataRaw['mueble'].isEmpty ||
        dataRaw['fecha'].isEmpty ||
        dataRaw['centro'].isEmpty) {
      Notifications.showSnackBar(
          'Los valores necesarios para la consulta no están completos. Favor de Validar');
      return false;
    }

    print(dataRaw);

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoadingCatalogs = false;
          print('200: Validate Barcode ${response.body}');
          validateBarcodeResponse =
              ValidateBarcodeResponse.fromJson(response.body);

          /**Si el articulo es encontrado en SAP se valida
           * el numero de material. Si no es encontrador retornara
           * un SIN MATERIAl, SIN DESCRIPCION y NOT_FOUD como estatus
          */
          if (validateBarcodeResponse!.respuestaApi!.estatus!) {
            validateMaterialWithCenter(
                validateBarcodeResponse!.respuestaApi!.inventarios!.first);
          } else {
            Notifications.showSnackBar(
                '${validateBarcodeResponse!.respuestaApi!.trace}');
            materialContado = validateBarcodeResponse!.articulo!;
          }
          notifyListeners();
          break;
        case 400:
          isLoadingCatalogs = false;
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
          isLoadingCatalogs = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoadingCatalogs = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('404: ${response.body}');
          break;
        case 422:
          isLoadingCatalogs = false;
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
          isLoadingCatalogs = false;
          print('500: ${response.body}');
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoadingCatalogs = false;
          result = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isLoadingCatalogs = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }

  Future<bool> validateMaterialWithCenter(
      MaterialInv materialInventario) async {
    isLoadingCatalogs = true;
    result = false;
    print('Inventario Tienda - validateMaterialWithCenter');
    _endPoint = '/api/v1/inventariotienda/valida-material-centro';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'detalles': {
        'material': materialInventario.material,
        'mueble': rack,
        'fecha': fecha,
        'centro': centroDefault,
      }
    };

    if (dataRaw['detalles']['material'].isEmpty ||
        dataRaw['detalles']['mueble'].isEmpty ||
        dataRaw['detalles']['fecha'].isEmpty ||
        dataRaw['detalles']['centro'].isEmpty) {
      Notifications.showSnackBar(
          'Los valores necesarios para la consulta no están completos. Favor de Validar');
      return false;
    }

    print('Material Inventario: $dataRaw');

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoadingCatalogs = false;
          print('200: validateMaterialWithCenter ${response.body}');
          validateMaterialCenter =
              ValidateMaterialWithCenterResponse.fromJson(response.body);
          materialContado = validateMaterialCenter!
              .respuestaApi!.inventarios!.first.inventarioimdet!.first;
          Notifications.showSnackBar(validateMaterialCenter!.message!);
          notifyListeners();
          break;
        case 400:
          isLoadingCatalogs = false;
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
          isLoadingCatalogs = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoadingCatalogs = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('404: ${response.body}');
          break;
        case 422:
          isLoadingCatalogs = false;
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
          isLoadingCatalogs = false;
          print('500: ${response.body}');
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoadingCatalogs = false;
          result = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isLoadingCatalogs = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }

  Future<bool> saveCounting() async {
    isSaving = true;
    result = false;
    print('Inventario Tienda - saveCounting');
    _endPoint = '/api/v1/inventariotienda';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    if (inventarios!.isNotEmpty) {
      cabecera = inventarios!.first;
    }

    Map<String, dynamic> dataRaw = {
      'cabecera': {
        'idcabecera': cabecera.idcabecera,
        'centro': cabecera.centro,
        'fecha': cabecera.fecha,
      },
      'material': {
        'material': materialContado.material,
        'codbar': barCode,
        'cantidad': materialContado.cantidad,
        'descripcion': materialContado.descripcion,
        'mueble': rack,
      }
    };

    print('saveCounting: $dataRaw');

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          result = true;
          isSaving = false;
          print('200: saveCounting ${response.body}');
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(serverResponse!.message!);
          notifyListeners();
          break;
        case 400:
          isSaving = false;
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
          isSaving = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isSaving = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('404: ${response.body}');
          break;
        case 422:
          isSaving = false;
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
          isSaving = false;
          print('500: ${response.body}');
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isSaving = false;
          result = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isSaving = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
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
