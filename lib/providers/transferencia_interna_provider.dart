import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:http/http.dart' as http;

class TransferenciaInternaProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoadingCatalogs = false;
  bool _isLoading = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  bool result = false;
  MaterialResponse? materialResponse;
  TransferenciasInternasResponse? transferenciasInternasResponse;
  List<Centros>? centrosUsuario = [];
  String _centroDefault = '';
  Materials _materialSelectedFrom = Materials();
  Materials _materialSelectedTo = Materials();
  String quantityFrom = '';
  String quantityTo = '';
  String orgComprasFrom = '1000';
  String referencia = '';
  List<OrgCompras> _orgCompras = [];
  List<TransferenciaInterna> transferencias = [];
  String _orgComprasSelected = '';

  final NavigationService _navigationService = locator<NavigationService>();

  final storage = const FlutterSecureStorage();

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  get isLoading => _isLoading;

  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLoadingCatalogs => _isLoadingCatalogs;

  set isLoadingCatalogs(bool value) {
    _isLoadingCatalogs = value;
  }

  String get centroDefault => _centroDefault;

  set centroDefault(String value) {
    _centroDefault = value;
    notifyListeners();
  }

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }

  Materials get materialSelectedTo => _materialSelectedTo;

  set materialSelectedTo(Materials value) {
    _materialSelectedTo = value;
    notifyListeners();
  }

  Materials get materialSelectedFrom => _materialSelectedFrom;

  set materialSelectedFrom(Materials value) {
    _materialSelectedFrom = value;
    notifyListeners();
  }

  String get orgComprasSelected => _orgComprasSelected;

  set orgComprasSelected(String value) {
    _orgComprasSelected = value;
    notifyListeners();
  }

  List<OrgCompras> get orgCompras => _orgCompras;

  set orgCompras(List<OrgCompras> value) {
    _orgCompras = value;
    // notifyListeners();
  }

  TransferenciaInternaProvider() {
    print('TransferenciaInterna Provider inicializado');
  }

  //Peticiones API
  Future<bool> getCatalogs() async {
    isLoadingCatalogs = true;
    result = false;
    print('Peticion Trans.Internas - Get Catalogs');
    _endPoint = '/api/v1/transferenciasinternas';
    orgCompras = [];

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoadingCatalogs = false;
          transferenciasInternasResponse =
              TransferenciasInternasResponse.fromJson(response.body);
          centroDefault = transferenciasInternasResponse!.centrosUsuario!.first.idcentro!;
          orgCompras = transferenciasInternasResponse!.orgCompras!;
          orgComprasSelected = orgCompras.first.code!;
          // $scope.referencia =  $scope.centroUsuario + "965" + $scope.userlog;
          referencia = '${centroDefault}965${transferenciasInternasResponse!.userlog!}';
          transferencias = [];
          print('200: Catalogs ${response.body}');
          notifyListeners();
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoadingCatalogs = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
            (serverResponse?.message != null || serverResponse?.message != '')
                ? serverResponse!.message!
                : 'Error de Autenticación.',
          );
          break;
        case 404:
          isLoadingCatalogs = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(serverResponse?.message ?? 'Error 404.');
          notifyListeners();
          print('404: ${response.body}');
          break;
        case 422:
          isLoadingCatalogs = false;
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
          isLoadingCatalogs = false;
          result = false;
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoadingCatalogs = false;
          result = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isLoadingCatalogs = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }

  Future<bool> storeTransfers() async {
    print('Peticion Store Transferencia Interna');
    _endPoint = '/api/v1/transferenciasinternas';
    isLoading = true;
    result = false;

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final List<Map<String, dynamic>> transferenciasMap = transferencias.map((transferencia) => transferencia.toMap()).toList();
    print(jsonEncode(transferenciasMap));
    // isLoading = false;
    // return false;

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      isLoading = true;

      final response = await http.post(url,
          headers: headers, body: jsonEncode(transferenciasMap)).timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          isLoading = false;
          result = true;
          print('200: ${response.body}');
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showFloatingSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          transferencias = [];
          notifyListeners();
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showFloatingSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showFloatingSnackBar(Preferences.truncateMessage(
              serverResponse?.message ?? 'Error Desconocido.'));
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
          Notifications.showFloatingSnackBar(messages);
          break;
        case 500:
          isLoading = false;
          result = false;
          Notifications.showFloatingSnackBar('500 Server Error.');
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
        Notifications.showFloatingSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }

  bool queryHasNumbers(String query) {
    // Comprueba si el String solo contiene números
    if (RegExp(r'^[0-9]+$').hasMatch(query)) {
      return true;
    } else {
      return false;
    }
  }

  bool addTransfer() {
    try {
      final TransferenciaInterna transferencia = TransferenciaInterna(
        de: A(
          numeroMaterial: materialSelectedFrom.numeroMaterial,
          textoBreve: materialSelectedFrom.textoBreve,
          almacen: orgComprasFrom,
          cantidad: int.parse(quantityFrom),
          umeSap: materialSelectedFrom.umeSap,
          umeComercial: materialSelectedFrom.umeComercial,
        ),
        a: A(
          numeroMaterial: materialSelectedTo.numeroMaterial,
          textoBreve: materialSelectedFrom.textoBreve,
          almacen: orgComprasSelected,
          cantidad: int.parse(quantityTo),
          umeComercial: materialSelectedTo.umeComercial,
          umeSap: materialSelectedTo.umeSap,
        ),
        referencia: '12312312',
      );
      transferencias.add(transferencia);
      Notifications.showFloatingSnackBar('Transferencia Agregada');
      return true;
    } catch (e) {
      Notifications.showFloatingSnackBar('Error: $e');
      return false;
    }

  }

  logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    _navigationService.navigateTo(LoginScreen.routeName);
  }
}
