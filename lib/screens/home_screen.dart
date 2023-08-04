import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'inicio';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<NavbarProvider>(context);
    User apiUser = User.fromJson(Preferences.apiUser);

    return Scaffold(
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(context, apiUser),
              buildMenuItems(context),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: (Preferences.clientImage != '')
            ? Image(
                image: NetworkImage(Preferences.clientImage),
                height: 45,
              )
            : const Image(
                image: AssetImage('assets/hope-logo.png'),
                height: 45,
              ),
        actions: const [
          PopupMenuList(),
        ],
      ),
      body: mp.items[mp.selectedIndex].widget,
      bottomNavigationBar: const CustomBottomNavigationBar(),
      floatingActionButton:
          (mp.items[mp.selectedIndex].label!.contains('Acerca'))
              ? FloatingActionButton(
                  child: const FaIcon(
                    FontAwesomeIcons.gear,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, SettingsScreen.routeName),
                )
              : null,
    );
  }

  buildHeader(BuildContext context, User apiUser) => Material(
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName),
          child: Container(
            color: const Color.fromARGB(255, 46, 46, 46),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  maxRadius: 60,
                  backgroundImage: AssetImage('assets/user1.png'),
                ),
                const SizedBox(height: 5),
                Text(
                  apiUser.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 30,
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
        _categoriasModulos(),
        const SizedBox(height: 2),
        const Divider(color: Colors.black54),
        ListTile(
          leading: const Icon(Icons.favorite_outline),
          title: const Text('Favoritos', style: TextStyle(fontSize: 20)),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Notificaciones', style: TextStyle(fontSize: 20)),
          onTap: () {},
        ),
      ],
    );
  }
}

class _categoriasModulos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final modulosProvider = Provider.of<ModulosProvider>(context);
    List<CategoriasModulo> categorias = modulosProvider.categorias;

    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: categorias.length,
        itemBuilder: (BuildContext context, int index) {
          final List<Modulo> modulos = categorias[index].modulos;

          return ExpansionTile(
            collapsedBackgroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            leading: const Icon(Icons.home_outlined),
            title: Text(categorias[index].descripcionCorta,
                style: const TextStyle(fontSize: 20)),
            children: [
              ListView.builder(
                shrinkWrap: true,
                primary: false, //sin scroll en los modulos
                itemCount: modulos.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      print(modulos[index].nombre);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 25),
                      child: Row(
                        children: [
                          SvgPicture.network(
                            'http://172.17.1.45/hopesucursales/public_html/images/modules/${modulos[index].icono}',
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              modulos[index].nombre,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
