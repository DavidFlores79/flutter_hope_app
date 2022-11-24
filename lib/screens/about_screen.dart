import 'package:flutter/material.dart';
import 'package:productos_app/shared/preferences.dart';

class AboutScreen extends StatelessWidget {
  static const String routeName = 'acerca-de';
  final String expirationDate = Preferences.expirationDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/itsoft.png'),
              height: 100,
            ),
            const Text(
              'Desarrollado por:',
              style: TextStyle(
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                height: 2,
              ),
            ),
            const Text(
              'ItSoft Services de Mexico, S.A. de C.V.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                height: 2,
              ),
            ),
            Text(
              'Servidor: ${Preferences.apiServer}',
              style: const TextStyle(
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                height: 2,
              ),
            ),
            Text(
              'Fecha de Vencimiento: $expirationDate',
              style: const TextStyle(
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                height: 2,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
