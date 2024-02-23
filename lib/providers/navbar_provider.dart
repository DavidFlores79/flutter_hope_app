import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/screens/screens.dart';

class NavbarProvider extends ChangeNotifier {
  List<NavbarDTO> _items = [
    NavbarDTO(
      label: 'Modulos',
      iconData: const Icon(FontAwesomeIcons.tableCellsLarge),
      widget: const MenuModulesScreen(),
      enabled: true,
    ),
    // NavbarDTO(
    //   label: 'Ordenes',
    //   iconData: const Icon(FontAwesomeIcons.newspaper),
    //   widget: const PedidosScreen(),
    //   enabled: true,
    // ),
    NavbarDTO(
      label: 'Configuración',
      iconData: const Icon(FontAwesomeIcons.gears),
      widget: const SettingsScreen(),
      enabled: true,
    ),
  ];

  List<NavbarDTO> get items => _items;

  set items(List<NavbarDTO> value) {
    _items = value;
    notifyListeners();
  }

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }
}

class NavbarDTO {
  Widget? widget;
  String? label;
  Widget? iconData;
  bool enabled;

  NavbarDTO({this.widget, this.label, this.iconData, required this.enabled});
}
