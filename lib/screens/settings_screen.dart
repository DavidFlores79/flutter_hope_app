import 'package:flutter/material.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/shared/preferences.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = 'settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Configuración'),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                await authService.logout();
              },
              icon: const Icon(Icons.logout))
        ],
        //backgroundColor: const Color.fromRGBO(35, 35, 35, 1),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                    value: Preferences.isDarkMode,
                    title: const Text('DarkMode'),
                    onChanged: (bool value) {
                      final themeProvider = Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      );
                      Preferences.isDarkMode = value;
                      value
                          ? themeProvider.setDarkMode()
                          : themeProvider.setLightMode();
                      setState(() {});
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
