import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const String routeName = 'acerca-de';

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/itsoft.png'),
              height: 100,
            ),
            Text(
              'Desarrollado por:',
              style: TextStyle(
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                height: 2,
              ),
            ),
            Text(
              'ItSoft Services de Mexico, S.A. de C.V.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                height: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
