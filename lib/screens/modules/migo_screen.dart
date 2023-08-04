import 'package:flutter/material.dart';

class MigoScreen extends StatelessWidget {
  static const String routeName = 'entrada-mercancia';

  const MigoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'MIGO',
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
