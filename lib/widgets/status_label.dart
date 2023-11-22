import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';

class StatusLabel extends StatelessWidget {
  final Estatus status;
  final Color color;
  const StatusLabel({super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 1,
      ),
      child: Text(
        status.descripcion!,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          color: ThemeProvider.whiteColor,
        ),
      ),
    );
  }
}
