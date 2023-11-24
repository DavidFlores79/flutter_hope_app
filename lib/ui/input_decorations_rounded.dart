import 'package:flutter/material.dart';

class InputDecorationsRounded {
  static InputDecoration authInputDecorationRounded({
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    required Color color,
  }) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[350], fontSize: 14),
      labelText: labelText,
      labelStyle: TextStyle(color: color, fontSize: 14),
      focusColor: color,
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: color,
              size: 21,
            )
          : null,
      suffixIcon: suffixIcon != null
          ? Icon(
              suffixIcon,
              color: color,
              size: 21,
            )
          : null,
    );
  }
}
