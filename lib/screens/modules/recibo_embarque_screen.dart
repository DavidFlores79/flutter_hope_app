import 'package:flutter/material.dart';

class ReciboEmbarqueScreen extends StatelessWidget {
  static String routeName = 'reciboembarque';

  const ReciboEmbarqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Recibo Embarque'),
      ),
    );
  }
}