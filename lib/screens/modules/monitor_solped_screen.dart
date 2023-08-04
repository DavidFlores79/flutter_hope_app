import 'package:flutter/material.dart';

class MonitorSolpedScreen extends StatelessWidget {
  static const String routeName = 'monitor-solped';

  const MonitorSolpedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Monitor Solped',
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
