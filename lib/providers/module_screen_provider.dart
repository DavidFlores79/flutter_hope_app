import 'package:flutter/material.dart';
import 'package:hope_app/screens/screens.dart';

class ModuleScreenProvider extends ChangeNotifier {
  List<ModuleScreenDTO> items = [
    ModuleScreenDTO(
      label: 'Solped',
      route: SolpedScreen.routeName,
      widget: const SolpedScreen(),
    ),
    ModuleScreenDTO(
      label: 'MIGO',
      route: 'entrada-mercancia',
      widget: const MigoScreen(),
    ),
    ModuleScreenDTO(
      label: 'Monitor Solped',
      route: 'monitor-solped',
      widget: const MonitorSolpedScreen(),
    ),
    ModuleScreenDTO(
      label: 'Creación de Pedidos',
      route: 'me21n',
      widget: const ME21NScreen(),
    ),
  ];

  ModuleScreenDTO _selectedScreen = ModuleScreenDTO(
    label: 'Under Construction',
    route: UnderConstructionScreen.routeName,
    widget: const UnderConstructionScreen(),
  );

  ModuleScreenDTO get selectedScreen => _selectedScreen;

  set selectedScreen(ModuleScreenDTO selectedScreen) {
    _selectedScreen = selectedScreen;
  }
}

class ModuleScreenDTO {
  Widget? widget;
  String? label;
  String? route;
  Widget? iconData;

  ModuleScreenDTO({this.widget, this.label, this.iconData, this.route});
}
