import 'package:flutter/material.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/providers/navbar_provider.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:provider/provider.dart';

import 'services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  setupLocator();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider<ActivationService>(
          create: (context) => ActivationService(),
        ),
        ChangeNotifierProvider<OneSignalProvider>(
          create: (context) => OneSignalProvider(),
        ),
        ChangeNotifierProvider<NavbarProvider>(
          create: (context) => NavbarProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) =>
              ThemeProvider(isDarkmode: Preferences.isDarkMode),
        ),
        ChangeNotifierProvider<ModulosProvider>(
          create: (context) => ModulosProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider<PedidosProvider>(
          create: (context) => PedidosProvider(),
        ),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<NavigationService>().navigatorKey,
      scaffoldMessengerKey: Notifications.messengerKey,
      title: 'Hope Móvil',
      initialRoute: ActivationScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        AuthTokenScreen.routeName: (context) => const AuthTokenScreen(),
        PedidosScreen.routeName: (context) => PedidosScreen(),
        ModulesScreen.routeName: (context) => ModulesScreen(),
        AboutScreen.routeName: (context) => AboutScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        ActivationScreen.routeName: (context) => const ActivationScreen(),
      },
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}
