import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static String _apiUser = '';
  static String _activacionServer = '154.56.46.97';
  static String _activacionRoute = '/configuraciones/public_html';
  static String _apiServer = '172.17.1.45';
  static String _projectName = '/hopesucursales/public_html222';
  static bool _isActive = false;
  static String _expirationDate = '1979-04-10 00:00:00';
  static String _licenseExp = '1979-04-10 00:00:00';
  static String _code = '';
  static bool _isDarkMode = false;
  static bool _isModulesActive = true;
  static String _oneSignalAppId = '7edc135c-d979-4e44-b761-4e523d31f65b';
  static String _onesignalUserId = '';
  static String _clientImage = '';
  static String _deviceModel = '';

  static String get activacionServer {
    return _prefs.getString('activacionServer') ?? _activacionServer;
  }

  static set activacionServer(String value) {
    _activacionServer = value;
    _prefs.setString('activacionServer', value);
  }

  static String get activacionRoute {
    return _prefs.getString('activacionRoute') ?? _activacionRoute;
  }

  static set activacionRoute(String value) {
    _activacionRoute = value;
    _prefs.setString('activacionRoute', value);
  }

  static String get apiServer {
    return _prefs.getString('apiServer') ?? _apiServer;
  }

  static set apiServer(String value) {
    _apiServer = value;
    _prefs.setString('apiServer', value);
  }

  static String get projectName {
    return _prefs.getString('projectName') ?? _projectName;
  }

  static set projectName(String value) {
    _projectName = value;
    _prefs.setString('projectName', value);
  }

  static String get apiUser {
    return _prefs.getString('apiUser') ?? _apiUser;
  }

  static set apiUser(String value) {
    _apiUser = value;
    _prefs.setString('apiUser', value);
  }

  static bool get isActive {
    return _prefs.getBool('isActive') ?? _isActive;
  }

  static set isActive(bool value) {
    _isActive = value;
    _prefs.setBool('isActive', value);
  }

  static bool get isModulesActive {
    return _prefs.getBool('isModulesActive') ?? _isModulesActive;
  }

  static set isModulesActive(bool value) {
    _isModulesActive = value;
    _prefs.setBool('isModulesActive', value);
  }

  static bool get isDarkMode {
    return _prefs.getBool('isDarkMode') ?? _isDarkMode;
  }

  static set isDarkMode(bool value) {
    _isDarkMode = value;
    _prefs.setBool('isDarkMode', value);
  }

  static String get expirationDate {
    return _prefs.getString('expirationDate') ?? _expirationDate;
  }

  static set expirationDate(String value) {
    _expirationDate = value;
    _prefs.setString('expirationDate', value);
  }

  static String get licenseExp {
    return _prefs.getString('licenseExp') ?? _licenseExp;
  }

  static set licenseExp(String value) {
    _licenseExp = value;
    _prefs.setString('licenseExp', value);
  }

  static String get oneSignalAppId {
    return _prefs.getString('oneSignalAppId') ?? _oneSignalAppId;
  }

  static set oneSignalAppId(String value) {
    _oneSignalAppId = value;
    _prefs.setString('oneSignalAppId', value);
  }

  static String get onesignalUserId {
    return _prefs.getString('onesignalUserId') ?? _onesignalUserId;
  }

  static set onesignalUserId(String value) {
    _onesignalUserId = value;
    _prefs.setString('onesignalUserId', value);
  }

  static String get clientImage {
    return _prefs.getString('clientImage') ?? _clientImage;
  }

  static set clientImage(String value) {
    _clientImage = value;
    _prefs.setString('clientImage', value);
  }

  static String get deviceModel {
    return _prefs.getString('deviceModel') ?? _deviceModel;
  }

  static set deviceModel(String value) {
    _deviceModel = value;
    _prefs.setString('deviceModel', value);
  }

  static String get code {
    return _prefs.getString('code') ?? _code;
  }

  static set code(String value) {
    _code = value;
    _prefs.setString('code', value);
  }

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String timestampToDate(int timestamp) {
    var now = DateTime.now();
    //var format = DateFormat('HH:mm a');
    var format = DateFormat('yyyy-MM-dd HH:mm');
    // var format = DateFormat('yyyy-MM-dd, hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = '${diff.inDays} DAY AGO';
      } else {
        time = '${diff.inDays} DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = '${(diff.inDays / 7).floor()} WEEK AGO';
      } else {
        time = '${(diff.inDays / 7).floor()} WEEKS AGO';
      }
    }

    return time;
  }

  static String formatScheduledTime(String inputTime) {
    List<String> parts = inputTime.split(":"); // Dividir el string en partes

    if (parts.length >= 2) {
      String hour = parts[0]; // Obtener la hora
      String minute = parts[1]; // Obtener los minutos

      String formattedTime = "$hour:$minute"; // Crear el string de hora:minutos

      return formattedTime;
    } else {
      return inputTime;
    }
  }

  static String getInitials({required String string, required int limitTo}) {
    var buffer = StringBuffer();
    var split = string.split(' ');
    for (var i = 0; i < (limitTo); i++) {
      if (split[i].isNotEmpty) {
        buffer.write(split[i][0]);
      }
    }

    return buffer.toString();
  }

  static String formatDate(String fechaSolicitud) {
    // Convierte la cadena de fecha a un objeto DateTime
    DateTime fecha = DateTime.parse(fechaSolicitud);

    // Formatea la fecha según el formato deseado
    String fechaFormateada = DateFormat('dd-MMM-yyyy', 'es').format(
      fecha.toLocal(),
    );

    return fechaFormateada;
  }

  static String padNumberWithZeros(String number, int length) {
    // Ensure that the length is positive
    if (length <= 0) {
      throw ArgumentError('Length must be a positive number.');
    }

    // Ensure that the number is not null or empty
    if (number.isEmpty) {
      return '';
    }

    // Pad with zeros to the left until reaching the desired length
    return number.padLeft(length, '0');
  }

  static String truncateMessage(String message) {
    if (message.length > 60) {
      return '${message.substring(0, 60)}...';
    } else {
      return message;
    }
  }

  static void getDeviceModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.displayMetrics.widthPx > 600 ||
          androidInfo.displayMetrics.heightPx > 600) {
        deviceModel = 'Tablet';
      } else {
        deviceModel = 'Phone';
      }
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceModel = iosInfo.model;
    }
  }

  static deleteLicence() async {
    await const FlutterSecureStorage().deleteAll();
    apiUser = '';
    apiServer = '172.17.1.45';
    expirationDate = '1979-04-10 00:00:00';
    licenseExp = '1979-04-10 00:00:00';
    isDarkMode = false;
    code = '';
  }
}
