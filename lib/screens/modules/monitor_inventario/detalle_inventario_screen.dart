import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/monitor_inventario/monitor_inventario_response.dart';
import 'package:hope_app/ui/input_decorations_rounded.dart';
import 'package:hope_app/ui/notifications.dart';
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
    final monitorInvTienda =
        Provider.of<MonitorInventarioTiendaProvider>(context);
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
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: detallesInv!
                        .length, // Cantidad de elementos en tu lista
                    itemBuilder: (BuildContext context, int index) {
                      final detalle = detallesInv[index];

                      return Card(
                        elevation: 5,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          title: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _CardColumnItemValue(
                                        label: 'Cod.Barra',
                                        value: '${detalle.codbar}'),
                                    Image.asset(
                                        'assets/images/modules/inventory.png',
                                        height: 50),
                                  ],
                                ),
                                _CardColumnItemValue(
                                    label: 'Material',
                                    value: '${detalle.material}'),
                                _CardColumnItemValue(
                                    label: 'Descripción',
                                    value: '${detalle.descripcion}'),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _CardColumnItemValue(
                                        label: 'Cant.Teórica',
                                        value: '${detalle.cantidadTeorica}'),
                                    _CardColumnItemValue(
                                        label: 'Total Cont.',
                                        value:
                                            '${double.parse(detalle.cantidad!)}'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _CardColumnItemValue(
                                        label: 'Diferencia',
                                        value:
                                            '${double.parse(detalle.diferencia!)}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onTap: () =>
                              _showPosicion(context, monitorInvTienda, detalle),
                        ),
                      );
                    },
                  ),
                ),
                if (monitorInvTienda.inventario.documento != 'SIN DOCUMENTO')
                  Container(
                    margin: const EdgeInsets.only(
                        bottom: 30, left: 15, right: 15, top: 10),
                    child: MaterialButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        //hacer la peticion al backend
                        final result = await monitorInvTienda.saveOnSAP();
                        print('Result: $result');

                        if (result) {
                          Future.delayed(const Duration(milliseconds: 2000),
                              () {
                            monitorInvTienda.getInventario();
                          });
                          // Future.microtask(() => Navigator.pop(context));
                        }
                        print('Result $result');
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      disabledColor: ThemeProvider.blueColor.withAlpha(150),
                      elevation: 0,
                      color: ThemeProvider.blueColor,
                      minWidth: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: monitorInvTienda.isLoadingCatalogs
                            ? const CupertinoActivityIndicator()
                            : const Text(
                                'Enviar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

_showPosicion(context, MonitorInventarioTiendaProvider monitorInvTienda,
    InventarioDetalle detalle) {
  return showDialog(
    context: context,
    barrierColor: Colors.black12,
    builder: (BuildContext context) {
      return InvDetailsAlert(
        context: context,
        detalle: detalle,
      );
    },
  );
}

class InvDetailsAlert extends StatefulWidget {
  BuildContext context;
  // MonitorInventarioTiendaProvider monitorInvTienda;
  InventarioDetalle detalle;

  InvDetailsAlert({
    super.key,
    required this.context,
    required this.detalle,
  });

  @override
  State<InvDetailsAlert> createState() => _InvDetailsAlertState();
}

class _InvDetailsAlertState extends State<InvDetailsAlert> {
  @override
  void initState() {
    final monitorInvTienda = context.read<MonitorInventarioTiendaProvider>();
    monitorInvTienda.result = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final monitorInvTienda =
        Provider.of<MonitorInventarioTiendaProvider>(context);
    monitorInvTienda.detallesMaterial = widget.detalle.detalles!;
    final size = MediaQuery.of(context).size;
    final minHeight = size.height * 0.1;

    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: (monitorInvTienda.detallesMaterial.isNotEmpty)
          ? const Text(
              "Detalle Material",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            )
          : null,
      contentPadding: const EdgeInsets.only(top: 20, bottom: 10),
      content: SizedBox(
        width: double.maxFinite,
        height:
            (size.height * (monitorInvTienda.detallesMaterial.length * 0.15))
                .clamp(minHeight, size.height),
        child: (monitorInvTienda.detallesMaterial.isNotEmpty)
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: monitorInvTienda.detallesMaterial
                          .length, // Cantidad de elementos en tu lista
                      itemBuilder: (BuildContext context, int index) {
                        final detalleMaterial =
                            monitorInvTienda.detallesMaterial[index];

                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          title: SingleChildScrollView(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CardItemLabelValue(
                                          label: 'Mueble:',
                                          value: '${detalleMaterial.mueble}'),
                                      CardItemLabelValue(
                                          label: 'Resp:',
                                          value:
                                              '${detalleMaterial.responsable}'),
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
                                      decoration: BoxDecoration(
                                          color: ThemeProvider.blueColor,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: IconButton(
                                        color: ThemeProvider.whiteColor,
                                        onPressed: () {
                                          _editCounting(
                                              context,
                                              monitorInvTienda,
                                              detalleMaterial,
                                              widget.detalle);
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          FontAwesomeIcons.penToSquare,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: ThemeProvider.redColor,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: IconButton(
                                        color: ThemeProvider.whiteColor,
                                        onPressed: () {
                                          _recountingRack(
                                            context,
                                            detalleMaterial,
                                            widget.detalle,
                                          );
                                          // widget.detalle.detalles!.remove(detalleMaterial);
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                            FontAwesomeIcons.arrowsRotate),
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
                  // if (monitorInvTienda.result)
                  //   Visibility(
                  //     visible: monitorInvTienda.result,
                  //     child: TweenAnimationBuilder<double>(
                  //       duration: const Duration(seconds: 3),
                  //       onEnd: () {
                  //         monitorInvTienda.result = false;
                  //         setState(() {});
                  //       },
                  //       tween: Tween<double>(begin: 1.0, end: 0.0),
                  //       builder: (_, double opacity, __) {
                  //         return Opacity(
                  //           opacity: opacity,
                  //           child: Container(
                  //             margin: const EdgeInsets.symmetric(
                  //                 vertical: 10, horizontal: 15),
                  //             padding: const EdgeInsets.symmetric(
                  //                 vertical: 5, horizontal: 10),
                  //             decoration: BoxDecoration(
                  //                 color: Colors.green,
                  //                 borderRadius: BorderRadius.circular(5)),
                  //             child: Text(
                  //               '${monitorInvTienda.monitorInventarioResponse!.message}',
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   color: ThemeProvider.whiteColor),
                  //               textAlign: TextAlign.center,
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.ban,
                    size: 50,
                    color: ThemeProvider.redColor,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sin Detalles',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
      ),
    );
  }
}

_editCounting(context, MonitorInventarioTiendaProvider monitorInvTienda,
    DetalleDetalle detalleMaterial, InventarioDetalle detalle) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditCountingAlert(
          detalleMaterial: detalleMaterial, detalle: detalle);
    },
  );
}

class EditCountingAlert extends StatefulWidget {
  InventarioDetalle detalle;
  DetalleDetalle detalleMaterial;

  EditCountingAlert(
      {super.key, required this.detalleMaterial, required this.detalle});

  @override
  State<EditCountingAlert> createState() => _EditCountingAlertState();
}

class _EditCountingAlertState extends State<EditCountingAlert> {
  @override
  Widget build(BuildContext context) {
    bool result = false;
    final size = MediaQuery.of(context).size;
    final monitorInvTienda =
        Provider.of<MonitorInventarioTiendaProvider>(context);

    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: const Text(
        "Editar Detalle",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      content: SizedBox(
        width: double.minPositive,
        child: Form(
          key: monitorInvTienda.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                initialValue: widget.detalleMaterial.mueble!,
                keyboardType: TextInputType.text,
                decoration: InputDecorationsRounded.authInputDecorationRounded(
                  hintText: 'Mueble',
                  labelText: 'Mueble',
                  color: ThemeProvider.blueColor,
                  suffixIcon: FontAwesomeIcons.warehouse,
                ),
                textAlign: TextAlign.center,
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'El mueble debe contener al menos 1 caracter';
                },
                onChanged: (value) {
                  print(value);
                  widget.detalleMaterial.mueble = value;
                  // textController.text = value;
                  setState(() {});
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                initialValue: widget.detalleMaterial.cantidad.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final text = newValue.text;
                    return text.isEmpty
                        ? newValue
                        : double.tryParse(text) == null
                            ? oldValue
                            : newValue;
                  }),
                ],
                decoration: InputDecorationsRounded.authInputDecorationRounded(
                  hintText: 'Cantidad',
                  labelText: 'Cantidad',
                  color: ThemeProvider.blueColor,
                  suffixIcon: FontAwesomeIcons.boxOpen,
                ),
                textAlign: TextAlign.center,
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Por favor agrega la cantidad.';
                },
                onChanged: (value) {
                  print(value);
                  widget.detalleMaterial.cantidad = value;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: ThemeProvider.lightRed,
                disabledForegroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                fixedSize: Size((size.width / 5), 20),
                foregroundColor: Colors.white,
                backgroundColor: ThemeProvider.blueColor,
                disabledForegroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
              ),
              onPressed: () async {
                if (!monitorInvTienda.isValidForm()) return;
                try {
                  Navigator.pop(context);
                  result =
                      await monitorInvTienda.saveInvDetails(widget.detalle);
                  monitorInvTienda.detallesMaterial = monitorInvTienda
                      .monitorInventarioResponse!.materialDetalles!;
                  print('Result SaveInvDetails: $result');
                } catch (error) {
                  print('Error al editar Detalle: $error');
                  Notifications.showFloatingSnackBar(
                      'Error al editar Detalle: $error');
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        )
      ],
    );
  }
}

_recountingRack(BuildContext context, DetalleDetalle detalleMaterial,
    InventarioDetalle inventarioDetalle) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return RecountingRackAlert(
        detalleMaterial: detalleMaterial,
        inventarioDetalle: inventarioDetalle,
      );
    },
  );
}

