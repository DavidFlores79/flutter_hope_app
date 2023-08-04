import 'package:flutter/material.dart';

class SolpedScreen extends StatelessWidget {
  static const String routeName = 'solped';

  const SolpedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'SOLPED',
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
