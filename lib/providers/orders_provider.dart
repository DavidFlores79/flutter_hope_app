import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:productos_app/models/error_response.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/ui/notifications.dart';

class OrdersProvider extends ChangeNotifier {
  final String _apiUrl = '205.251.136.75';
  final String _proyectName = '/HopeV200';
  final String _endPoint = '/api/v1/ordenes-pendientes';
  String jwtToken = '';
  List<Pedido> pedidos = [];
  ErrorResponse? errorResponse;

  final storage = const FlutterSecureStorage();

  OrdersProvider() {
    print('Ordenes provider inicializado');
    getOrdenes();
  }

  getOrdenes() async {
    print('listado de Ordenes');

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    final response = await http.post(url, headers: headers);

    switch (response.statusCode) {
      case 200:
        final ordersResponse = OrderResponse.fromJson(response.body);
        pedidos.addAll(ordersResponse.pedidos);
        print(pedidos);
        break;
      case 401:
        logout();
        break;
      case 404:
        errorResponse = ErrorResponse.fromJson(response.body);
        Notifications.showSnackBar(errorResponse!.message);
        notifyListeners();
        print(errorResponse);
        break;
      default:
        print(response.body);
    }
    notifyListeners();
  }

  Future logout() async {
    await storage.deleteAll();
    notifyListeners();
    return;
  }
}
