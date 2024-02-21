import 'package:flutter/material.dart';
import 'package:hope_app/screens/screens.dart';

class ModuleScreenProvider extends ChangeNotifier {
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
  IconData? icon;
  final void Function(BuildContext)? onPressedCallback;
  Widget? floatingActionButton;

  ModuleScreenDTO(
      {this.widget,
      this.label,
      this.iconData,
      this.route,
      this.icon,
      this.onPressedCallback,
      this.floatingActionButton});
}
