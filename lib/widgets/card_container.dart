import 'package:flutter/material.dart';
import 'package:hope_app/shared/preferences.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        decoration: _CardShape(),
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }

  BoxDecoration _CardShape() => BoxDecoration(
          color: Preferences.isDarkMode
              ? const Color.fromRGBO(35, 35, 35, 1)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Colors.black87, blurRadius: 20, offset: Offset(0, 5))
          ]);
}
