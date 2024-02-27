import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hope_app/models/estatus.dart';
import 'package:hope_app/models/sbo/purchase_request/purchase_request_response.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/modules/sbo/release_purchase_request/purchase_request_info_card.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:provider/provider.dart';

class SelectablePurchaseRequestCard extends StatefulWidget {
  final DocumentLine documentLine;
  bool isSelected;

  SelectablePurchaseRequestCard(
      {super.key, required this.isSelected, required this.documentLine});

  @override
  State<SelectablePurchaseRequestCard> createState() =>
      _SelectablePurchaseRequestCardState();
}

class _SelectablePurchaseRequestCardState
    extends State<SelectablePurchaseRequestCard> {
  @override
  Widget build(BuildContext context) {
    final releasePurchaseRequestProvider =
        Provider.of<ReleasePurchaseRequestProvider>(context);
    final requestedDate =
        Preferences.formatDate(widget.documentLine.requestedAt!);

    return Slidable(
      key: const ValueKey(0),
      // The end action pane is the one at the right or the bottom side.
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 7,
            onPressed: (context) => showPosicion(context, widget.documentLine),
            backgroundColor: ThemeProvider.blueColor,
            foregroundColor: ThemeProvider.whiteColor,
            icon: Icons.remove_red_eye_outlined,
            label: 'Mostrar',
          ),
        ],
      ),
      child: CheckboxListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        activeColor: ThemeProvider.blueColor,
        controlAffinity: ListTileControlAffinity.leading,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.documentLine.itemCode!,
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
                Text('${widget.documentLine.quantity}'),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.documentLine.itemDescription!),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Centro: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${widget.documentLine.warehouseCode}'),
                  ],
                ),
                _StatusLabel(
                  status: widget.documentLine.status!,
                  color: (widget.documentLine.status!.id != 1)
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
                Text(requestedDate),
              ],
            ),
          ],
        ),
        value: widget.isSelected,
        onChanged: (value) {
          setState(() {
            widget.isSelected = value!;
            final posicionExiste = releasePurchaseRequestProvider.linesSelected
                .contains(widget.documentLine.id);

            posicionExiste
                ? releasePurchaseRequestProvider.linesSelected
                    .remove(widget.documentLine.id)
                : releasePurchaseRequestProvider.linesSelected
                    .add(widget.documentLine.id!);
          });
          print(
              '***************** Cuantos ${releasePurchaseRequestProvider.linesSelected.length}');
        },
      ),
    );
  }

  showPosicion(context, DocumentLine documentLine) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Solicitud ${documentLine.id}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          content: PurchaseRequestInfoCard(documentLine: documentLine),
        );
      },
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final Estatus status;
  final Color color;
  const _StatusLabel({super.key, required this.status, required this.color});

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
