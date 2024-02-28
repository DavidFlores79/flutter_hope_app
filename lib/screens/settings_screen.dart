import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/models/sbo/purchase_request/purchase_request_response.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/activation_screen.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

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
    final socketService = Provider.of<SocketService>(context, listen: false);

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
                      const Text(
                        'Servidor: ITSoft.mx',
                        style: TextStyle(
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
                        'Dispositivo: ${Preferences.deviceModel}',
                        style: const TextStyle(
                          fontSize: 16,
                          height: 2,
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            'WSS:',
                            style: TextStyle(
                              fontSize: 16,
                              height: 2,
                            ),
                          ),
                          const SizedBox(width: 15),
                          (socketService.serverStatus == ServerStatus.onLine)
                              ? Icon(
                                  FontAwesomeIcons.solidCircleCheck,
                                  color: ThemeProvider.greenColor,
                                )
                              : Icon(
                                  FontAwesomeIcons.solidCircleXmark,
                                  color: ThemeProvider.darkColor,
                                )
                        ],
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
                            onPressed: () => confirmDeleteLicence(context),
                            child: Text(
                              'Borrar Licencia',
                              style: TextStyle(
                                color: Preferences.isDarkMode
                                    ? ThemeProvider.whiteColor
                                    : ThemeProvider.whiteColor,
                              ),
                            )),
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

confirmDeleteLicence(BuildContext context) {
  final socketService = Provider.of<SocketService>(context, listen: false);
  final authService = Provider.of<AuthService>(context, listen: false);
  socketService.sendWsLog('presionó el boton (Borrar Licencia)');

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
                  socketService.sendWsLog('borró su Licencia');
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
