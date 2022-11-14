import 'package:flutter/material.dart';

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
            bottom: 30,
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
  const _BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.55,
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
    return Container(
      width: 150,
      height: 50,
      child: const Image(image: AssetImage('assets/hope-logo.png')),
    );
  }
}

class UserIcon extends StatelessWidget {
  const UserIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final distance = size.height * 0.08;

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
