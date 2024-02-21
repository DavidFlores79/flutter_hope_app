import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importa este paquete
import 'services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');

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
        ChangeNotifierProvider<LoginFormProvider>(
          create: (context) => LoginFormProvider(),
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
          // lazy: false,
        ),
        ChangeNotifierProvider<ModuleScreenProvider>(
          create: (context) => ModuleScreenProvider(),
        ),
        ChangeNotifierProvider<PedidosProvider>(
          create: (context) => PedidosProvider(),
        ),
        ChangeNotifierProvider<MigoProvider>(
          create: (context) => MigoProvider(),
        ),
        ChangeNotifierProvider<SolpedProvider>(
          create: (context) => SolpedProvider(),
        ),
        ChangeNotifierProvider<LiberarSolpedProvider>(
          create: (context) => LiberarSolpedProvider(),
        ),
        ChangeNotifierProvider<ME21NProvider>(
          create: (context) => ME21NProvider(),
        ),
        ChangeNotifierProvider<SupplierProvider>(
          create: (context) => SupplierProvider(),
        ),
        ChangeNotifierProvider<MaterialProvider>(
          create: (context) => MaterialProvider(),
        ),
        ChangeNotifierProvider<MonitorSolpedProvider>(
          create: (context) => MonitorSolpedProvider(),
        ),
        ChangeNotifierProvider<ConsultaStockProvider>(
          create: (context) => ConsultaStockProvider(),
        ),
        ChangeNotifierProvider<ReciboEmbarqueProvider>(
          create: (context) => ReciboEmbarqueProvider(),
        ),
        ChangeNotifierProvider<TransferenciaInternaProvider>(
          create: (context) => TransferenciaInternaProvider(),
        ),
        ChangeNotifierProvider<VerificacionFacturaMiroProvider>(
          create: (context) => VerificacionFacturaMiroProvider(),
        ),
        ChangeNotifierProvider<MonitorInventarioTiendaProvider>(
          create: (context) => MonitorInventarioTiendaProvider(),
        ),
        ChangeNotifierProvider<InventarioTiendaProvider>(
          create: (context) => InventarioTiendaProvider(),
        ),
        ChangeNotifierProvider<PurchaseRequestProvider>(
          create: (context) => PurchaseRequestProvider(),
        ),
        ChangeNotifierProvider<SBOItemProvider>(
          create: (context) => SBOItemProvider(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [Locale('es')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<NavigationService>().navigatorKey,
      scaffoldMessengerKey: Notifications.messengerKey,
      title: 'Hope Móvil',
      initialRoute: ActivationScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        AuthTokenScreen.routeName: (context) => const AuthTokenScreen(),
        PedidosScreen.routeName: (context) => const PedidosScreen(),
        ModuleScreen.routeName: (context) => const ModuleScreen(),
        MenuModulesScreen.routeName: (context) => const MenuModulesScreen(),
        AboutScreen.routeName: (context) => const AboutScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        ActivationScreen.routeName: (context) => const ActivationScreen(),
        NotificationScreen.routeName: (context) => NotificationScreen(),
        SolpedScreen.routeName: (context) => SolpedScreen(),
        LiberarSolpedScreen.routeName: (context) => LiberarSolpedScreen(),
        MigoScreen.routeName: (context) => const MigoScreen(),
        MonitorSolpedScreen.routeName: (context) => MonitorSolpedScreen(),
        ME21NScreen.routeName: (context) => ME21NScreen(),
        ConsultaStockScreen.routeName: (context) => ConsultaStockScreen(),
        UnderConstructionScreen.routeName: (context) =>
            const UnderConstructionScreen(),
        DescargaPalletsScreen.routeName: (context) =>
            const DescargaPalletsScreen(),
        TransferenciasInternasScreen.routeName: (context) =>
            const TransferenciasInternasScreen(),
        ShowTransfersScreen.routeName: (context) => const ShowTransfersScreen(),
        VerificarFacturaMiroScreen.routeName: (context) =>
            const VerificarFacturaMiroScreen(),
        MonitorInventarioTiendaScreen.routeName: (context) =>
            const MonitorInventarioTiendaScreen(),
        DetallesInventarioScreen.routeName: (context) =>
            const DetallesInventarioScreen(),
        InventarioTiendaScreen.routeName: (context) =>
            const InventarioTiendaScreen(),
        PurchaseRequestScreen.routeName: (context) =>
            const PurchaseRequestScreen(),
        ReleasePurchaseRequestScreen.routeName: (context) =>
            const ReleasePurchaseRequestScreen(),
      },
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}
