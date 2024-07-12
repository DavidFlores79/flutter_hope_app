// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations_rounded.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/widgets/widgets.dart';

import 'package:provider/provider.dart';

class VerificarFacturaMiroScreen extends StatelessWidget {
  static String routeName = 'verificacion-factura';
  const VerificarFacturaMiroScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final verificarFacturaProvider =
        Provider.of<VerificacionFacturaMiroProvider>(context);
    return Scaffold(
      backgroundColor: Preferences.isDarkMode
          ? ThemeProvider.lightColor
          : ThemeProvider.whiteColor,
      body: (orientation == Orientation.landscape &&
              Preferences.deviceModel != 'iPad')
          ? EmptyContainer(
              assetImage: 'assets/images/icons/portrait.png',
              text:
                  'Coloque el dispositivo en posición VERTICAL para una mejor experiencia.')
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  color: Preferences.isDarkMode
                      ? ThemeProvider.lightColor
                      : ThemeProvider.whiteColor,
                  child: Form(
                    key: verificarFacturaProvider.formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    autofocus: true,
                                    autocorrect: false,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 10,
                                    decoration: InputDecorationsRounded
                                        .authInputDecorationRounded(
                                      hintText: '45xxxxxxxx',
                                      labelText: 'Doc.Pedido',
                                      color: ThemeProvider.blueColor,
                                    ),
                                    onChanged: (value) =>
                                        verificarFacturaProvider.numeroPedido =
                                            value,
                                    validator: (value) {
                                      return (value != null &&
                                              value.length == 10)
                                          ? null
                                          : 'Debe contener 10 numeros.';
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: verificarFacturaProvider
                                            .isLoading
                                        ? null
                                        : () async {
                                            if (!verificarFacturaProvider
                                                .isValidForm()) return;
                                            FocusScope.of(context).unfocus();
                                            //hacer la peticion al backend
                                            //DEV: 4500002493
                                            //QA: 4500087697
                                            await verificarFacturaProvider
                                                .getPedido(
                                                    verificarFacturaProvider
                                                        .numeroPedido);
                                          },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    disabledColor: Colors.grey[500],
                                    elevation: 0,
                                    color: ThemeProvider.blueColor,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 17),
                                      child: Icon(
                                        Icons.search,
                                        color: ThemeProvider.whiteColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: (verificarFacturaProvider.isLoading)
                      ? Center(
                          child: SpinKitCubeGrid(
                            color: ThemeProvider.blueColor,
                          ),
                        )
                      : (verificarFacturaProvider.result)
                          ? _pedidoBox(
                              pedido: verificarFacturaProvider.pedido!,
                              posiciones: const [],
                            )
                          : const SizedBox(
                              width: 300,
                              height: 300,
                              child: Center(
                                child: Image(
                                  width: double.infinity,
                                  height: double.infinity,
                                  image: AssetImage(
                                      'assets/images/icons/miro.png'),
                                ),
                              ),
                            ),
                ),
              ],
            ),
    );
  }
}

// ignore: must_be_immutable, camel_case_types
class _pedidoBox extends StatelessWidget {
  PedidoMiro pedido;
  double fontSize = 18;
  List<Posicione> posiciones;

  _pedidoBox({required this.pedido, required this.posiciones});

  @override
  Widget build(BuildContext context) {
    posiciones = pedido.posiciones!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          // margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Preferences.isDarkMode
                  ? ThemeProvider.lightColor
                  : ThemeProvider.whiteColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 4),
                )
              ]),
          width: double.infinity,
          child: const _inputsFactura(),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            const Expanded(
              flex: 7,
              child: Text(
                'Descripción',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Expanded(
              flex: 2,
              child: Text(
                'Cant.',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Expanded(
          child: ListView(
            children: posiciones.map((posicion) {
              return _posicionItem(posicion: posicion);
            }).toList(),
          ),
        ),
        _verificarButton(),
      ],
    );
  }
}

