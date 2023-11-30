import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/widgets/empty_container.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MonitorSolpedScreen extends StatelessWidget {
  static const String routeName = 'monitor-solped';
  bool futureExecuted = false;
  MonitorSolpedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final solpedMonitorProvider = Provider.of<MonitorSolpedProvider>(context);
    final pedidos = solpedMonitorProvider.pedidos;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => solpedMonitorProvider.getSolpeds(),
        child: FutureBuilder<List<Posicion>>(
          // Llamada al método async desde el Provider
          future: (futureExecuted != true)
              ? solpedMonitorProvider.getSolpeds()
              : Future.value(pedidos),
          builder: (context, snapshot) {
            print('futureExecuted $futureExecuted');

            if (!snapshot.hasData) {
              return Center(
                child: SpinKitCubeGrid(
                  color: ThemeProvider.blueColor,
                ),
              );
            }

            final List<Posicion> pedidos = snapshot.data!;
            futureExecuted = true;
            return Column(children: [
              const SizedBox(
                height: 20,
              ),
              solpedMonitorProvider.isLoading
                  ? const  Expanded(
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                  : pedidos.isEmpty
                      ? Expanded(
                          child: Center(
                            child: EmptyContainer(
                              assetImage:
                                  'assets/images/modules/order-tracking.png',
                              text: "No se encontraron resultados",
                            ),
                          ),
                        )
                      : ListaObjet(pedidos: pedidos)
            ]);
          },
        ),
      ),
    );
  }
}

class ListaObjet extends StatelessWidget {
  const ListaObjet({super.key, required this.pedidos});
  final List<Posicion> pedidos;

  @override
  Widget build(BuildContext context) {
    Posicion pedido;
    return Expanded(
      child: ListView.builder(
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          pedido = pedidos[index];
          return SlidableSimple(pedido: pedido);
        },
      ),
    );
  }
}

class SlidableSimple extends StatelessWidget {
  final Posicion pedido;

  SlidableSimple({Key? key, required this.pedido}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 7,
            onPressed: (context) => showPosicion(context, pedido),
            backgroundColor: ThemeProvider.blueColor,
            foregroundColor: ThemeProvider.whiteColor,
            icon: Icons.remove_red_eye_outlined,
            label: 'Mostrar',
          ),
        ],
      ),
      child: Container(
        child: ListTile(
          title: Column(
            children: [
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Doc.Solped: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${pedido.documentoSap}'),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Clase.Doc: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${pedido.clasedocto}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Text("Doc.Pedido:${pedido.documentoOc}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Doc.Pedido: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${pedido.documentoOc ?? ""}'),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Libero: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${pedido.usuarioLiberacion}'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Fecha. Lib: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ThemeProvider.blueColor),
                  ),
                  Text(
                    '${pedido.fechaLiberacion}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ThemeProvider.blueColor),
                  ),
                ],
              ),

              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }
}

showPosicion(context, Posicion pedido) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text(
          "Detalles",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _solpedFieldTitle(
                      label: 'Texto breve:',
                      value: pedido.textoBreve!,
                      alignment: CrossAxisAlignment.start,
                    ),
                    const SizedBox(height: 15),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _solpedField(
                            label: 'Material:',
                            value: pedido.material!,
                            alignment: CrossAxisAlignment.start,
                          ),
                          const SizedBox(height: 15),
                          _solpedField(
                            label: 'Cantidad:',
                            value: pedido.cantidad!,
                            alignment: CrossAxisAlignment.start,
                          ),
                        ]),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _solpedField(
                          label: 'Sociedad:',
                          value: pedido.sociedad!,
                          alignment: CrossAxisAlignment.start,
                        ),
                        _solpedField(
                          label: 'Libero:',
                          value: pedido.usuarioLiberacion!,
                          alignment: CrossAxisAlignment.start,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _solpedField(
                            label: 'Gpo.Comp:', value: pedido.gpoCompras!),
                        _solpedField(
                          label: 'Centro:',
                          value: "${pedido.centro}",
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ignore: camel_case_types
class _solpedField extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment alignment;

  const _solpedField({
    super.key,
    required this.value,
    required this.label,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class _solpedFieldTitle extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment alignment;

  const _solpedFieldTitle({
    super.key,
    required this.value,
    required this.label,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value),
      ],
    );
  }
}
