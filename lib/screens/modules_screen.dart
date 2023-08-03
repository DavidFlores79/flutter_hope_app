import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ModulesScreen extends StatelessWidget {
  static const String routeName = 'modulos';

  const ModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModulesBody(),
    );
  }
}

class ModulesBody extends StatelessWidget {
  final List<CategoriasModulo> categorias = [];

  ModulesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final modulosProvider = Provider.of<ModulosProvider>(context);
    List<CategoriasModulo> categorias = modulosProvider.categorias;

    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (BuildContext context, int index) {
        return ModuleCategory(categoria: categorias[index]);
      },
    );
  }
}
// ModuleCategory(categorias: modulosProvider.categorias),
