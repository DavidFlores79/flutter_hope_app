import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  final storage = const FlutterSecureStorage();

  PedidosProvider() {
    print('Ordenes provider inicializado');
    getOrdenes();
  }

  getOrdenes() async {
    //print('listado de Ordenes');
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
      final response = await http.post(url, headers: headers);

      switch (response.statusCode) {
        case 200:
          //final ordersResponse = OrderResponse.fromJson(response.body);
          final ordersResponseProv = PedidosProvModel.fromJson(response.body);
          //pedidos = [...ordersResponse.pedidos];
          pedidosXProv = [...ordersResponseProv.pedidosProv];
          print(pedidosXProv);
          break;
        case 401:
          logout();
          print('logout');
          break;
        case 404:
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido');
          notifyListeners();
          print(serverResponse);
          break;
        default:
          print(response.body);
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
    }
  }

  liberarPedido(Pedido pedido) async {
    //print('Liberar Pedido: ${pedido.pedido}');
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
      'code': pedido.codigoLiberacion,
      'responsable_sap': pedido.responsableSap
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(dataRaw));

      switch (response.statusCode) {
        case 200:
          final liberarPedidoResponse =
              LiberarPedidoResponse.fromJson(response.body);
          Message pedidoLiberado = liberarPedidoResponse.message;
          Notifications.showSnackBar(
              'El Pedido: ${pedidoLiberado.pedido} ha sido liberado.');
          print('Pedido Liberado: ${pedidoLiberado.pedido}');
          break;
        case 401:
          logout();
          break;
        case 400:
          final errorLiberarPedidoResponse =
              ErrorLiberarPedidoResponse.fromJson(response.body);
          Notifications.showSnackBar(errorLiberarPedidoResponse.message);
          print('Error Liberando: ${errorLiberarPedidoResponse.message}');
          break;
        default:
          print(response.body);
      }
      getOrdenes();
    } catch (e) {
      print('Error $e');
    }
  }

  liberarMultiple(List<Pedido> pedidos, String nombreProveedor) async {
    //print('Liberar Pedido: ${pedido.pedido}');
    _endPoint = '/api/v1/ordenes-pendientes/liberar-multiple';

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
      final response = await http.post(url,
          headers: headers, body: jsonEncode(dataRaw.toMap()));

      switch (response.statusCode) {
        case 200:
          print('Response pedidos liberados: ${response.body}');
          final liberarPedidoMultipleResponse =
              LiberarMultipleResponse.fromJson(response.body);
          Notifications.showSnackBar(
              'Los pedidos del Proveedor: $nombreProveedor han sido liberados.');
          print('Pedidos Liberados: ${pedidos.length}');
          break;
        case 401:
          logout();
          break;
        case 400:
          final errorLiberarPedidoResponse =
              ErrorLiberarPedidoResponse.fromJson(response.body);
          Notifications.showSnackBar(errorLiberarPedidoResponse.message);
          notifyListeners();
          print('Error Liberando: $errorLiberarPedidoResponse');
          break;
        default:
          print(response.statusCode);
          print(response.body);
      }

      getOrdenes();
    } catch (e) {
      print('Error $e');
    }
  }

  Future logout() async {
    await storage.deleteAll();
    navigatorKey.currentState?.pushReplacementNamed(LoginScreen.routeName);
    notifyListeners();
  }
}
