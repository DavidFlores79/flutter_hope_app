import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static String _apiUser = '';
  static String _apiServer = '205.251.136.75';
  static bool _isActive = false;
  static String _expirationDate = '1979-04-10';
  static bool _isDarkMode = false;
  static bool _isModulesActive = true;

  static String get apiServer {
    return _prefs.getString('apiServer') ?? _apiServer;
  }

  static set apiServer(String value) {
    _apiServer = value;
    _prefs.setString('apiServer', value);
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

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