// ignore: camel_case_types
class _inputsFactura extends StatelessWidget {
  const _inputsFactura();
  @override
  Widget build(BuildContext context) {
    final verificarFacturaProvider =
        Provider.of<VerificacionFacturaMiroProvider>(context);
    TextEditingController monedaController = TextEditingController(text: 'MXN');
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
        key: verificarFacturaProvider.formKey2,
        child: Column(
          children: [
            TextFormField(
              maxLength: 16,
              initialValue: verificarFacturaProvider.referenciaInput,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.text,
              // readOnly: true, // Elimina o cambia a false
              decoration: InputDecorationsRounded.authInputDecorationRounded(
                hintText: 'Referencia Factura',
                labelText: 'Referencia Factura',
                color: ThemeProvider.blueColor,
              ),
              textAlign: TextAlign.left,
              onChanged: (value) =>
                  verificarFacturaProvider.referenciaInput = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La referencia es requerida';
                }
                if (value.contains(' ')) {
                  return 'La cadena no puede contener espacios en blanco.';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: size.width * .6,
                  child: TextFormField(
                    maxLength: 16,
                    initialValue:
                        verificarFacturaProvider.importeInput.toString(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecorationsRounded.authInputDecorationRounded(
                      hintText: 'Importe Factura',
                      labelText: 'Importe Factura',
                      color: ThemeProvider.blueColor,
                    ),
                    textAlign: TextAlign.left,
                    onChanged: (value) =>
                        verificarFacturaProvider.importeInput = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El campo no puede estar vacío.';
                      }
                      try {
                        double.parse(value);
                        return null; // No hay error, el valor es un número
                      } catch (e) {
                        return 'Por favor, ingrese un importe valido.';
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    maxLength: 16,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    readOnly: true,
                    decoration:
                        InputDecorationsRounded.authInputDecorationRounded(
                      hintText: 'MXN',
                      labelText: 'Moneda',
                      color: ThemeProvider.blueColor,
                    ),
                    textAlign: TextAlign.left,
                    controller: monedaController,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types, must_be_immutable
class _posicionItem extends StatefulWidget {
  Posicione posicion;

  _posicionItem({
    required this.posicion,
  });

  @override
  State<_posicionItem> createState() =>
      // ignore: no_logic_in_create_state
      _posicionItemState(posicion: posicion);
}

// ignore: camel_case_types
class _posicionItemState extends State<_posicionItem> {
  Posicione posicion;

  _posicionItemState({
    required this.posicion,
  });
  @override
  Widget build(BuildContext context) {
    final verificarFacturaProvider =
        Provider.of<VerificacionFacturaMiroProvider>(context);
    return Slidable(
      key: const ValueKey(0),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 7,
            onPressed: (context) =>
                _modalEditImportePos(context, verificarFacturaProvider),
            backgroundColor: ThemeProvider.blueColor,
            foregroundColor: ThemeProvider.whiteColor,
            icon: Icons.edit,
            label: 'Editar',
          ),
        ],
      ),
      child: CheckboxListTile(
        activeColor: ThemeProvider.blueColor,
        title: _posicionItemRow(posicion: posicion),
        controlAffinity: ListTileControlAffinity.leading,
        value: posicion.isSelected,
        selectedTileColor: ThemeProvider.blueColor,
        onChanged: (value) {
          setState(() {
            verificarFacturaProvider.updateSelected(posicion);
          });

          final posicionExiste =
              verificarFacturaProvider.posicionesSelected.contains(posicion);

          posicionExiste
              ? verificarFacturaProvider.posicionesSelected.remove(posicion)
              : verificarFacturaProvider.posicionesSelected.add(posicion);
        },
      ),
    );
  }

  _modalEditImportePos(BuildContext context,
      VerificacionFacturaMiroProvider verificarFacturaProvider) {
    bool showError = false;
    var textController = TextEditingController();
    String importe = posicion.importeRecibido.toString();
    double newimporte = 0;
    final size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              alignment: Alignment.center,
              title: Text(
                'Modificar Importe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ThemeProvider.blueColor,
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: SizedBox(
                height: 330,
                child: Column(
                  children: [
                    _posicionDetails(
                      value: posicion.numeroMaterial!,
                      title: 'Numero de Material: ',
                    ),
                    const SizedBox(height: 10),
                    _posicionDetails(
                      value: posicion.descripcionMaterial!,
                      title: 'Texto Breve: ',
                    ),
                    const SizedBox(height: 10),
                    _posicionDetails(
                      value: posicion.centroReceptor!,
                      title: 'Centro: ',
                    ),
                    const SizedBox(height: 10),
                    _posicionDetails(
                      value: posicion.umeComercial!,
                      title: 'UM: ',
                    ),
                    const SizedBox(height: 10),
                    _posicionDetails(
                      value: posicion.cantidad.toString(),
                      title: 'Cantidad: ',
                    ),
                    const SizedBox(height: 10),
                    _posicionDetails(
                      value: posicion.importeRecibido!.toString(),
                      title: 'Imp.Pedido: ',
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Importe Recibido',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Form(
                      key: verificarFacturaProvider.formKey3,
                      child: TextFormField(
                          initialValue: posicion.importeRecibido.toString(),
                          autofocus: true,
                          autocorrect: false,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9]+[,.]{0,1}[0-9]*'),
                            ),
                          ],
                          textAlign: TextAlign.center,
                          // onChanged: (value) => {
                          //   value = posicion.importeRecibido.toString(),
                          //   print(value),
                          //   if (value.isNotEmpty && value.contains(' '))
                          //     {
                          //       importe = double.parse(value),
                          //       // ignore: avoid_print
                          //       print('Value: $value'),
                          //     }
                          // },
                          onChanged: (value) => importe = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El campo no puede estar vacío.';
                            }
                            try {
                              double.parse(value);
                              return null; // No hay error, el valor es un número
                            } catch (e) {
                              return 'Por favor, ingrese un importe valido.';
                            }
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            fixedSize: Size((size.width / 4), 20),
                            foregroundColor: Colors.white,
                            backgroundColor: ThemeProvider.blueColor,
                            disabledForegroundColor: Colors.transparent,
                            disabledBackgroundColor: Colors.transparent,
                          ),
                          onPressed: () {
                            if (!verificarFacturaProvider.isValidForm3()) {
                              return;
                            }

                            FocusScope.of(context).unfocus();
                            newimporte = double.parse(importe);
                            if (newimporte >= 0) {
                              posicion.importeRecibido = newimporte;
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Confirmar'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ignore: unused_element, camel_case_types
class _posicionDetails extends StatelessWidget {
  const _posicionDetails({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

// ignore: camel_case_types
class _posicionItemRow extends StatelessWidget {
  const _posicionItemRow({
    required this.posicion,
  });

  final Posicione posicion;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Text(
            posicion.descripcionMaterial!,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              color: posicion.isSelected
                  ? ThemeProvider.blueColor
                  : ThemeProvider.lightColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          flex: 2,
          child: Text(
            posicion.cantidad.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              color: posicion.isSelected
                  ? ThemeProvider.blueColor
                  : ThemeProvider.lightColor,
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: camel_case_types
class _verificarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final verificacionFacturaMiroProvider =
        Provider.of<VerificacionFacturaMiroProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (!verificacionFacturaMiroProvider.isValidForm2()) return;
          FocusScope.of(context).unfocus();
          _validateSelectedPos(verificacionFacturaMiroProvider);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(ThemeProvider.blueColor),
        ),
        child: Text(
          'Verificar',
          style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ThemeProvider.whiteColor),
        ),
      ),
    );
  }
}

_validateSelectedPos(
    VerificacionFacturaMiroProvider verificacionFacturaMiroProvider) {
  print("*************");
  print(verificacionFacturaMiroProvider.posicionesSelected);
  (verificacionFacturaMiroProvider.posicionesSelected.isNotEmpty)
      ? verificacionFacturaMiroProvider.verificacionFactura()
      : Notifications.showSnackBar(
          "No se tienen posiciones seleccionadas para verificar.");
}
