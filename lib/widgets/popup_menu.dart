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
    final User apiUser = User.fromJson(Preferences.apiUser);

    return PopUpMenu(
      menuList: [
        PopupMenuItem(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          enabled: false,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: TextStyle(
                    fontSize: 15,
                    color: Preferences.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
                text: "Nick: ",
                children: [
                  TextSpan(
                    text: apiUser.nickname,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ]),
          ),
        ),
        PopupMenuItem(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          enabled: false,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 15,
                color: Preferences.isDarkMode ? Colors.white : Colors.black,
              ),
              text: apiUser.nombre,
              children: [],
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 1,
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 15,
                color: Preferences.isDarkMode ? Colors.white : Colors.black,
              ),
              text: 'Mi perfil',
              children: [],
            ),
          ),
        ),
        PopupMenuItem(
          value: 0,
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 15,
                color: Preferences.isDarkMode ? Colors.white : Colors.black,
              ),
              text: 'Preferencias',
              children: [],
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 15,
                color: Preferences.isDarkMode ? Colors.white : Colors.black,
              ),
              text: 'Logout',
              children: [],
            ),
          ),
          // child: const ListTile(
          //   // trailing: Icon(Icons.output_outlined),
          //   title: Text('Logout'),
          // ),
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
