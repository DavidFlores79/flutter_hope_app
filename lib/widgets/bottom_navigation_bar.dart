import 'package:flutter/material.dart';
import 'package:productos_app/providers/navbar_provider.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<NavbarProvider>(context);

    // const Color selectedColor = Color.fromRGBO(35, 35, 35, 1);
    // const Color selectedDarkColor = Colors.white;
    // const Color unselectedColor = Color.fromRGBO(132, 140, 142, 1);

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
