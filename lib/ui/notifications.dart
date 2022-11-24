import 'package:flutter/material.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/shared/preferences.dart';

class Notifications {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final snackBar = SnackBar(
        backgroundColor: Preferences.isDarkMode
            ? ThemeProvider.darkColor
            : ThemeProvider.lightColor,
        content: Text(
          message,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ));
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
