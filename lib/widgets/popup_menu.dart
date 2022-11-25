import 'package:flutter/material.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:provider/provider.dart';

class PopupMenuList extends StatelessWidget {
  const PopupMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return PopUpMenu(
      menuList: [
        PopupMenuItem(
          child: const ListTile(
            //leading: Icon(Icons.person),
            title: Text('Mi perfil'),
          ),
          onTap: () {},
        ),
        const PopupMenuItem(
          value: 0,
          child: ListTile(
            //leading: Icon(Icons.person),
            title: Text('Preferencias'),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: const ListTile(
            //leading: Icon(Icons.logout_outlined),
            title: Text('Logout'),
          ),
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
          default:
        }
      },
      itemBuilder: (context) => menuList,
      child: icon,
    );
  }
}
