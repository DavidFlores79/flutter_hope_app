import 'package:flutter/material.dart';

class ModulosProvider extends ChangeNotifier {
  ModulosProvider() {
    print('modulos provider inicializado');
    getModulosApp();
  }

  getModulosApp() {
    print('modulos de la app');
  }
}
