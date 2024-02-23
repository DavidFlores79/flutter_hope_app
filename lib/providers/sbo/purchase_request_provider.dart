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

class PurchaseRequestProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoadingCatalogs = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  bool result = false;

  PurchaseRequestResponse? purchaseRequestResponse;
  StorePurchaseReqResponse? storePurchaseResponse;
  SBO_ItemsResponse? itemResponse;
  List<SBO_Warehouse>? warehouses = [];
  String defaultWarehouse = '';
  DocumentLine newDocumentLine = DocumentLine();
  List<DocumentLine>? documentLines = [];
  List<DocumentLine> documentLinesSelected = [];
  List<SBO_Item>? items = [];
  String quantity = '';

  SBO_Item _itemSelected = SBO_Item();

  SBO_Item get itemSelected => _itemSelected;

  set itemSelected(SBO_Item value) {
    _itemSelected = value;
    notifyListeners();
  }

  final debouncer = Debouncer(duration: const Duration(milliseconds: 700));
  final NavigationService _navigationService = locator<NavigationService>();
  final storage = const FlutterSecureStorage();

  PurchaseRequestProvider() {
    print('PurchaseRequestProvider inicializado');
    getCatalogs();
  }

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
  }

  bool get isLoadingCatalogs => _isLoadingCatalogs;

  set isLoadingCatalogs(bool value) {
    _isLoadingCatalogs = value;
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<bool> getCatalogs() async {
    isLoading = true;
    result = false;
    print('PurchaseRequest - Get Catalogs');
    _endPoint = '/api/v1/purchase-request';

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
          isLoading = false;
          print('200: PurchaseRequest GetCatalogs ${response.body}');
          purchaseRequestResponse =
              PurchaseRequestResponse.fromJson(response.body);
          documentLines = purchaseRequestResponse!.data;
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
          result = false;
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
        case 500:
          isLoading = false;
          result = false;
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

  Future<bool> createSolped() async {
    isLoading = true;
    result = false;
    print('PurchaseRequest - Store');
    _endPoint = '/api/v1/purchase-request';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'item': {
        'Quantity': quantity,
        'ItemWarehouseInfoCollection': [
          {
            'WarehouseCode':
                itemSelected.itemWarehouseInfoCollection![0].warehouseCode
          }
        ],
        'InventoryUOM': itemSelected.inventoryUOM,
        'Comments': 'Creado en Hope Móvil',
        'ItemCode': itemSelected.itemCode,
        'ItemName': itemSelected.itemName,
      },
      'supplier': '',
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
          print('200: PurchaseRequest Store ${response.body}');
          storePurchaseResponse =
              StorePurchaseReqResponse.fromJson(response.body);
          newDocumentLine = storePurchaseResponse!.data!;
          documentLines!.add(newDocumentLine);
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
          result = false;
          print('422: ${response.body}');
          ValidatorResponse validatorResponse =
              ValidatorResponse.fromJson(response.body);
          final Map<String, dynamic> errors = validatorResponse.errors.toMap();
          String messages = '${validatorResponse.message}\n';

          Iterable<dynamic> values = errors.values;
          for (final error in values) {
            print('error: $error');
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
    return result;
  }

  Future<bool> updateSolped(DocumentLine documentLine) async {
    isLoading = true;
    result = false;
    print('PurchaseRequest - Update');
    _endPoint = '/api/v1/purchase-request';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    if (quantity == '') {
      Notifications.showSnackBar('No se realizo ningún cambio');
      return false;
    }

    Map<String, dynamic> dataRaw = {
      'id': documentLine.id,
      'quantity': quantity,
      'warehouse_code': documentLine.warehouseCode,
      'inventory_uom': documentLine.inventoryUom,
      'item_code': documentLine.itemCode,
      'item_description': documentLine.itemDescription,
    };

    print(dataRaw);

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .put(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: PurchaseRequest Update ${response.body}');
          storePurchaseResponse =
              StorePurchaseReqResponse.fromJson(response.body);
          newDocumentLine = storePurchaseResponse!.data!;
          documentLines = documentLines!
              .map((docLine) => (newDocumentLine.id == docLine.id)
                  ? newDocumentLine
                  : docLine)
              .toList();
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
    return result;
  }

  Future<bool> deleteSolped(int docId) async {
    isLoading = true;
    result = false;
    print('PurchaseRequest - DELETE');
    _endPoint = '/api/v1/purchase-request';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint/$docId');

    try {
      final response = await http
          .delete(url, headers: headers)
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Delete PurchaseRequest ${response.body}');
          storePurchaseResponse =
              StorePurchaseReqResponse.fromJson(response.body);
          newDocumentLine = storePurchaseResponse!.data!;
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
    return result;
  }

  void updateDocumentLine(DocumentLine updatedLine) {
    updatedLine.quantity =
        double.parse(updatedLine.quantity!).toStringAsFixed(3);
    int index = documentLines!.indexWhere((line) => line.id == updatedLine.id);

    if (index != -1) {
      documentLines![index] = updatedLine;
      notifyListeners(); // Asegurándote de notificar a los oyentes del cambio
    }
  }

  void addDocumentLine(DocumentLine createdLine) {
    documentLines!.add(createdLine);
    notifyListeners(); // Asegurándote de notificar a los oyentes del cambio
  }

  void removeDocumentLine(DocumentLine lineToDelete) {
    int index = documentLines!.indexWhere((line) => line.id == lineToDelete.id);
    if (index != -1) {
      documentLines!.removeAt(index);
      notifyListeners(); // Asegurándote de notificar a los oyentes del cambio
    }
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
