import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/monitor_inventario/monitor_inventario_response.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';

class DetallesInventarioScreen extends StatefulWidget {
  static const String routeName = 'detalles-inventario';

  const DetallesInventarioScreen({super.key});
  

  @override
  State<DetallesInventarioScreen> createState() =>
      _DetallesInventarioScreenState();
}

class _DetallesInventarioScreenState extends State<DetallesInventarioScreen> {

  
@override
  void initState() {
    // TODO: implement initState
    final monitorInvTienda = context.read<MonitorInventarioTiendaProvider>();
    monitorInvTienda.getInventario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final monitorInvTienda = Provider.of<MonitorInventarioTiendaProvider>(context);
    List<InventarioDetalle>? detallesInv = monitorInvTienda.inventario.detalles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles Inventario'),
        centerTitle: true,
      ),
      body: (monitorInvTienda.isLoadingCatalogs)
            ? Center(
                child: SpinKitCubeGrid(
                  color: ThemeProvider.blueColor,
                ),
              )
            :  ListView.builder(
        shrinkWrap: true,
        itemCount: detallesInv!.length, // Cantidad de elementos en tu lista
        itemBuilder: (BuildContext context, int index) {
          final detalle = detallesInv[index];

          return Card(
            elevation: 5,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              title: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CardColumnItemValue(
                            label: 'Cod.Barra', value: '${detalle.codbar}'),
                        Image.asset('assets/images/modules/inventory.png', height: 50),
                      ],
                    ),
                    _CardColumnItemValue(
                        label: 'Material', value: '${detalle.material}'),
                    _CardColumnItemValue(
                        label: 'Descripción', value: '${detalle.descripcion}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CardColumnItemValue(
                            label: 'Cant.Teórica',
                            value: '${detalle.cantidadTeorica}'),
                        _CardColumnItemValue(
                            label: 'Total Cont.',
                            value: '${double.parse(detalle.cantidad!)}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CardColumnItemValue(
                            label: 'Diferencia',
                            value: '${double.parse(detalle.diferencia!)}'),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () => _showPosicion(context, detalle.detalles!),
            ),
          );
        },
      ),
    );
  }
}

_showPosicion(context, List<DetalleDetalle> detallesMaterial) {
  final size = MediaQuery.of(context).size;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text(
          "Detalle Material",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        content: SizedBox(
          width: double.maxFinite,
          height: size.height * 0.4,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount:
                detallesMaterial.length, // Cantidad de elementos en tu lista
            itemBuilder: (BuildContext context, int index) {
              final detalleMaterial = detallesMaterial[index];

              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15),
                title: SingleChildScrollView(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CardItemLabelValue(
                                label: 'Mueble:',
                                value: '${detalleMaterial.mueble}'),
                            CardItemLabelValue(
                                label: 'Resp:',
                                value: '${detalleMaterial.responsable}'),
                            CardItemLabelValue(
                                label: 'Cant.Contada:',
                                value: '${detalleMaterial.cantidad}'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(color: ThemeProvider.blueColor, borderRadius: BorderRadius.circular(8)),
                            child: IconButton(
                              color: ThemeProvider.whiteColor,
                              onPressed: () {},
                              icon: const Icon(FontAwesomeIcons.penToSquare,
                            ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(color: ThemeProvider.redColor, borderRadius: BorderRadius.circular(8)),
                            child: IconButton(
                              color: ThemeProvider.whiteColor,
                              onPressed: () {},
                              icon: const Icon(FontAwesomeIcons.arrowsRotate),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  print('$index');
                },
              );
            },
          ),
        ),
      );
    },
  );
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
