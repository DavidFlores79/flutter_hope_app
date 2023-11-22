import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:provider/provider.dart';

class ModuleScreen extends StatelessWidget {
  static const String routeName = 'module_screen';

  const ModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Modulo modulo = ModalRoute.of(context)!.settings.arguments as Modulo;
    final screenProvider = Provider.of<ModuleScreenProvider>(context);
    final ModuleScreenDTO moduleScreen = screenProvider.items.firstWhere(
        (element) => element.route == modulo.ruta,
        orElse: () => screenProvider.selectedScreen);

    return Scaffold(
      // drawer: const CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(moduleScreen.label!),
        actions: const [
          // PopupMenuList(),
        ],
      ),
      body: moduleScreen.widget,
    );
  }
}
