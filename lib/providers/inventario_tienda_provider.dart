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
  bool _isLoading = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  InventarioResponse? inventarioResponse;
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

  bool get isLoadingCatalogs => _isLoadingCatalogs;

  set isLoadingCatalogs(bool value) {
    _isLoadingCatalogs = value;
  }

  String get centroDefault => _centroDefault;

  set centroDefault(String value) {
    _centroDefault = value;
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
      // 'fecha_inicio': fecha1,
      // 'fecha_final': fecha2,
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
          print('200: Search Inventario ${response.body}');
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

  logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    _navigationService.navigateTo(LoginScreen.routeName);
  }
}
