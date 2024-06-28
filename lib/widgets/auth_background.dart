import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)!.settings.name;

    return Container(
      decoration: _LinearGradient(),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          const _BackgroundImage(),
          const Positioned(
            bottom: 20,
            right: 30,
            child: LogoBrand(),
          ),
          if (currentRoute != 'registro') const UserIcon(),
          Center(
            child: child,
          )
          //child
        ],
      ),
    );
  }

  BoxDecoration _LinearGradient() => const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromARGB(255, 68, 66, 66),
            Color.fromRGBO(35, 35, 35, 1),
          ]));
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: size.height - 90,
      child: const Image(
        image: AssetImage('assets/merida-background.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }
}

class LogoBrand extends StatelessWidget {
  const LogoBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => deleteLicence(context),
      child: const SizedBox(
        width: 150,
        height: 50,
        child: Image(image: AssetImage('assets/hope-logo.png')),
      ),
    );
  }

  deleteLicence(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Eliminar Licencia',
              style: TextStyle(
                color: ThemeProvider.lightColor,
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          content: const SizedBox(
            width: double.minPositive,
            child: Text(
              '¿Está seguro que desea eliminar la licencia? \n\nEsto reiniciará su aplicación.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: ThemeProvider.lightRed,
                    disabledForegroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    // fixedSize: Size((size.width / 5), 20),
                    foregroundColor: Colors.white,
                    backgroundColor: ThemeProvider.blueColor,
                    disabledForegroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                  ),
                  onPressed: () async {
                    await authService.cleanSessionId();
                    // socketService.sendWsLog('borró su Licencia');
                    await Preferences.deleteLicence();
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(
                        context, ActivationScreen.routeName);
                    await Restart.restartApp();
                  },
                  child: const Text('Confirmar'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class UserIcon extends StatelessWidget {
  const UserIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final distance =
        size.height - (size.height - ((size.height < 670) ? 50 : 70));

    return SafeArea(
      child: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: distance),
        child: const Icon(
          Icons.person_pin,
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }
}
