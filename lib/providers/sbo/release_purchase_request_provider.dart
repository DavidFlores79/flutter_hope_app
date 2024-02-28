import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/login_screen.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReleasePurchaseRequestProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoadingData = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  bool result = false;
  PurchaseRequestResponse? purchaseRequestResponse;
  PurchaseRequestRejectedResponse? rejectedResponse;
  List<DocumentLine>? purchaseRequestRejected;
  List<DocumentLine>? purchaseRequestReleased;
  List<DocumentLine>? documentLines = [];
  List<int> linesSelected = [];
  String _motivoRechazo = '';
  late String fecha1 = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(const Duration(days: 1)));
  late String fecha2 = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final NavigationService _navigationService = locator<NavigationService>();
  final storage = const FlutterSecureStorage();

  String get rejectionText => _motivoRechazo;

  set rejectionText(String value) {
    _motivoRechazo = value;
  }

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
  }

  bool get isLoadingData => _isLoadingData;

  set isLoadingData(bool value) {
    _isLoadingData = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<List<DocumentLine>> getCatalogs() async {
    isLoading = true;
    result = false;
    print('Release Purchase Request - Search');
    _endPoint = '/api/v1/release-purchase-request/search-by-date';
    linesSelected = [];

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'start_date': fecha1,
      'end_date': fecha2,
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
          print('200: Search Release Purchase Request ${response.body}');
          purchaseRequestResponse =
              PurchaseRequestResponse.fromJson(response.body);
          documentLines = purchaseRequestResponse!.data;
          notifyListeners();
          break;
        case 400:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('400: ${response.body}');
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
    return documentLines!;
  }

  Future<List<DocumentLine>> searchByDates() async {
    isLoadingData = true;
    result = false;
    print('Release Purchase Request - Search');
    _endPoint = '/api/v1/release-purchase-request/search-by-date';
    linesSelected = [];

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'start_date': fecha1,
      'end_date': fecha2,
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
          isLoadingData = false;
          print('200: Search Release Purchase Request ${response.body}');
          purchaseRequestResponse =
              PurchaseRequestResponse.fromJson(response.body);
          documentLines = purchaseRequestResponse!.data;
          notifyListeners();
          break;
        case 400:
          isLoadingData = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('400: ${response.body}');
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoadingData = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoadingData = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('404: ${response.body}');
          break;
        case 422:
          isLoadingData = false;
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
          isLoadingData = false;
          print('500: ${response.body}');
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoadingData = false;
          result = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isLoadingData = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return documentLines!;
  }

  Future<bool> releaseSolpeds() async {
    isLoadingData = true;
    result = false;
    print('Peticion LIberar Solped - Aprobar');
    _endPoint = '/api/v1/release-purchase-request/release';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'start_date': fecha1,
      'end_date': fecha2,
      'selectedPositions': linesSelected,
    };

    print(dataRaw);
    print('Ordenes a Liberar ${linesSelected.length}');

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));

      linesSelected = [];

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoadingData = false;
          print('200: Aprobar Liberar Solped ${response.body}');
          rejectedResponse =
              PurchaseRequestRejectedResponse.fromJson(response.body);
          purchaseRequestReleased = rejectedResponse!.data;
          Notifications.showSnackBar(rejectedResponse!.message!);
          notifyListeners();
          break;
        case 400:
          isLoadingData = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(serverResponse!.message!);
          notifyListeners();
          print('400: ${response.body}');
          break;
        case 401:
          print('401: ${response.body}');
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoadingData = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoadingData = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('404: ${response.body}');
          break;
        case 422:
          isLoadingData = false;
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
          isLoadingData = false;
          print('500: ${response.body}');
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoadingData = false;
          result = false;
      }
      notifyListeners();
      return result;
    } catch (e) {
      print('Error $e');
      isLoadingData = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }

  Future<bool> rejectSolpeds() async {
    isLoadingData = true;
    result = false;
    print('Peticion LIberar Solped - Rechazar');
    _endPoint = '/api/v1/release-purchase-request/reject';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    Map<String, dynamic> dataRaw = {
      'start_date': fecha1,
      'end_date': fecha2,
      'selectedPositions': linesSelected,
      'rejectionText': rejectionText
    };

    print(dataRaw);
    print('Ordenes a Rechazar ${linesSelected.length}');

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(dataRaw))
          .timeout(const Duration(seconds: 20));

      linesSelected = [];

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoadingData = false;
          print('200: Rechazar Solped ${response.body}');
          rejectedResponse =
              PurchaseRequestRejectedResponse.fromJson(response.body);
          purchaseRequestRejected = rejectedResponse!.data;
          Notifications.showSnackBar(rejectedResponse!.message!);
          notifyListeners();
          break;
        case 400:
          isLoadingData = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(serverResponse!.message!);
          notifyListeners();
          print('400: ${response.body}');
          break;
        case 401:
          print('401: ${response.body}');
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoadingData = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoadingData = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('404: ${response.body}');
          break;
        case 422:
          isLoadingData = false;
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
        // isLoadingData = false;
        // serverResponse = ServerResponse.fromJson(response.body);
        // Notifications.showSnackBar(
        //     serverResponse?.message ?? 'Error Desconocido.');
        // notifyListeners();
        // print('422: ${response.body}');
        // break;
        case 500:
          isLoadingData = false;
          print('500: ${response.body}');
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoadingData = false;
          result = false;
      }
      notifyListeners();
      return result;
    } catch (e) {
      print('Error $e');
      isLoadingData = false;
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
    updatedLine.modified = true;
    int index = documentLines!.indexWhere((line) => line.id == updatedLine.id);

    if (index != -1) {
      documentLines![index] = updatedLine;
      notifyListeners(); // Asegurándote de notificar a los oyentes del cambio
    } else if (updatedLine.rejectionText != null) {
      // El elemento no existe y rejection_text no es nulo, agrégalo a la lista
      documentLines!.add(updatedLine);
    }
  }

  void addDocumentLine(DocumentLine createdLine) {
    int index = documentLines!.indexWhere((line) => line.id == createdLine.id);
    if (index == -1) {
      print('lo agrego');
      final DateTime requestedAt = DateTime.parse(createdLine.requestedAt!);
      final DateTime date1 = DateTime.parse(fecha1);
      final DateTime date2 = DateTime.parse(fecha2);

      print(' req: $requestedAt date1: $date1 date2: $date2');

      if ((requestedAt.isAfter(date1) && requestedAt.isBefore(date2)) ||
          requestedAt.isAtSameMomentAs(date2) ||
          requestedAt.isAtSameMomentAs(date1)) {
        documentLines!.add(createdLine);
      }
      // documentLines!.add(createdLine);
      notifyListeners(); // Asegurándote de notificar a los oyentes del cambio
    }
  }

  void removeDocumentLine(DocumentLine lineToDelete) {
    int index = documentLines!.indexWhere((line) => line.id == lineToDelete.id);
    if (index != -1) {
      documentLines!.removeAt(index);
      notifyListeners(); // Asegurándote de notificar a los oyentes del cambio
    }
  }

  void removeDocumentLines(List<DocumentLine> linesToDelete) {
    // Itera sobre la lista de líneas a eliminar
    for (var lineToDelete in linesToDelete) {
      // Encuentra el índice de la línea a eliminar
      int index =
          documentLines!.indexWhere((line) => line.id == lineToDelete.id);
      if (index != -1) {
        // Si se encuentra, elimina la línea
        documentLines!.removeAt(index);
      }
    }
    notifyListeners(); // Asegurándote de notificar a los oyentes del cambio
  }

  void updateDocumentLines(List<DocumentLine> updatedLines) {
    for (var updatedLine in updatedLines) {
      // Realiza las operaciones necesarias en cada línea
      updatedLine.quantity =
          double.parse(updatedLine.quantity!).toStringAsFixed(3);
      updatedLine.modified = true;

      // Encuentra el índice de la línea a actualizar
      int index =
          documentLines!.indexWhere((line) => line.id == updatedLine.id);
      if (index != -1) {
        // Si se encuentra, actualiza la línea
        documentLines![index] = updatedLine;
      }
    }

    notifyListeners(); // Asegurándote de notificar a los oyentes del cambio
  }

  logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    _navigationService.navigateTo(LoginScreen.routeName);
  }
}
