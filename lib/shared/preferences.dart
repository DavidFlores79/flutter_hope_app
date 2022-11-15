import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static String _apiServer = 'localhost';
  static bool _isActive = false;
  static String _expirationDate = '1979-04-10';
  static bool _isDarkMode = false;

  static String get apiServer {
    return _prefs.getString('apiServer') ?? _apiServer;
  }

  static set apiServer(String value) {
    _apiServer = value;
    _prefs.setString('apiServer', value);
  }

  static bool get isActive {
    return _prefs.getBool('isActive') ?? _isActive;
  }

  static set isActive(bool value) {
    _isActive = value;
    _prefs.setBool('isActive', value);
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
