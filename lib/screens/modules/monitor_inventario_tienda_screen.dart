import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MonitorInventarioTiendaScreen extends StatefulWidget {
  static const String routeName = 'monitorinvtienda';

  const MonitorInventarioTiendaScreen({super.key});

  @override
  State<MonitorInventarioTiendaScreen> createState() =>
      _MonitorInventarioTiendaScreenState();
}

class _MonitorInventarioTiendaScreenState
    extends State<MonitorInventarioTiendaScreen> {
  @override
  void initState() {
    super.initState();
    final monitorInvTienda = context.read<MonitorInventarioTiendaProvider>();
    // monitorInvTienda.fecha1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // monitorInvTienda.fecha2 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // monitorInvTienda.inventarios = [];
    // monitorInvTienda.posicionesSelected = [];
    // monitorInvTienda.searchByDates();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MonitorInventarioTiendaProvider>(
      builder: (context, monitorInvTienda, _) {
        return (monitorInvTienda.isLoadingCatalogs)
            ? Center(
                child: SpinKitCubeGrid(
                  color: ThemeProvider.blueColor,
                ),
              )
            : // Aquí colocas el contenido del screen cuando isLoading es false
            const MonitorInvTienda();
      },
    );
  }
}

class MonitorInvTienda extends StatefulWidget {
  const MonitorInvTienda({super.key});

  @override
  State<MonitorInvTienda> createState() => _MonitorInvTiendaState();
}

class _MonitorInvTiendaState extends State<MonitorInvTienda> {
  @override
  Widget build(BuildContext context) {
    final monitorInvProvider =
        Provider.of<MonitorInventarioTiendaProvider>(context);

    return (monitorInvProvider.inventarios.isEmpty)
        ? EmptyContainer(
            assetImage: 'assets/images/modules/order-tracking.png',
            text:
                'No hay inventarios para mostrar.\nPuede intentar con otras fechas.',
          )
        : ListView.builder(
            itemCount: monitorInvProvider.inventarios.length,
            itemBuilder: (BuildContext context, int index) {
              final inventario = monitorInvProvider.inventarios[index];

              return InventarioCard(
                  inventario: inventario,
                  isSelected: (monitorInvProvider.posicionesSelected
                          .contains(inventario.id))
                      ? true
                      : false);
            },
          );
  }
}

class InventarioCard extends StatefulWidget {
  final Inventario inventario;
  bool isSelected;

  InventarioCard(
      {super.key, required this.inventario, required this.isSelected});

  @override
  State<InventarioCard> createState() => _InventarioCardState();
}

class _InventarioCardState extends State<InventarioCard> {
  @override
  Widget build(BuildContext context) {
    final monitorInvProvider =
        Provider.of<MonitorInventarioTiendaProvider>(context);
    final Inventario inventario = widget.inventario;
    final Estatus status =
        Estatus(descripcion: (inventario.estatus != 0) ? 'Contado' : 'Nuevo');

    return Slidable(
      key: const ValueKey(0),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 7,
            onPressed: (context) async {
              monitorInvProvider.inventarioSelected = inventario;

              Future.microtask(() => Navigator.pushNamed(
                  context, DetallesInventarioScreen.routeName));
            },
            backgroundColor: ThemeProvider.blueColor,
            foregroundColor: ThemeProvider.whiteColor,
            icon: Icons.remove_red_eye_outlined,
            label: 'Mostrar',
          ),
        ],
      ),
      child: Card(
        elevation: 5,
        child: CheckboxListTile(
          contentPadding: const EdgeInsets.only(top: 10, bottom: 10, right: 15),
          activeColor: ThemeProvider.blueColor,
          controlAffinity: ListTileControlAffinity.leading,
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardItemLabelValue(
                      label: '${inventario.documento}', value: ''),
                  StatusLabel(status: status, color: ThemeProvider.greenColor)
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardItemLabelValue(
                      label: 'Centro: ',
                      value: '${inventario.centro!.idcentro}'),
                  CardItemLabelValue(
                      label: 'Fecha: ', value: '${inventario.fecha}'),
                ],
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              CardItemLabelValue(
                  label: 'Inicio: ', value: '${inventario.horaInicio}'),
              const SizedBox(height: 10),
              CardItemLabelValue(
                  label: 'Fin: ', value: '${inventario.horaFin}'),
            ],
          ),
          value: widget.isSelected,
          onChanged: (value) {
            setState(() {
              widget.isSelected = value!;
              final posicionExiste = monitorInvProvider.posicionesSelected
                  .contains(widget.inventario.id);

              posicionExiste
                  ? monitorInvProvider.posicionesSelected
                      .remove(widget.inventario.id)
                  : monitorInvProvider.posicionesSelected
                      .add(widget.inventario.id!);
            });
          },
        ),
      ),
    );
  }
}

class _CardColumnItemValue extends StatelessWidget {
  final String label;
  final String value;

  const _CardColumnItemValue(
      {super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
