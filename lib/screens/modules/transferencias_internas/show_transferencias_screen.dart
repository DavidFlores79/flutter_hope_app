import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/transferencias/transferencia_interna_request.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ShowTransfersScreen extends StatelessWidget {
  static String routeName = 'detalles-transferencias';

  const ShowTransfersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transferenciasInternasProvider =
        Provider.of<TransferenciaInternaProvider>(context);
    final transferencias = transferenciasInternasProvider.transferencias;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles'),
        centerTitle: true,
      ),
      body: (transferencias.isEmpty)
          ? Center(
              child: EmptyContainer(
                assetImage: 'assets/images/modules/order-tracking.png',
                text: "Sin Transferencias",
              ),
            )
          : ListView.builder(
              itemCount: transferencias.length,
              itemBuilder: (context, index) {
                final transfer = transferencias[index];

                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 25),
                    child: const Icon(
                      FontAwesomeIcons.trash,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.startToEnd,
                  confirmDismiss: (DismissDirection direction) async {
                    return true;
                  },
                  onDismissed: (DismissDirection direction) {
                    transferencias.remove(transfer);
                    print('Eliminado ${transfer.de!.numeroMaterial}');
                  },
                  child: TransferCard(transfer: transfer),
                );
              },
            ),
    );
  }
}

class TransferCard extends StatelessWidget {
  final TransferenciaInterna transfer;
  const TransferCard({super.key, required this.transfer});

  @override
  Widget build(BuildContext context) {
    final transferenciasInternasProvider =
        Provider.of<TransferenciaInternaProvider>(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: Colors.black12,
        ),
      ),
      elevation: 16,
      shadowColor: Colors.black54,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(
              'Suministrador: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ThemeProvider.blueColor),
            ),
            const SizedBox(height: 10),
            ItemLabelValue(
              label: 'Material: ',
              value: '${transfer.de!.numeroMaterial}',
            ),
            ItemLabelValue(
              label: 'Desc: ',
              value: '${transfer.de!.textoBreve}',
              maxLines: 1,
            ),
            ItemLabelValue(
              label: 'Almacen: ',
              value: '${transfer.de!.almacen}',
            ),
            ItemLabelValue(
              label: 'Cantidad: ',
              value: '${transfer.de!.cantidad}',
            ),
            const Divider(thickness: 2, height: 20),
            Text(
              'Receptor: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ThemeProvider.blueColor),
            ),
            const SizedBox(height: 10),
            ItemLabelValue(
              label: 'Material: ',
              value: '${transfer.a!.numeroMaterial}',
            ),
            ItemLabelValue(
              label: 'Desc: ',
              value: '${transfer.a!.textoBreve}',
              maxLines: 1,
            ),
            ItemLabelValue(
              label: 'Almacen: ',
              value: '${transfer.a!.almacen}',
            ),
            ItemLabelValue(
              label: 'Cantidad: ',
              value: '${transfer.a!.cantidad}',
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Referencia:  ', style: TextStyle(fontWeight: FontWeight.bold),),
                Text(transferenciasInternasProvider.referencia),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
