import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/providers/navbar_provider.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'inicio';

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<NavbarProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Image(
          image: AssetImage('assets/hope-logo.png'),
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
