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

class MaterialProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  bool result = false;
  MaterialResponse? materialResponse;
  List<Materials>? materials = [];
  Materials _materialSelected = Materials();
  String quantity = '';

  Materials get materialSelected => _materialSelected;

  set materialSelected(Materials value) {
    _materialSelected = value;
    notifyListeners();
  }

  final debouncer = Debouncer(duration: const Duration(milliseconds: 700));

  final StreamController<List<Materials>> _materialStreamController =
      new StreamController.broadcast();

  Stream<List<Materials>> get materialStream =>
      this._materialStreamController.stream;

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

  MaterialProvider() {
    print('MaterialProvider inicializado');
  }

  //Peticiones API
  Future<List<Materials>> searchMaterials(String query, String centroDefault, String moduleName ) async {
    print('Peticion API Search');
    _endPoint = '/api/v1/$moduleName/search';
    String numeroMaterial = '';
    String textoBreve = '';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    if (queryHasNumbers(query)) {
      numeroMaterial = query;
    } else {
      textoBreve = query;
    }

    final Map<String, dynamic> queryParameters = {
      'numero_material': numeroMaterial,
      'texto_breve': textoBreve,
      'centro': centroDefault,
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint', queryParameters);

    try {
      isLoading = true;
      materials = [];

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          isLoading = false;
          print('200: ${response.body}');
          materialResponse = MaterialResponse.fromJson(response.body);
          materials = materialResponse?.materials;
          notifyListeners();
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoading = false;
          materials = [];
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(Preferences.truncateMessage(serverResponse?.message ?? 'Error Desconocido.'));
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
          materials = [];
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
    return materials!;
  }

  Future<List<Materials>> searchMaterialsBySupplier(String query, String supplier, String centroDefault) async {
    print('Peticion API Search Material Supplier');
    _endPoint = '/api/v1/materials/supplier';
    String numeroMaterial = '';
    String textoBreve = '';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    if (queryHasNumbers(query)) {
      numeroMaterial = query;
    } else {
      textoBreve = query;
    }

    final Map<String, dynamic> queryParameters = {
      'numero_material': numeroMaterial,
      'texto_breve': textoBreve,
      'centro': centroDefault,
      'proveedor': supplier,
    };

    print(queryParameters);

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint', queryParameters);

    try {
      isLoading = true;
      materials = [];

      final response = await http
          .post(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          isLoading = false;
          print('200: ${response.body}');
          materialResponse = MaterialResponse.fromJson(response.body);
          materials = materialResponse?.materials;
          notifyListeners();
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoading = false;
          materials = [];
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(Preferences.truncateMessage(serverResponse?.message ?? 'Error Desconocido.'));
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
          materials = [];
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
    return materials!;
  }

  void getMaterialsByQuery(String query, String centroDefault, String moduleName) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      print('hay valor a buscar $value');
      final results = await searchMaterials(value, centroDefault, moduleName);
      _materialStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301)).then(
      (value) => timer.cancel(),
    );
  }

  void getMaterialsBySupplierQuery(String query, String supplier, String centroDefault) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      print('hay valor a buscar $value');
      final results = await searchMaterialsBySupplier(query, supplier, centroDefault );
      _materialStreamController.add(results);
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
