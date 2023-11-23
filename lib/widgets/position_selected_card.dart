import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PositionSelectedCard extends StatefulWidget {
  final Posicion material;
  bool isSelected;

  PositionSelectedCard(
      {super.key, required this.material, required this.isSelected});

  @override
  State<PositionSelectedCard> createState() => _PositionSelectedCardState();
}

class _PositionSelectedCardState extends State<PositionSelectedCard> {
  @override
  Widget build(BuildContext context) {
    final liberarSolpedProvider = Provider.of<LiberarSolpedProvider>(context);
    final fechaSolicitud =
        Preferences.formatDate(widget.material.fechaSolicitud!);

    return Slidable(
      key: const ValueKey(0),
      // The end action pane is the one at the right or the bottom side.
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 7,
            onPressed: (context) => showPosicion(context, widget.material),
            backgroundColor: ThemeProvider.blueColor,
            foregroundColor: ThemeProvider.whiteColor,
            icon: Icons.remove_red_eye_outlined,
            label: 'Mostrar',
          ),
        ],
      ),
      child: CheckboxListTile(
        activeColor: ThemeProvider.blueColor,
        controlAffinity: ListTileControlAffinity.leading,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.material.material!,
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
                Text('${widget.material.cantidad}'),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.material.textoBreve!),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Centro: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${widget.material.centros?.idcentro}'),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Gpo.Compras: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${widget.material.gpoCompras}'),
                  ],
                ),
                StatusLabel(
                  status: widget.material.estatus!,
                  color: (widget.material.estatus!.id != 1)
                      ? Colors.red
                      : Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'F. Solicitud: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(fechaSolicitud),
              ],
            ),
          ],
        ),
        value: widget.isSelected,
        onChanged: (value) {
          setState(() {
            widget.isSelected = value!;
            final posicionExiste = liberarSolpedProvider.posicionesSelected
                .contains(widget.material.id);

            posicionExiste
                ? liberarSolpedProvider.posicionesSelected
                    .remove(widget.material.id)
                : liberarSolpedProvider.posicionesSelected
                    .add(widget.material.id!);
          });
          print(
              '***************** Cuantos ${liberarSolpedProvider.posicionesSelected.length}');
        },
      ),
    );
  }
}

showPosicion(context, Posicion material) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text(
          "Pedido ${material.id}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        content: SolpedInfo(material: material),
      );
    },
  );
}
