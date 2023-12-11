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
  bool result = false;
  String fecha1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String fecha2 = DateFormat('yyyy-MM-dd').format(DateTime.now());
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

  MonitorInventarioTiendaProvider() {
    print('MonitorInventarioTienda Provider inicializado');
  }

  //Peticiones API
  Future<bool> searchByDates() async {
    isLoadingCatalogs = true;
    result = false;
    print('Peticion getInventarios - Search');
    _endPoint = '/api/v1/monitorinvtienda/buscar-inventarios';

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
