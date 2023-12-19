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

class MonitorInventarioTiendaProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoadingCatalogs = false;
  bool _isLoading = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  MonitorInventarioResponse? monitorInventarioResponse;
  bool result = false;
  String fecha1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String fecha2 = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<Inventario> inventarios = [];
  Inventario inventarioSelected = Inventario();
  Inventario inventario = Inventario();
  List<int> _posicionesSelected = [];

  List<int> get posicionesSelected => _posicionesSelected;

  set posicionesSelected(List<int> value) {
    _posicionesSelected = value;
    notifyListeners();
  }

  List<DetalleDetalle> _detallesMaterial = [];
  DetalleDetalle detalleMaterialSelected = DetalleDetalle();
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

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }

  List<DetalleDetalle> get detallesMaterial => _detallesMaterial;

  set detallesMaterial(List<DetalleDetalle> value) {
    _detallesMaterial = value;
  }

  MonitorInventarioTiendaProvider() {
    print('MonitorInventarioTienda Provider inicializado');
  }

  //Peticiones API
  Future<bool> searchByDates() async {
    isLoadingCatalogs = true;
    result = false;
    print('Peticion getInventarios - Search');
    _endPoint = '/api/v1/monitorinvtienda/buscar-inventarios';
    inventarios = [];
    posicionesSelected = [];

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'fecha_inicio': fecha1,
      'fecha_final': fecha2,
    };

    print(dataRaw);

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          print('Estatus: $isLoading');
          result = true;
          isLoadingCatalogs = false;
          print('200: Search Inventarios ${response.body}');
          monitorInventarioResponse =
              MonitorInventarioResponse.fromJson(response.body);
          inventarios = monitorInventarioResponse!.inventarios!;
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

  Future<bool> getInventario() async {
    isLoadingCatalogs = true;
    result = false;
    print('Peticion getInventario BD - Search');
    _endPoint = '/api/v1/monitorinvtienda/get-inventario';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {'id': inventarioSelected.id};

    print(dataRaw);

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          print('Estatus: $isLoading');
          result = true;
          isLoadingCatalogs = false;
          print(
              '200: GetInventario ${inventarioSelected.id}: ${response.body}');
          monitorInventarioResponse =
              MonitorInventarioResponse.fromJson(response.body);
          inventario = monitorInventarioResponse!.inventario!;
          Notifications.showSnackBar(monitorInventarioResponse!.messageUpdate!);
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

  Future<bool> saveOnSAP() async {
    isLoadingCatalogs = true;
    result = false;
    print('Peticion guardarSAP');
    _endPoint = '/api/v1/monitorinvtienda';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final dataRaw = SaveInventarioRequest(inventario: inventario);

    print(dataRaw.toJson());

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: dataRaw.toJson())
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          print('Estatus: $isLoading');
          result = true;
          isLoadingCatalogs = false;
          print('200: saveOnSAP: ${response.body}');
          // monitorInventarioResponse = MonitorInventarioResponse.fromJson(response.body);
          // inventario = monitorInventarioResponse!.inventario!;
          // Notifications.showFloatingSnackBar(monitorInventarioResponse!.messageUpdate!);
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

  Future<bool> saveInvDetails(InventarioDetalle detalle) async {
    isLoading = true;
    result = false;
    print('Peticion saveInvDetails');
    _endPoint = '/api/v1/monitorinvtienda/modificar-conteo';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    print(detalle.toJson());

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .put(url, headers: headers, body: detalle.toJson())
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          print('Estatus: $isLoading');
          result = true;
          isLoading = false;
          print('200: saveInvDetails: ${response.body}');
          monitorInventarioResponse =
              MonitorInventarioResponse.fromJson(response.body);
          inventarioSelected = monitorInventarioResponse!.inventario!;
          inventario = monitorInventarioResponse!.inventario!;
          Notifications.showSnackBar(monitorInventarioResponse!.message!);
          notifyListeners();
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

  Future<bool> closeInventories() async {
    isLoadingCatalogs = true;
    result = false;
    print('Peticion closeInventario');
    _endPoint = '/api/v1/monitorinvtienda/cerrar-inventario';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {'inventarios': posicionesSelected};

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
          print('200: closeInventario: ${response.body}');
          serverResponse = ServerResponse.fromJson(response.body);
          searchByDates();
          Notifications.showFloatingSnackBar('${serverResponse!.message}');
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

  Future<bool> recountRack(DetalleDetalle detalleMaterial, int id) async {
    isLoading = true;
    result = false;
    print('Peticion recontar Mueble');
    _endPoint = '/api/v1/monitorinvtienda/recontar-mueble';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'id': id,
      'cantidad': detalleMaterial.cantidad,
      'mueble': detalleMaterial.mueble,
      'responsable': detalleMaterial.responsable,
    };
    print(jsonEncode(dataRaw));
    // return false;

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .put(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          print('Estatus: $isLoading');
          result = true;
          isLoading = false;
          print('200: recontar Mueble: ${response.body}');
          monitorInventarioResponse =
              MonitorInventarioResponse.fromJson(response.body);
          inventarioSelected = monitorInventarioResponse!.inventario!;
          inventario = monitorInventarioResponse!.inventario!;
          detallesMaterial = monitorInventarioResponse!.materialDetalles!;
          Notifications.showSnackBar(monitorInventarioResponse!.message!);
          notifyListeners();
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

  void togglePositionSelected(int id) {
    if (_posicionesSelected.contains(id)) {
      _posicionesSelected.remove(id);
    } else {
      _posicionesSelected.add(id);
    }
    notifyListeners();
  }

  logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    _navigationService.navigateTo(LoginScreen.routeName);
  }
}
