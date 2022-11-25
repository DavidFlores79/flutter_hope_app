import 'package:flutter/material.dart';
import 'package:hope_app/providers/navbar_provider.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<NavbarProvider>(context);

    return BottomNavigationBar(
        currentIndex: mp.selectedIndex,
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
