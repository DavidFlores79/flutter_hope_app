import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static String _apiUser = '';
  static String _activacionServer = '205.251.136.75';
  static String _activacionRoute = '/HopeConfiguraciones';
  static String _apiServer = '205.251.136.75';
  static String _projectName = '/HopeV200';
  static bool _isActive = false;
  static String _expirationDate = '1979-04-10 00:00:00';
  static String _licenseExp = '1979-04-10 00:00:00';
  static bool _isDarkMode = false;
  static bool _isModulesActive = true;
  static String _oneSignalAppId = '7edc135c-d979-4e44-b761-4e523d31f65b';
  static String _onesignalUserId = '';

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
}
