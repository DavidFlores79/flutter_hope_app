import 'package:flutter/material.dart';
import 'package:hope_app/screens/screens.dart';

class ModuleScreenProvider extends ChangeNotifier {
  List<ModuleScreenDTO> items = [
    ModuleScreenDTO(
      label: 'Solicitud de Pedidos',
      route: SolpedScreen.routeName,
      widget: SolpedScreen(),
    ),
    ModuleScreenDTO(
      label: 'Liberar Solicitud de Pedidos',
      route: LiberarSolpedScreen.routeName,
      widget: LiberarSolpedScreen(),
    ),
    ModuleScreenDTO(
      label: 'MIGO',
      route: MigoScreen.routeName,
      widget: const MigoScreen(),
    ),
    ModuleScreenDTO(
      label: 'Monitor Solped',
      route: MonitorSolpedScreen.routeName,
      widget: MonitorSolpedScreen(),
    ),
    ModuleScreenDTO(
      label: 'Creación de Pedidos',
      route: ME21NScreen.routeName,
      widget: ME21NScreen(),
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
