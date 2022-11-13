import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: LoginScreen.routerName,
      routes: {
        LoginScreen.routerName: (context) => LoginScreen(),
        HomeScreen.routerName: (context) => HomeScreen(),
      },
    );
  }
}
