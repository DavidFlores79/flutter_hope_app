import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:hope_app/ui/notifications.dart';

class ActivationService extends ChangeNotifier {
  final String _apiUrl = Preferences.activacionServer;
  final String _proyectName = Preferences.activacionRoute;
  bool result = false;

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
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> decodedResp = json.decode(response.body);

      if (response.statusCode == 200) {
        result = true;
        final activationResponse = ActivationResponse.fromMap(decodedResp);
        print('activationResponse = $activationResponse');

        //guardar la fecha de vencimiento de licencia
        Preferences.licenseExp = activationResponse.license.finalDate;
        //guardar el servidor (Solo el host sin http o https)
        Preferences.apiServer = Uri.parse(activationResponse.url.dominio).host;

        Notifications.showSnackBar(
            '${activationResponse.message} \n Guardando configuracion...');
      } else {
        result = false;
        Notifications.showSnackBar(decodedResp['message']);
      }
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
    final DateTime licenseExp = DateTime.parse(Preferences.licenseExp);
    final DateTime now = DateTime.now();
    return (now.compareTo(licenseExp) > 0) ? true : false;
  }
}
