import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/widgets/widgets.dart';

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
            child: ModuleCard(modulos: modulos),
          ),
        ],
      ),
    );
  }
}
