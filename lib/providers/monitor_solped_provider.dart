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

class MonitorSolpedProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  bool result = false;
  SolpedResponse? solpedResponse;
  String claseDocumento = 'ZADQ';
  List<Posicion>? pedidos = [];
  late String fecha1 = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(const Duration(days: 1)));

  late String fecha2 = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final debouncer = Debouncer(duration: const Duration(milliseconds: 700));

  final NavigationService _navigationService = locator<NavigationService>();

  final storage = const FlutterSecureStorage();

  MonitorSolpedProvider() {
    // ignore: avoid_print
    print('Monitor Solped  provider inicializado');
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
    // print(fecha1);
    // print(fecha2);
    isLoading = true;

    // ignore: avoid_print
    print("Voy a buscar solpeds");
    result = false;
    _endPoint = '/api/v1/monitor-solped';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'clase': 'ZADQ',
      'fecha_inicio': fecha1,
      'fecha_fin': fecha2,
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));
      pedidos = [];

      // print(response.body);
      switch (response.statusCode) {
        case 200:
          result = true;
          solpedResponse = SolpedResponse.fromJson(response.body);
          pedidos = solpedResponse?.posiciones;
          print(pedidos);
          // if (pedidos?.isNotEmpty == true) {
          //   Notifications.showSnackBar('Solpeds Encontrados');
          // } else {
          //   Notifications.showSnackBar('No se encontraron Solpeds Encontrados');
          // }
          notifyListeners();
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
          final solpedResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(solpedResponse.message!);
          print('Error Liberando: ${solpedResponse.message}');
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
    notifyListeners();
    isLoading = false;
    return pedidos!;
  }

  logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    _navigationService.navigateTo(LoginScreen.routeName);
  }
}
