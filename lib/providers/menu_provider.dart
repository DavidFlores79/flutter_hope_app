import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:http/http.dart' as http;

class ModulosProvider extends ChangeNotifier {
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  final String _endPoint = '/api/v1/home';
  String jwtToken = '';
  ModuleResponse? moduleResponse;
  ServerResponse? serverResponse;
  UnauthenticatedResponse? unauthenticatedResponse;
  List<CategoriasModulo> categorias = [];
  bool result = false;
  bool isLoading = false;

  final NavigationService _navigationService = locator<NavigationService>();

  final storage = const FlutterSecureStorage();

  ModulosProvider() {
    print('modulos provider inicializado');
    getModulosApp();
  }

  Future<bool> getModulosApp() async {
    isLoading = true;
    result = false;
    print('listado de Modulos');

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';
    print('Token Modulos: $jwtToken');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          final moduleResponse = ModuleResponse.fromJson(response.body);
          categorias = moduleResponse.categoriasModulos;
          notifyListeners();
          print(categorias);
          break;
        case 401:
          print('401 ${response.body.toString()}');
          isLoading = false;
          result = false;
          unauthenticatedResponse =
              UnauthenticatedResponse.fromJson(response.body);
          Notifications.showSnackBar(
              unauthenticatedResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          // moduleResponse = ServerResponse.fromJson(response.body);
          // Notifications.showSnackBar(
          //     moduleResponse?.message ?? 'Error Desconocido.');
          // pedidos = [];
          // pedidosXProv = [];
          // notifyListeners();
          // print(moduleResponse);
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
}
