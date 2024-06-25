import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:hope_app/ui/notifications.dart';

class AuthService extends ChangeNotifier {
  ServerResponse? serverResponse;
  LoginResponse? loginResponse;
  String result = '';
  bool resultQuery = false;
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
  }

  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  final storage = const FlutterSecureStorage();
  final NavigationService _navigationService = locator<NavigationService>();

  Future<String?> loginUser(String nickname, String password) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final Map<String, dynamic> authData = {
      'nickname': nickname,
      'password': password
    };

    final url = Uri.http(_apiUrl, '$_proyectName/api/login', authData);
    print('URL: $url');
    try {
      final response = await http
          .post(url, body: json.encode(authData), headers: headers)
          .timeout(const Duration(seconds: 20));
      print('response ${response.body}');

      final Map<String, dynamic> decodedResp = json.decode(response.body);

      switch (response.statusCode) {
        case 200:
          result = "true";
          print('200: Login ${response.body}');
          loginResponse = LoginResponse.fromJson(response.body);
          //guardar el token y la info del usuario
          await storage.write(
            key: 'jwtToken',
            value: loginResponse!.jwt,
          );

          if (loginResponse!.wss != null) {
            await storage.write(
              key: 'wssToken',
              value: loginResponse!.wss!.token,
            );
            Preferences.wssServer = loginResponse!.wss!.server ?? '';
          }

          Preferences.apiUser = jsonEncode(decodedResp['user']);
          Preferences.defaultCenter = (loginResponse!.user!.centros!.isNotEmpty)
              ? loginResponse!.user!.centros![0].idcentro!
              : 'XXXX';

          Preferences.expirationDate =
              Preferences.timestampToDate(loginResponse!.exp!);
          break;
        case 401:
          print('401: ${response.body}');
          serverResponse = ServerResponse.fromJson(response.body);
          result = serverResponse!.message!;
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          // result = false;
          // serverResponse = ServerResponse.fromJson(response.body);
          // Notifications.showSnackBar(
          //     serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 400:
          // serverResponse = ServerResponse.fromJson(response.body);
          // Notifications.showSnackBar(
          //     serverResponse?.message ?? 'Error Desconocido.');
          // notifyListeners();
          serverResponse = ServerResponse.fromJson(response.body);
          result = serverResponse!.message!;
          print('400: ${response.body}');
          break;
        case 404:
          // serverResponse = ServerResponse.fromJson(response.body);
          // Notifications.showSnackBar(
          //     serverResponse?.message ?? 'Error Desconocido.');
          // notifyListeners();
          serverResponse = ServerResponse.fromJson(response.body);
          result = serverResponse!.message!;
          print('404: ${response.body}');
          break;
        case 422:
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

          // Notifications.showSnackBar(messages);
          result = messages;
          notifyListeners();
          break;
        case 500:
          print('500: ${response.body}');
          serverResponse = ServerResponse.fromJson(response.body);
          result = serverResponse!.message!;
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          serverResponse = ServerResponse.fromJson(response.body);
          result = serverResponse!.message!;
          result = "Error Desconocido!!";
      }
      notifyListeners();
      return result;
    } catch (e) {
      print('500 ***: $e');
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar('Tiempo de espera agotado');
      } else {
        Notifications.showSnackBar('500 $e');
      }
    }
  }

  Future<bool> cleanSessionId() async {
    isLoading = true;
    resultQuery = false;
    print('Logout del Backend');
    const String endPoint = '/api/logout';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = Uri.http(_apiUrl, '$_proyectName$endPoint');

    try {
      final response = await http
          .post(url, headers: headers)
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          print('200: Logout Realizado!! ${response.body}');
          await logout();
          resultQuery = true;
          isLoading = false;
          Notifications.showSnackBar('Se cerró correctamente la sessión');
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoading = false;
          resultQuery = false;
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
          resultQuery = false;
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
          resultQuery = false;
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
    return resultQuery;
  }

  logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    _navigationService.navigateTo(LoginScreen.routeName);
  }

  Future<String> getToken() async {
    final DateTime expirationDate = DateTime.parse(Preferences.expirationDate);
    final DateTime now = DateTime.now();
    if (now.compareTo(expirationDate) > 0) {
      Preferences.apiUser = '';
      return '';
    }
    return await storage.read(key: 'jwtToken') ?? '';
  }
}
