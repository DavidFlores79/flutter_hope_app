import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/widgets/widgets.dart';

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
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(FontAwesomeIcons.calendar),
        )
      ],
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
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(FontAwesomeIcons.calendar),
        )
      ],
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
  List<Widget>? actions;

  ModuleScreenDTO(
      {this.widget, this.label, this.iconData, this.route, this.actions});
}
