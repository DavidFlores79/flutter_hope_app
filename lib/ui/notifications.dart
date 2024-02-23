import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';

class Notifications {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    print('showSnackBar message ************* $message **********');
    final snackBar = SnackBar(
        backgroundColor: Preferences.isDarkMode
            ? ThemeProvider.darkColor
            : ThemeProvider.blueColor,
        dismissDirection: DismissDirection.startToEnd,
        content: Text(
          message,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ));
    messengerKey.currentState!.showSnackBar(snackBar);
  }

  static showFloatingSnackBar(String message) {
    print('showFloatingSnackBar message ************* $message **********');
    final snackBar = SnackBar(
        backgroundColor: Preferences.isDarkMode
            ? ThemeProvider.darkColor
            : ThemeProvider.blueColor,
        dismissDirection: DismissDirection.startToEnd,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ));
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
