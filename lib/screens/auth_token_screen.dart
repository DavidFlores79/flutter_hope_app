import 'package:flutter/material.dart';
import 'package:productos_app/screens/home_screen.dart';
import 'package:productos_app/screens/login_screen.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';

class AuthTokenScreen extends StatelessWidget {
  static const String routerName = 'AuthToken';

  const AuthTokenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.getToken(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator.adaptive();

            if (snapshot.data == '') {
              Future.microtask(
                () {
                  // Navigator.pushReplacementNamed(context, LoginScreen.routerName);
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
                  // Navigator.pushReplacementNamed(context, LoginScreen.routerName);
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
