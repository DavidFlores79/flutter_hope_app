import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/migo_provider.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:provider/provider.dart';

class ModuleCard extends StatelessWidget {
  final List<Modulo> modulos;
  final String apiServer = Preferences.apiServer;
  final String projectName = Preferences.projectName;

  ModuleCard({super.key, required this.modulos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      primary: false, //sin scroll en los modulos
      itemCount: modulos.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            print('Ruta ${modulos[index].ruta}');
            final migoProvider =
                Provider.of<MigoProvider>(context, listen: false);
            migoProvider.isLoading = false;
            migoProvider.result = false;
            Navigator.pushNamed(context, ModuleScreen.routeName,
                arguments: modulos[index]);
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.all(10),
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.network(
                    // 'http://172.17.1.45/hopesucursales/public_html/images/modules/${modulos[index].icono}',
                    'http://$apiServer$projectName/images/modules/${modulos[index].icono}',
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    modulos[index].nombre,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
