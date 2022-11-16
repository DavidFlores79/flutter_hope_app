import 'package:flutter/material.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:provider/provider.dart';

class ModulesScreen extends StatelessWidget {
  static const String routeName = 'modulos';

  @override
  Widget build(BuildContext context) {
    final modulosProvider = Provider.of<ModulosProvider>(context);

    return const Scaffold(
      body: Center(
        child: Text('Modulos'),
      ),
    );
  }
}
