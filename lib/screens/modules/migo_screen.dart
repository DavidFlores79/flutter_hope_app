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

class MigoScreen extends StatefulWidget {
  static const String routeName = 'entrada-mercancia';

  const MigoScreen({super.key});

  @override
  State<MigoScreen> createState() => _MigoScreenState();
}

class _MigoScreenState extends State<MigoScreen> {
  @override
  Widget build(BuildContext context) {
    final migoProvider = Provider.of<MigoProvider>(context);
    final orientation = MediaQuery.of(context).orientation;

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
                    key: migoProvider.formKey,
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
                                      labelText: 'Pedido',
                                      color: ThemeProvider.blueColor,
                                    ),
                                    onChanged: (value) =>
                                        migoProvider.numeroPedido = value,
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
                                    onPressed: migoProvider.isLoading
                                        ? null
                                        : () async {
                                            if (!migoProvider.isValidForm())
                                              return;
                                            FocusScope.of(context).unfocus();

                                            //hacer la peticion al backend
                                            //DEV: 4500002493
                                            //QA: 4500087697
                                            await migoProvider.getPedido(
                                                migoProvider.numeroPedido);
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
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: (migoProvider.isLoading)
                      ? Center(
                          child: SpinKitCubeGrid(
                            color: ThemeProvider.blueColor,
                          ),
                        )
                      : (migoProvider.result)
                          ? PedidoBox(
                              pedido: migoProvider.migoResponse.pedidoMigo!,
                              posiciones: [],
                            )
                          : const SizedBox(
                              width: 300,
                              height: 300,
                              child: Center(
                                child: Image(
                                  width: double.infinity,
                                  height: double.infinity,
                                  image: AssetImage(
                                      'assets/images/icons/migo.png'),
                                ),
                              ),
                            ),
                ),
              ],
            ),
    );
  }
}

class PedidoBox extends StatelessWidget {
  PedidoMigo pedido;
  double fontSize = 18;
  List<Posiciones> posiciones;

  PedidoBox({required this.pedido, required this.posiciones});

  @override
  Widget build(BuildContext context) {
    final migoProvider = Provider.of<MigoProvider>(context);
    posiciones = pedido.posiciones;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
          child: Column(
            children: [
              _MigoOrderHeaders(
                fontSize: fontSize,
                title: 'Clase Doc.:',
                value: pedido.cabeceraPedido.claseDocumento,
              ),
              _MigoOrderHeaders(
                fontSize: fontSize,
                title: 'Num. Pedido:',
                value: pedido.cabeceraPedido.numeroPedido,
              ),
              _MigoOrderHeaders(
                fontSize: fontSize,
                title: 'Proveedor:',
                value: pedido.cabeceraPedido.cuentaProveedor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
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
              return _PosicionItem(
                posicion: posicion,
                isSelected: migoProvider.posicionesSelected.contains(posicion),
              );
            }).toList(),
          ),
        ),
        ContabilizarButton(),
      ],
    );
  }
}

class ContabilizarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final migoProvider = Provider.of<MigoProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => validateSelectedPos(migoProvider),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(ThemeProvider.blueColor),
        ),
        child: Text(
          'Contabilizar',
          style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ThemeProvider.whiteColor),
        ),
      ),
    );
  }
}

validateSelectedPos(MigoProvider migoProvider) {
  (migoProvider.posicionesSelected.isNotEmpty)
      ? migoProvider.contabilizarEntrada()
      : Notifications.showSnackBar(
          "No se tienen posiciones seleccionadas para contabilizar.");
}

class _PosicionItem extends StatefulWidget {
  Posiciones posicion;
  bool isSelected;

  _PosicionItem({required this.posicion, required this.isSelected});

  @override
  State<_PosicionItem> createState() =>
      _PosicionItemState(isSelected: isSelected, posicion: posicion);
}

class _PosicionItemState extends State<_PosicionItem> {
  Posiciones posicion;
  bool isSelected;

