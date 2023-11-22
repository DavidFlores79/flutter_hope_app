import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    required Color color,
  }) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: color)),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
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
