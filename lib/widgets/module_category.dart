import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';

class ModuleCategory extends StatelessWidget {
  final CategoriasModulo categoria;

  const ModuleCategory({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    final List<Modulo> modulos = categoria.modulos;
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          categoria.descripcionCorta,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Modulos(modulos: modulos),
      ],
    );
  }
}

class Modulos extends StatelessWidget {
  final List<Modulo> modulos;

  const Modulos({super.key, required this.modulos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false, //sin scroll en los modulos
      itemCount: modulos.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          width: 100,
          height: 50,
          color: Colors.grey,
          child: Text(modulos[index].nombre),
        );
      },
    );
  }
}
