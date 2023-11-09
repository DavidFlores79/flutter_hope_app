import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'inicio';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<NavbarProvider>(context);
    final modulosProvider = Provider.of<ModulosProvider>(
      context,
      listen: false,
    );
    modulosProvider.getModulosApp();

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: (Preferences.clientImage != '')
            ? Image.network(
                Preferences.clientImage,
                height: 45,
              )
            : Image.asset(
                'assets/hope-logo.png',
                height: 45,
              ),
        actions: const [
          PopupMenuList(),
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
