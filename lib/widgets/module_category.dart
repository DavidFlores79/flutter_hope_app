import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hope_app/models/models.dart';

class ModuleCategory extends StatelessWidget {
  final CategoriasModulo categoria;

  const ModuleCategory({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    final List<Modulo> modulos = categoria.modulos;
    return Container(
      height: 260,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            categoria.descripcionCorta,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Modulos(modulos: modulos),
          ),
        ],
      ),
    );
  }
}

class Modulos extends StatelessWidget {
  final List<Modulo> modulos;

  const Modulos({super.key, required this.modulos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      primary: false, //sin scroll en los modulos
      itemCount: modulos.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
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
                  'http://172.17.1.45/hopesucursales/public_html/images/modules/${modulos[index].icono}',
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
        );
      },
    );
  }
}
