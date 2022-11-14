import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const String routeName = 'acerca-de';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Acerca de...'),
      ),
    );
  }
}
