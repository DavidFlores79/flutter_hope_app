import 'package:flutter/material.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routerName = 'Inicio';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () => authService.logout(), child: const Text('Logout')),
      ),
    );
  }
}
