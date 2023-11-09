import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';

class MenuModule extends StatelessWidget {
  MenuModule({
    super.key,
    required this.modulos,
  });

  final List<Modulo> modulos;
  final String apiServer = Preferences.apiServer;
  final String projectName = Preferences.projectName;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false, //sin scroll en los modulos
      itemCount: modulos.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            print(modulos[index].nombre);
            print(modulos[index].ruta);
            Navigator.pop(context);
            Navigator.pushNamed(context, ModuleScreen.routeName,
                arguments: modulos[index]);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
            child: Row(
              children: [
                SvgPicture.network(
                  // 'http://$apiServer/$projectName/images/modules/${modulos[index].icono}',
                  'http://$apiServer$projectName/images/modules/${modulos[index].icono}',
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
    );
  }
}
