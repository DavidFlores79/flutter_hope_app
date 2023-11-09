import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<NavbarProvider>(context);

    return BottomNavigationBar(
        currentIndex: mp.selectedIndex,
        onTap: (value) {
          if (mp.items.elementAt(value).enabled) {
            mp.selectedIndex = value;
          }
        },
        items: mp.items.map((e) {
          if (e.enabled) {}

          return BottomNavigationBarItem(
            label: e.label,
            icon: e.iconData!,
          );
        }).toList());
  }
}
