import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hope_app/ui/notifications.dart';

class OneSignalProvider extends ChangeNotifier {
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  bool result = false;
  final storage = const FlutterSecureStorage();

  OneSignalProvider() {
    print('one signal provider inicializado');
  }

  Future<void> initOneSignal(BuildContext context) async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);

    /// Set App Id.
    OneSignal.initialize(Preferences.oneSignalAppId);

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.addPermissionObserver((state) {
      print("Has permission " + state.toString());
    });

    OneSignal.Notifications.clearAll();
    OneSignal.Notifications.requestPermission(true);

    OneSignal.User.pushSubscription.addObserver((state) {
      print(OneSignal.User.pushSubscription.optedIn);
      print(OneSignal.User.pushSubscription.id);
      print(OneSignal.User.pushSubscription.token);
      print(state.current.jsonRepresentation());
    });

    OneSignal.Notifications.addPermissionObserver((state) {
      print("Has permission " + state.toString());
    });

    OneSignal.Notifications.addClickListener((event) {
      print("Clicked notification: \n${event.notification}");

          Notifications.showSnackBar(
        'Se hizo CLICK!!!! ${event.notification.body}',
      );

    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      if (!Platform.isIOS) {
        Notifications.showSnackBar(
          'ForeGround ${event.notification.body} ',
        );
      }

      /// Display Notification, preventDefault to not display
      event.preventDefault();

      /// Do async work

      /// notification.display() to display after preventing default
      event.notification.display();
      print('*************** Notification received in FOREGROUND');
      print(event.notification.body);
      print('*************** Notification received in FOREGROUND');
    });
  }

  setOneSignalId() async {
    Preferences.onesignalUserId = OneSignal.User.pushSubscription.id ?? '';
    print('userID: ${Preferences.onesignalUserId}');
  }

  Future<bool> saveUpdateId() async {
    result = false;
    print('guardando one signal id en servidor...');

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';
    print('token guardado $jwtToken');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final Map<String, dynamic> oneSignalData = {
      'device_token': Preferences.onesignalUserId,
    };

    final url =
        Uri.http(_apiUrl, '$_proyectName/api/v1/os/token', oneSignalData);
    print('url $url');

    try {
      final response = await http
          .post(url, headers: headers, body: json.encode(oneSignalData))
          .timeout(const Duration(seconds: 20));

      final Map<String, dynamic> decodedResp = json.decode(response.body);

      if (response.statusCode == 200) {
        result = true;
        print('Exito: $decodedResp');
      } else {
        result = false;
        print('Error: $decodedResp');
        // Notifications.showSnackBar(decodedResp['message']);
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

  disableNotifications({bool value = false}) {
    OneSignal.consentGiven(value);
  }
}
