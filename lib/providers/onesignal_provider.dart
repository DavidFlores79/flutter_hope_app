import 'dart:convert';

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
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    /// Set App Id.
    await OneSignal.shared.setAppId(Preferences.oneSignalAppId);

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {
      print("Accepted permission: $accepted");
    });

    /// Calls when foreground notification arrives.
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print(
        '&&&&&&&&& Notificacion Recibida en Foreground: ${event.notification}',
      );
      Notifications.showSnackBar(
          event.notification.body ?? 'Se recibio una notificacion');

      /// Display Notification, send null to not display
      event.complete(null);
    });

    /// Calls when the notification opens the app.
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('&&&&&&&&& Notificacion Abierta: ${result}');
    });
  }

  setOneSignalId() async {
    await OneSignal.shared.getDeviceState().then((value) {
      print('/*/*/*/*/*/*/*/*/ UserId: ${value!.userId} /*/*/*/*/*/*/*/*/');
      Preferences.onesignalUserId = value.userId ?? '';
    });
  }

  Future<bool> saveUpdateId() async {
    result = false;
    print('guardando one signal id en servidor...');

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

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

  disableNotifications() {
    OneSignal.shared.disablePush(false);
  }
}