class RecountingRackAlert extends StatefulWidget {
  DetalleDetalle detalleMaterial;
  InventarioDetalle inventarioDetalle;

  RecountingRackAlert(
      {super.key,
      required this.detalleMaterial,
      required this.inventarioDetalle});

  @override
  State<RecountingRackAlert> createState() => _RecountingRackAlertState();
}

class _RecountingRackAlertState extends State<RecountingRackAlert> {
  @override
  Widget build(BuildContext context) {
    final monitorInvTienda =
        Provider.of<MonitorInventarioTiendaProvider>(context);

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      content: const SizedBox(
        width: double.minPositive,
        child: Text(
          '¿Está seguro que desea volver a contar el mueble?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: ThemeProvider.lightRed,
                disabledForegroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                // fixedSize: Size((size.width / 5), 20),
                foregroundColor: Colors.white,
                backgroundColor: ThemeProvider.blueColor,
                disabledForegroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
              ),
              onPressed: () async {
                try {
                  Navigator.pop(context);
                  final result = await monitorInvTienda.recountRack(
                      widget.detalleMaterial, widget.inventarioDetalle.id!);
                  print('Result recountingRack: $result');
                  if(result) {
                    widget.inventarioDetalle.detalles!.remove(widget.detalleMaterial);
                  }
                } catch (error) {
                  print('Error al recontar mueble: $error');
                  Notifications.showFloatingSnackBar(
                      'Error al recontar mueble: $error');
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        )
      ],
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
