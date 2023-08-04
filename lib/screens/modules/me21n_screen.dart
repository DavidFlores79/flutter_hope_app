import 'package:flutter/material.dart';

class ME21NScreen extends StatelessWidget {
  static const String routeName = 'me21n';

  const ME21NScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Creación de Pedidos',
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