  _PosicionItemState({required this.posicion, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final migoProvider = Provider.of<MigoProvider>(context);
    return Slidable(
      key: const ValueKey(0),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 7,
            onPressed: (context) => modalEditPos(context, migoProvider),
            backgroundColor: ThemeProvider.blueColor,
            foregroundColor: ThemeProvider.whiteColor,
            icon: Icons.edit,
            label: 'Editar',
          ),
        ],
      ),
      child: CheckboxListTile(
        title: _PosicionItemRow(posicion: posicion, isSelected: isSelected),
        controlAffinity: ListTileControlAffinity.leading,
        value: isSelected,
        onChanged: (value) {
          setState(() {
            isSelected = value!;
          });

          final posicionExiste =
              migoProvider.posicionesSelected.contains(posicion);

          posicionExiste
              ? migoProvider.posicionesSelected.remove(posicion)
              : migoProvider.posicionesSelected.add(posicion);
        },
      ),
    );
  }

  modalEditPos(BuildContext context, MigoProvider migoProvider) {
    migoProvider.newValue = posicion.cantidadRecibida.toString();
    bool showError = false;
    var _textController = TextEditingController();
    final FocusNode _focusNode = FocusNode();

    // Espera un frame antes de seleccionar el texto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _textController.text.length,
      );
      _focusNode.requestFocus();
    });

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              actions: [
                ElevatedButton(
                  onPressed: () => {
                    setState(() {
                      (double.parse(migoProvider.newValue) >
                              double.parse(posicion.cantidadFaltante))
                          ? showError = true
                          : showError = false;
                    }),
                    if (double.parse(migoProvider.newValue) ==
                        double.parse(posicion.cantidadRecibida))
                      {
                        print('es igual'),
                        Navigator.pop(context),
                      }
                    else if (double.parse(migoProvider.newValue) <
                        double.parse(posicion.cantidadFaltante))
                      {
                        if (migoProvider.validatePosQty(posicion))
                          {
                            Navigator.pop(context),
                            showConfirmPartial(context, migoProvider, posicion),
                            // migoProvider.updatePosQty(posicion)
                          },
                      }
                    else if (double.parse(migoProvider.newValue) ==
                        double.parse(posicion.cantidadFaltante))
                      {
                        print('es igual al total'),
                        migoProvider.finalDeliveryPos = true,
                        migoProvider.updatePosQty(posicion),
                        Navigator.pop(context),
                      }
                    else
                      {
                        print('newVal ${migoProvider.newValue}'),
                        print('cantidad ${posicion.cantidad}'),
                        print('cantidadFaltante ${posicion.cantidadFaltante}'),
                        print('cantidadRecibida ${posicion.cantidadRecibida}'),
                      }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ThemeProvider.blueColor),
                  ),
                  child: Text(
                    'Actualizar',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: ThemeProvider.whiteColor),
                  ),
                ),
              ],
              alignment: Alignment.center,
              title: Text(
                'Editar Posición',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ThemeProvider.blueColor,
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: Container(
                height: 230,
                child: Column(
                  children: [
                    _PosicionDetails(
                      value: posicion.numeroMaterial,
                      title: 'Material: ',
                    ),
                    const SizedBox(height: 10),
                    _PosicionDetails(
                      value: posicion.descripcionMaterial,
                      title: 'Desc: ',
                    ),
                    const SizedBox(height: 10),
                    _PosicionDetails(
                      value: posicion.umeComercial,
                      title: 'UM: ',
                    ),
                    const SizedBox(height: 10),
                    _PosicionDetails(
                      value: posicion.cantidad,
                      title: 'Pedido: ',
                    ),
                    const SizedBox(height: 10),
                    _PosicionDetails(
                      value: posicion.cantidadFaltante,
                      title: 'Faltante: ',
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Cantidad Recibida',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextField(
                      controller: _textController
                        ..text = migoProvider.newValue.toString(),
                      autofocus: true,
                      focusNode: _focusNode,
                      autocorrect: false,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        if (posicion.umeComercial == 'PZA' ||
                            posicion.umeComercial == 'Pieza')
                          FilteringTextInputFormatter.digitsOnly
                        else
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
                      textAlign: TextAlign.center,
                      onChanged: (value) => {
                        if (value != '')
                          {
                            print('Value: $value'),
                            migoProvider.newValue = value,
                          }
                      },
                      decoration: InputDecoration(
                        hintText: 'Cantidad',
                        errorText: showError
                            ? 'No se permite mayor a ${posicion.cantidadFaltante} ${posicion.umeComercial}'
                            : null,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ThemeProvider.lightColor,
                          ),
                        ),
                      ),
                    ),
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

class _PosicionDetails extends StatelessWidget {
  const _PosicionDetails({
    super.key,
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

showConfirmPartial(
    BuildContext context, MigoProvider migoProvider, Posiciones posicion) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            'Confirmar Parciales',
            style: TextStyle(
              color: ThemeProvider.blueColor,
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                '¿Esta es una entrada parcial o final?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ThemeProvider.lightColor,
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => {
              migoProvider.finalDeliveryPos = true,
              migoProvider.updatePosQty(posicion),
              Navigator.pop(context),
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(ThemeProvider.aquaBlueColor),
            ),
            child: Text(
              'Final',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: ThemeProvider.whiteColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => {
              migoProvider.finalDeliveryPos = false,
              migoProvider.updatePosQty(posicion),
              Navigator.pop(context),
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(ThemeProvider.blueColor),
            ),
            child: Text(
              'Parcial',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: ThemeProvider.whiteColor),
            ),
          ),
        ],
      );
    },
  );
}

class _PosicionItemRow extends StatelessWidget {
  const _PosicionItemRow({
    super.key,
    required this.posicion,
    required this.isSelected,
  });

  final Posiciones posicion;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Text(
            posicion.descripcionMaterial,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              color: isSelected
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
            posicion.cantidadRecibida.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              color: isSelected
                  ? ThemeProvider.blueColor
                  : ThemeProvider.lightColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _MigoOrderHeaders extends StatelessWidget {
  _MigoOrderHeaders({
    required this.fontSize,
    required this.title,
    required this.value,
  });

  final double fontSize;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            color: ThemeProvider.whiteColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title, //'Clase de Doc.: ',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: ThemeProvider.lightColor,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                  color: ThemeProvider.lightColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
      ],
    );
  }
}
