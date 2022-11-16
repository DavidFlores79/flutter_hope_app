import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:productos_app/providers/navbar_provider.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'inicio';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final mp = Provider.of<NavbarProvider>(context);
    // const Color selectedColor = Color.fromRGBO(35, 35, 35, 1);
    // const Color selectedDarkColor = Color.fromRGBO(240, 171, 0, 1);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Image(
          image: AssetImage('assets/hope-logo.png'),
          height: 45,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                await authService.logout();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: mp.items[mp.selectedIndex].widget,
      bottomNavigationBar: const CustomBottomNavigationBar(),
      floatingActionButton:
          (mp.items[mp.selectedIndex].label!.contains('Acerca'))
              ? FloatingActionButton(
                  child: const FaIcon(
                    FontAwesomeIcons.gear,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, SettingsScreen.routeName),
                )
              : null,
    );
  }
}
