import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';

class PositionCard extends StatelessWidget {
  final Posicion material;
  const PositionCard({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            material.material!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const Text('Cant. '),
              Text('${material.cantidad}'),
            ],
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(material.textoBreve!),
          Row(
            children: [
              const Text(
                'Centro: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${material.centros?.idcentro}'),
            ],
          ),
        ],
      ),
    );
  }
}
