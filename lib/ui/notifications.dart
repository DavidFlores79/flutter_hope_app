import 'package:flutter/material.dart';

class Notifications {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final snackBar = SnackBar(
        backgroundColor: const Color.fromRGBO(240, 171, 0, 1),
        content: Text(
          message,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ));
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
