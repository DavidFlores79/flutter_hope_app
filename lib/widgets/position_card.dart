import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PositionCard extends StatelessWidget {
  final Posicion material;
  const PositionCard({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => editarSolped(context, material),
      child: ListTile(
        minVerticalPadding: 20,
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
                const Text(
                  'Cant. ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Centro: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${material.centros?.idcentro}'),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Gpo.Compras: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${material.gpoCompras}'),
                  ],
                ),
                StatusLabel(
                  status: material.estatus!,
                  color:
                      (material.estatus!.id != 1) ? Colors.red : Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

editarSolped(context, Posicion material) {
  final solpedProvider = Provider.of<SolpedProvider>(context, listen: false);

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text(
          "Editar Pedido",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        content: UpdateContent(material: material),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () async {
              final result = await solpedProvider.updateSolped(material);
              if (result) {
                Notifications.showSnackBar(
                  solpedProvider.solpedResponse!.message ??
                      'Solped Actualizado',
                );
              }

              Future.microtask(
                () => Navigator.pop(context),
              );
            },
            child: const Text(
              "Actualizar",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      );
    },
  );
}
