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
import 'package:intl/intl.dart';

class LiberarSolpedProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  BuscarSolpedsResponse? solpedResponse;
  List<Posicion>? pedidos = [];
  List<int> _posicionesSelected = [];
  final DateTime now = DateTime.now();
  String _motivoRechazo = '';

  String get motivoRechazo => _motivoRechazo;

  set motivoRechazo(String value) {
    _motivoRechazo = value;
  }

  List<int> get posicionesSelected => _posicionesSelected;

  set posicionesSelected(List<int> value) {
    _posicionesSelected = value;
    notifyListeners();
  }

  bool result = false;
  final debouncer = Debouncer(duration: const Duration(milliseconds: 700));
  final NavigationService _navigationService = locator<NavigationService>();
  final storage = const FlutterSecureStorage();

  LiberarSolpedProvider() {
    print('Liberar Solped provider inicializado');
    // searchByDates();
  }
  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<List<Posicion>> searchByDates() async {
    isLoading = true;
    result = false;
    print('Peticion LIberar Solped - Search');
    _endPoint = '/api/v1/liberarsolped/buscar';
    final String formatedDate = DateFormat('yyyy-MM-dd').format(now);

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'fecha_desde': formatedDate,
      'fecha_hasta': formatedDate,
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
          print('200: Search Liberar Solped ${response.body}');
          solpedResponse = BuscarSolpedsResponse.fromJson(response.body);
          pedidos = solpedResponse!.pedidos;
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
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('422: ${response.body}');
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
    return pedidos!;
  }

  Future<List<Posicion>> releaseSolpeds() async {
    isLoading = true;
    result = false;
    print('Peticion LIberar Solped - Aprobar');
    _endPoint = '/api/v1/liberarsolped/aprobar';
    final String formatedDate = DateFormat('yyyy-MM-dd').format(now);

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'fecha_desde': formatedDate,
      'fecha_hasta': formatedDate,
      'solped_seleccionados': posicionesSelected,
    };

    print(dataRaw);
    print('Ordenes a Liberar ${posicionesSelected.length}');

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));

      posicionesSelected = [];

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Aprobar Liberar Solped ${response.body}');
          solpedResponse = BuscarSolpedsResponse.fromJson(response.body);
          Notifications.showSnackBar(
              solpedResponse?.message ?? 'Registros Liberados correctamente.');
          pedidos = solpedResponse!.pedidos;
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
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('422: ${response.body}');
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
    return pedidos!;
  }

  Future<List<Posicion>> rejectSolpeds() async {
    isLoading = true;
    result = false;
    print('Peticion LIberar Solped - Rechazar');
    _endPoint = '/api/v1/liberarsolped/rechazar';
    final String formatedDate = DateFormat('yyyy-MM-dd').format(now);

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'fecha_desde': formatedDate,
      'fecha_hasta': formatedDate,
      'solped_seleccionados': posicionesSelected,
      'motivo_rechazo': motivoRechazo
    };

    print(dataRaw);
    print('Ordenes a Rechazar ${posicionesSelected.length}');

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));

      posicionesSelected = [];

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Rechazar Solped ${response.body}');
          solpedResponse = BuscarSolpedsResponse.fromJson(response.body);
          Notifications.showSnackBar(
              solpedResponse?.message ?? 'Registros Rechazados correctamente.');
          pedidos = solpedResponse!.pedidos;
          notifyListeners();
          break;
        case 400:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('404: ${response.body}');
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
        // isLoading = false;
        // serverResponse = ServerResponse.fromJson(response.body);
        // Notifications.showSnackBar(
        //     serverResponse?.message ?? 'Error Desconocido.');
        // notifyListeners();
        // print('422: ${response.body}');
        // break;
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
    return pedidos!;
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
