import 'package:flutter/material.dart';
import 'package:productos_app/providers/navbar_provider.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<NavbarProvider>(context);

    final Color color = Colors.indigo;

    return BottomNavigationBar(
        currentIndex: mp.selectedIndex,
        selectedIconTheme: IconThemeData(color: color),
        fixedColor: color,
        onTap: (value) {
          mp.selectedIndex = value;
        },
        items: mp.items
            .map((e) => BottomNavigationBarItem(
                  label: e.label,
                  icon: e.iconData!,
                ))
            .toList());
  }
}
