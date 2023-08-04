import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MenuCategories extends StatelessWidget {
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
            leading: const Icon(Icons.add_circle_outline_sharp),
            title: Text(categorias[index].descripcionCorta,
                style: const TextStyle(fontSize: 20)),
            children: [MenuModule(modulos: modulos)],
          );
        },
      ),
    );
  }
}
