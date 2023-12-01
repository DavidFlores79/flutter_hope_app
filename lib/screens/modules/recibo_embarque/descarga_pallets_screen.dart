import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class DescargaPalletsScreen extends StatelessWidget {
  static const String routeName = 'descarga-pallets';

  const DescargaPalletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Embarque embarque = ModalRoute.of(context)!.settings.arguments as Embarque;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Descarga de Pallets'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Descarga Pallets ${embarque.entrega}'),
            TextButton(onPressed:() {
              Navigator.pop(context);
            }, child: const Text('Confirmación de Surtido'))
          ],
        ),
      ),
    );
  }
}