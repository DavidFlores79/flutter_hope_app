import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/screens/home_screen.dart';
import 'package:hope_app/screens/pedidos_screen.dart';
import 'package:hope_app/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/login_screen.dart';
import 'package:hope_app/ui/notifications.dart';

class PedidosProvider extends ChangeNotifier {
  final String _apiUrl = '205.251.136.75';
  final String _proyectName = '/HopeV200';
  String _endPoint = '/api/v1/ordenes-pendientes';
  String jwtToken = '';
  List<Pedido> pedidos = [];
  List<PedidosProv> pedidosXProv = [];
  ServerResponse? serverResponse;
  bool result = false;
  bool isLoading = false;

  final NavigationService _navigationService = locator<NavigationService>();

  final storage = const FlutterSecureStorage();

  PedidosProvider() {
    print('Ordenes provider inicializado');
    getOrdenes();
  }

  Future<bool> getOrdenes() async {
    isLoading = true;
    result = false;
    pedidosXProv = [];
    print('listado de Ordenes');
    _endPoint = '/api/v1/ordenes-pendientes';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';
    //print('Token: $jwtToken');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers)
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          //final ordersResponse = OrderResponse.fromJson(response.body);
          final ordersResponseProv = PedidosProvModel.fromJson(response.body);
          //pedidos = [...ordersResponse.pedidos];
          pedidosXProv = [...ordersResponseProv.pedidosProv];
          notifyListeners();
          if (pedidosXProv.isEmpty) {
            Notifications.showSnackBar(
                "No se encontraron ordenes para mostrar");
          }
          print('200: ${pedidosXProv}');
          break;
        case 401:
          if (response.body.contains('code')) {
            serverResponse = ServerResponse.fromJson(response.body);
            Notifications.showSnackBar(
                serverResponse?.message ?? 'Error de Autenticación.');
          } else {
            pedidosXProv = [];
            logout();
            print('logout');
          }
          break;
        case 404:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          pedidos = [];
          pedidosXProv = [];
          notifyListeners();
          print(serverResponse);
          break;
        case 500:
          isLoading = false;
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print(response.body);
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

  Future<bool> liberarPedido(Pedido pedido) async {
    result = false;
    _endPoint = '/api/v1/ordenes-pendientes/liberar';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'lang': 'S',
      'order': pedido.pedido,
      // 'order': '4500002182',
      'code': pedido.codigoLiberacion,
      'responsable_sap': pedido.responsableSap
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));
      switch (response.statusCode) {
        case 200:
          result = true;
          final liberarPedidoResponse =
              LiberarPedidoResponse.fromJson(response.body);
          final pedidoLiberado = liberarPedidoResponse.pedidoLiberado;
          Notifications.showSnackBar(
              'El Pedido: ${pedidoLiberado?.pedido} ha sido liberado.');
          print('Pedido Liberado: $pedidoLiberado');
          break;
        case 401:
          if (response.body.contains('code')) {
            serverResponse = ServerResponse.fromJson(response.body);
            Notifications.showSnackBar(
                serverResponse?.message ?? 'Error de Autenticación.');
          } else {
            logout();
            print('logout');
          }
          break;
        case 400:
          print('Estatus: ${response.statusCode}');
          final liberarPedidoResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(liberarPedidoResponse.message!);
          print('Error Liberando: ${liberarPedidoResponse.message}');
          break;
        case 422:
          print('Validator: ${response.statusCode}');
          final liberarPedidoResponse =
              ValidatorResponse.fromJson(response.body);
          Notifications.showSnackBar(liberarPedidoResponse.message);
          break;
        case 500:
          Notifications.showSnackBar('500 Server Error');
          break;
        default:
          print(response.body);
      }
      //getOrdenes();

    } catch (e) {
      print('Error $e');
      Notifications.showSnackBar(e.toString());
    }

    return result;
  }

  Future<bool> liberarMultiple(
      List<Pedido> pedidos, String nombreProveedor) async {
    _endPoint = '/api/v1/ordenes-pendientes/liberar-multiple';
    result = false;

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    LiberarMultiple dataRaw =
        LiberarMultiple(pedidos: pedidos, proveedor: nombreProveedor);

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(dataRaw.toMap()))
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          result = true;
          print('Response pedidos liberados: ${response.body}');
          final liberarPedidoMultipleResponse =
              LiberarMultipleResponse.fromJson(response.body);
          Notifications.showSnackBar(
              'Los pedidos del Proveedor: $nombreProveedor se enviaron a liberación.');
          Timer(const Duration(seconds: 15), getOrdenes);
          Timer(const Duration(seconds: 20), getOrdenes);
          print(
              'Pedidos Enviados: ${liberarPedidoMultipleResponse.orders.length}');
          break;
        case 401:
          if (response.body.contains('code')) {
            serverResponse = ServerResponse.fromJson(response.body);
            Notifications.showSnackBar(
                serverResponse?.message ?? 'Error de Autenticación.');
          } else {
            logout();
            print('logout');
          }
          break;
        case 400:
          print('Estatus Multiple: ${response.statusCode}');
          final liberarPedidoResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(liberarPedidoResponse.message!);
          print('Error Liberando Multiple: ${liberarPedidoResponse.message}');
          break;
        case 422:
          print('Validator: ${response.statusCode}');
          final liberarPedidoResponse =
              ValidatorResponse.fromJson(response.body);
          Notifications.showSnackBar(liberarPedidoResponse.errors.toJson());
          break;
        case 500:
          Notifications.showSnackBar('500 Server Error');
          break;
        default:
          print(response.statusCode);
          print(response.body);
      }
      await getOrdenes();
    } catch (e) {
      print('Error $e');
      Notifications.showSnackBar(e.toString());
    }

    return result;
  }

  logout() async {
    await storage.deleteAll();
    Notifications.showSnackBar('Su sesión ha vencido.');
    _navigationService.navigateTo(LoginScreen.routeName);
  }
}
