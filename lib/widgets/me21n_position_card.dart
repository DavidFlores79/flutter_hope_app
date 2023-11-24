import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:provider/provider.dart';

class ME21NPositionCard extends StatelessWidget {
  final PedidoPos material;
  const ME21NPositionCard({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    final me21nProvider = Provider.of<ME21NProvider>(context);

    return GestureDetector(
      onTap: () => editarPosition(context, material),
      child: ListTile(
        minVerticalPadding: 20,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              material.numeroMaterial!,
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
                Text(material.cantidad.toString()),
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
                    Text(me21nProvider.centroDefault),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Gpo.Compras: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${material.grupoCompras}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  editarPosition(BuildContext context, PedidoPos material) {
    final me21nProvider = Provider.of<ME21NProvider>(context, listen: false);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Editar Posición",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          // content: UpdateContent(material: material),
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
                // final result = await solpedProvider.updateSolped(material);
                // if (result) {
                //   Notifications.showSnackBar(
                //     solpedProvider.solpedResponse!.message ??
                //         'Solped Actualizado',
                //   );
                // }

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
}
