import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/activation_screen.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = 'settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = "es_MX"; //sets global,
    final sesionExpire = getFormatedDate(Preferences.expirationDate, 'hh:mm a');
    final licenseExpire =
        getFormatedDate(Preferences.licenseExp, 'MMMM dd, yyyy');

    return Scaffold(
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
                  },
                ),
                const Text(
                  'Datos Generales',
                  style: TextStyle(
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                      height: 2,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Servidor: ${Preferences.apiServer}',
                        style: const TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          height: 2,
                        ),
                      ),
                      Text(
                        'Licencia expira: $licenseExpire',
                        style: const TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          height: 2,
                        ),
                      ),
                      Text(
                        'Sesión expira: $sesionExpire',
                        style: const TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          height: 2,
                        ),
                      ),
                      Text(
                        'One Signal ID: ${Preferences.onesignalUserId}',
                        style: const TextStyle(
                          fontSize: 16,
                          height: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  ThemeProvider.blueColor),
                            ),
                            onPressed: () async {
                              await const FlutterSecureStorage().deleteAll();
                              Preferences.apiUser = '';
                              Preferences.apiServer = '172.17.1.45';
                              Preferences.expirationDate =
                                  '1979-04-10 00:00:00';
                              Preferences.licenseExp = '1979-04-10 00:00:00';
                              Preferences.isDarkMode = false;
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacementNamed(
                                  context, ActivationScreen.routeName);
                            },
                            child: const Text('Borrar Licencia')),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

getFormatedDate(String string, String format) {
  final date = DateTime.parse(string);
  final timeFormat = DateFormat(format);
  return timeFormat.format(date);
}
