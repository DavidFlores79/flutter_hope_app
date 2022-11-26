import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:provider/provider.dart';

class PopupMenuList extends StatelessWidget {
  const PopupMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    User apiUser = User.fromJson(Preferences.apiUser);

    return PopUpMenu(
      menuList: [
        const PopupMenuItem(
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 15),
          enabled: false,
          child: Text(
            'Bienvenido',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        PopupMenuItem(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          enabled: false,
          child: Text(
            apiUser.nombre,
            //style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        PopupMenuItem(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          enabled: false,
          child: Text(
            apiUser.nickname,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 1,
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text('Mi perfil'),
        ),
        const PopupMenuItem(
          value: 0,
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text('Preferencias'),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: const Text('Logout'),
          onTap: () async {
            await authService.logout();
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          },
        ),
      ],
      icon: Container(
        margin: const EdgeInsets.all(5),
        child: const CircleAvatar(
          maxRadius: 20,
          backgroundImage: AssetImage('assets/user1.png'),
        ),
      ),
    );
  }
}

class PopUpMenu extends StatelessWidget {
  final List<PopupMenuEntry> menuList;
  final Widget? icon;

  const PopUpMenu({super.key, required this.menuList, this.icon});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(7.0),
      )),
      padding: EdgeInsets.zero,
      onSelected: (result) {
        switch (result) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
            break;
          default:
        }
      },
      itemBuilder: (context) => menuList,
      child: icon,
    );
  }
}
