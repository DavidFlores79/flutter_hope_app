import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/providers/theme_provider.dart';
import 'package:hope_app/screens/home_screen.dart';
import 'package:hope_app/screens/login_screen.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:provider/provider.dart';

class AuthTokenScreen extends StatelessWidget {
  static const String routeName = 'authtoken';

  const AuthTokenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final orderProvider = Provider.of<PedidosProvider>(context);
    orderProvider.getOrdenes();

    return Scaffold(
      backgroundColor: ThemeProvider.lightColor,
      body: Center(
        child: FutureBuilder(
          future: authService.getToken(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator.adaptive();

            if (snapshot.data == '') {
              if (Preferences.apiUser == '') {
                authService.logout();
              }
              Future.microtask(
                () {
                  // Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  LoginScreen(),
                          transitionDuration: const Duration(seconds: 0)));
                },
              );
            } else {
              Future.microtask(
                () {
                  // Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  HomeScreen(),
                          transitionDuration: const Duration(seconds: 0)));
                },
              );
            }

            return Container();
          }),
        ),
      ),
    );
  }
}
