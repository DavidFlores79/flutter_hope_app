import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String routerName = 'Inicio';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(routerName),
      ),
    );
  }
}
