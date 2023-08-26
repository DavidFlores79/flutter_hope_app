import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
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
    final Color myColor = ThemeProvider.lightColor;
    bool response = false;

    return Scaffold(
      backgroundColor: Preferences.isDarkMode
          ? ThemeProvider.lightColor
          : ThemeProvider.whiteColor,
      body: Column(
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
                              decoration: InputDecoration(
                                hintText: '45xxxxxxxx',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                ),
                                labelText: 'Pedido',
                                labelStyle: TextStyle(
                                  color: ThemeProvider.lightColor,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ThemeProvider.blueColor,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ThemeProvider.blueColor,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ThemeProvider.blueColor,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onChanged: (value) =>
                                  migoProvider.numeroPedido = value,
                              validator: (value) {
                                return (value != null && value.length == 10)
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
                                      if (!migoProvider.isValidForm()) return;
                                      FocusScope.of(context).unfocus();

                                      //hacer la peticion al backend
                                      //DEV: 4500002493
                                      //QA: 4500087697
                                      response = await migoProvider
                                          .getPedido(migoProvider.numeroPedido);
                                    },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              disabledColor: Colors.grey[500],
                              elevation: 0,
                              color: ThemeProvider.blueColor,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 17),
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
                    : Container(),
          ),
        ],
      ),
    );
  }
}

class PedidoBox extends StatelessWidget {
  PedidoMigo pedido;
  double fontSize = 18;
  List<Posicione> posiciones;

  PedidoBox({required this.pedido, required this.posiciones});

  @override
  Widget build(BuildContext context) {
    posiciones = pedido.posiciones;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
              _MigoOrderRow(
                fontSize: fontSize,
                title: 'Clase Doc.:',
                value: pedido.cabeceraPedido.claseDocumento,
              ),
              _MigoOrderRow(
                fontSize: fontSize,
                title: 'Num. Pedido:',
                value: pedido.cabeceraPedido.numeroPedido,
              ),
              _MigoOrderRow(
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
              return _PosicionItem(posicion: posicion, isSelected: false);
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
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => validateSelectedPos(migoProvider),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(const Color.fromARGB(255, 17, 92, 153)),
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
  Posicione posicion;
  bool isSelected;

  _PosicionItem({required this.posicion, required this.isSelected});

  @override
  State<_PosicionItem> createState() =>
      _PosicionItemState(isSelected: isSelected, posicion: posicion);
}

class _PosicionItemState extends State<_PosicionItem> {
  Posicione posicion;
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
                    if (double.parse(migoProvider.newValue) <=
                        double.parse(posicion.cantidadFaltante))
                      {
                        // migoProvider.validatePosQty(posicion),
                        // migoProvider.updatePosQty(posicion),
                        if (migoProvider.validatePosQty(posicion))
                          {
                            Navigator.pop(context),
                            showConfirmPartial(context),
                          },
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
              content: TextField(
                controller: _textController
                  ..text = migoProvider.newValue.toString(),
                autofocus: true,
                autocorrect: false,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]+[,.]{0,1}[0-9]*'),
                  ),
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
            );
          },
        );
      },
    );
  }
}

showConfirmPartial(BuildContext context) {
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

  final Posicione posicion;
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

class _MigoOrderRow extends StatelessWidget {
  _MigoOrderRow({
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title, //'Clase de Doc.: ',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
