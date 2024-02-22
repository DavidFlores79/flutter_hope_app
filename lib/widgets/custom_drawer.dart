import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    User apiUser = User.fromJson(Preferences.apiUser);
    final mp = Provider.of<NavbarProvider>(context);
    final authService = Provider.of<AuthService>(
      context,
      listen: false,
    );

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildHeader(context, apiUser),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Inicio', style: TextStyle(fontSize: 20)),
            onTap: () {
              mp.selectedIndex = 0;
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            },
          ),
          buildMenuItems(context),
          buildFooter(authService: authService),
        ],
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
                  apiUser.nombre!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  apiUser.miPerfil!.nombre!,
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
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            MenuCategories(),
          ],
        ),
      ),
    );
  }
}

class buildFooter extends StatelessWidget {
  const buildFooter({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 30),
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Column(
          children: <Widget>[
            Divider(),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title:
                  const Text('Notificaciones', style: TextStyle(fontSize: 20)),
              onTap: () =>
                  Navigator.pushNamed(context, NotificationScreen.routeName),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.arrowRightFromBracket),
              title: const Text('Logout', style: TextStyle(fontSize: 20)),
              onTap: () async {
                await authService.logout();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
