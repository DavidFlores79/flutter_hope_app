import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/widgets/widgets.dart';

class MaterialSearchList extends StatelessWidget {
  final List<Materials> materials;
  const MaterialSearchList({super.key, required this.materials});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: materials.length,
      itemBuilder: (BuildContext context, int index) {
        final Materials material = materials[index];

        return MaterialCard(material: material);
      },
    );
  }
}
