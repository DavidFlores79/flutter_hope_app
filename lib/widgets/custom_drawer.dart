import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    User apiUser = User.fromJson(Preferences.apiUser);

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context, apiUser),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  buildHeader(BuildContext context, User apiUser) => Material(
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName),
          child: Container(
            color: const Color.fromARGB(255, 46, 46, 46),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 5,
              right: 5,
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  maxRadius: 50,
                  backgroundImage: AssetImage('assets/user1.png'),
                ),
                const SizedBox(height: 5),
                Text(
                  apiUser.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  apiUser.miPerfil.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );

  buildMenuItems(BuildContext context) {
    final mp = Provider.of<NavbarProvider>(context);

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Inicio', style: TextStyle(fontSize: 20)),
          onTap: () {
            mp.selectedIndex = 0;
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        ),
        MenuCategories(),
        // const SizedBox(height: 12),
        // const Divider(color: Colors.black12),
        ListTile(
          leading: const Icon(Icons.favorite_outline),
          title: const Text('Favoritos', style: TextStyle(fontSize: 20)),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Notificaciones', style: TextStyle(fontSize: 20)),
          onTap: () =>
              Navigator.pushNamed(context, NotificationScreen.routeName),
        ),
      ],
    );
  }
}