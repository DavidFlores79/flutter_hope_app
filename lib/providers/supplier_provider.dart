import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/helpers/debouncer.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:http/http.dart' as http;

class SupplierProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  bool result = false;
  SupplierSearchResponse? supplierResponse;
  List<Supplier>? suppliers = [];
  Supplier _supplierSelected = Supplier();
  String quantity = '';

  Supplier get supplierSelected => _supplierSelected;

  set supplierSelected(Supplier value) {
    _supplierSelected = value;
    notifyListeners();
  }

  final debouncer = Debouncer(duration: const Duration(milliseconds: 700));

  final StreamController<List<Supplier>> _supplierStreamController =
      new StreamController.broadcast();

  Stream<List<Supplier>> get supplierStream =>
      this._supplierStreamController.stream;

  final NavigationService _navigationService = locator<NavigationService>();

  final storage = const FlutterSecureStorage();

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  SupplierProvider() {
    print('SupplierProvider inicializado');
  }

  //Peticiones API
  Future<List<Supplier>> searchSupplier(String query) async {
    print('Peticion API Search');
    _endPoint = '/api/v1/me21n/supplier';
    String name = '';
    String supplier = '';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    if (queryHasNumbers(query)) {
      supplier = Preferences.padNumberWithZeros(query, 10);
    } else {
      name = query;
    }

    final Map<String, dynamic> queryParameters = {
      'name': name,
      'supplier': supplier,
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint', queryParameters);

    try {
      isLoading = true;
      suppliers = [];

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          isLoading = false;
          print('200: ${response.body}');
          supplierResponse = SupplierSearchResponse.fromJson(response.body);
          suppliers = supplierResponse?.datos;
          notifyListeners();
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoading = false;
          suppliers = [];
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message?.substring(0, 60) ??
                  'Error Desconocido.');
          notifyListeners();
          print('404 ${serverResponse?.message}');
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
          break;
        case 500:
          isLoading = false;
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoading = false;
          suppliers = [];
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
    return suppliers!;
  }

  void getSupplierByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      print('hay valor a buscar $value');
      final results = await searchSupplier(value);
      _supplierStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301)).then(
      (value) => timer.cancel(),
    );
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