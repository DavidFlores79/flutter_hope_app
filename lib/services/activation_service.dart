import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:hope_app/ui/notifications.dart';

class ActivationService extends ChangeNotifier {
  final String _apiUrl = Preferences.activacionServer;
  final String _proyectName = Preferences.activacionRoute;
  bool result = false;
  final NavigationService _navigationService = locator<NavigationService>();

  Future<bool?> getLicence(String codigo) async {
    result = false;

    final Map<String, dynamic> activationData = {
      'activation_code': codigo,
    };

    final url =
        Uri.http(_apiUrl, '$_proyectName/api/v1/getLicense', activationData);

    try {
      final response = await http
          .post(url, body: json.encode(activationData))
          .timeout(const Duration(seconds: 30));

      final Map<String, dynamic> decodedResp = json.decode(response.body);

      print('response $decodedResp');

      switch (response.statusCode) {
        case 200:
          result = true;
          final activationResponse = ActivationResponse.fromMap(decodedResp);
          print('activationResponse = $activationResponse');

          //guardar el servidor (Solo el host sin http o https)
          if (activationResponse.license.urlApi != null) {
            Preferences.apiServer =
                Uri.parse(activationResponse.license.urlApi).host;
            Preferences.projectName =
                Uri.parse(activationResponse.license.urlApi).path;
          }

          if (activationResponse.clientImage != '') {
            Preferences.clientImage = activationResponse.clientImage;
          }

          //guardar la fecha de vencimiento de licencia
          //guardar el código para reusarlo cada vez que se abra la app
          Preferences.licenseExp = activationResponse.license.finalDate;
          Preferences.code = codigo;

          Notifications.showSnackBar('Actualizando configuración...');
          break;
        case 401:
          print('licencia vencida **********');
          Preferences.deleteLicence();
          Notifications.showSnackBar(decodedResp['message']);
          await _navigationService.navigateTo(ActivationScreen.routeName);
          break;
        default:
          result = false;
          Notifications.showSnackBar(decodedResp['message']);
      }
      return result;
    } catch (e) {
      print('Error: $e');
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar('Tiempo de espera agotado.');
      }
      Notifications.showSnackBar('Ocurrió un error inesperado.');
    }

    return result;
  }

  Future<bool> isLicenseExpired() async {
    //si el código fue guardado, solo valido la licencia
    if (Preferences.code != '') await getLicence(Preferences.code);
    final DateTime licenseExp = DateTime.parse(Preferences.licenseExp);
    final DateTime now = DateTime.now();
    return (now.compareTo(licenseExp) > 0) ? true : false;
  }
}
