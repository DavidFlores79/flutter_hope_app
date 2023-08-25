import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/models/migo_entrada_request.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/login_screen.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:http/http.dart' as http;

class MigoProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/ordenes-pendientes';
  String jwtToken = '';
  ServerResponse? serverResponse;
  bool result = false;
  bool contabilizarResult = false;
  String actividadSelected = 'A01';
  String documentoSelected = '';
  String claseSelected = '';
  String numeroPedido = '';
  String newValue = '99';
  late MigoOrderResponse migoResponse;
  late PedidoMigo pedido;
  List<Posicione> posicionesSelected = [];

  final NavigationService _navigationService = locator<NavigationService>();

  final storage = const FlutterSecureStorage();

  MigoProvider() {
    print('Migo provider inicializado');
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

  Future<bool> getPedido(String numero_pedido) async {
    isLoading = true;
    result = false;
    print('Peticion API');
    _endPoint = '/api/v1/migo/get-pedido';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';
    print('MIGO Token: $jwtToken');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final queryParameters = {
      'pedido': numero_pedido,
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint', queryParameters);

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));
      posicionesSelected = [];

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Pedido ${response.body}');
          migoResponse = MigoOrderResponse.fromJson(response.body);
          pedido = PedidoMigo.fromMap(migoResponse.pedidoMigo!.toMap());
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
          print(serverResponse);
          break;
        case 422:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print(serverResponse);
          break;
        case 500:
          isLoading = false;
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

  Future<bool> contabilizarEntrada() async {
    isLoading = true;
    contabilizarResult = false;
    print('Peticion API');
    _endPoint = '/api/v1/migo/contabilizar';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';
    print('Contabilizar MIGO Token: $jwtToken');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final Map<String, dynamic> authData = {
      'nickname': 'David Flores',
      'password': '123456'
    };

    final MigoEntrada101 pedidoContabilizar = MigoEntrada101(
      cabeceraPedido: pedido.cabeceraPedido,
      documentoPedido: pedido.documentoPedido,
      claseMovimiento: '101',
      posiciones: pedido.posiciones,
      fechaDoc: DateTime.now(),
      fechaCont: DateTime.now(),
    );

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: pedidoContabilizar.toJson())
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          isLoading = false;
          contabilizarResult = true;
          result = false;
          print('200: Pedido Contabilizado ${response.body}');
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(serverResponse?.message ??
              'Pedido ${pedido.documentoPedido} Contabilizado.');
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }

          isLoading = false;
          contabilizarResult = false;
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
          print(serverResponse);
          break;
        case 422:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print(serverResponse);
          break;
        case 500:
          isLoading = false;
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoading = false;
          contabilizarResult = false;
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
    return contabilizarResult;
  }

  logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    // Notifications.showSnackBar('Su sesión ha vencido.');
    _navigationService.navigateTo(LoginScreen.routeName);
  }

  updatePosQty(Posicione posicion) {
    posicion.cantidad = int.parse(newValue);
    notifyListeners();
  }
}
