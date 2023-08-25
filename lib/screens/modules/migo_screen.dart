import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
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
                        pedido: migoProvider.pedido,
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
        buildContabilizarButton(context),
      ],
    );
  }
}

buildContabilizarButton(BuildContext context) {
  final migoProvider = Provider.of<MigoProvider>(context);

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    margin: const EdgeInsets.only(bottom: 10),
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: () {
        migoProvider.contabilizarEntrada();
      },
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

class _PosicionItem extends StatefulWidget {
  Posicione posicion;
  bool isSelected;

  _PosicionItem({required this.posicion, required this.isSelected});

  @override
  State<_PosicionItem> createState() =>
      _PosicionItemState(isSelected: this.isSelected, posicion: this.posicion);
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

  Future<dynamic> modalEditPos(
      BuildContext context, MigoProvider migoProvider) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () => {
              print('Nuevo valor ${migoProvider.newValue}'),
              migoProvider.updatePosQty(posicion),
              Navigator.pop(context),
            },
            child: const Text('Guardar'),
          )
        ],
        alignment: Alignment.topCenter,
        title: const Text(
          'Editar Posición',
          textAlign: TextAlign.center,
        ),
        content: TextField(
          controller: TextEditingController()
            ..text = posicion.cantidad.toString(),
          autofocus: true,
          autocorrect: false,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(
              RegExp(r'[0-9]+[,.]{0,1}[0-9]*'),
            ),
          ],
          textAlign: TextAlign.center,
          onChanged: (value) => {
            if (value != null)
              {
                print(value),
                migoProvider.newValue = value,
              }
          },
          decoration: const InputDecoration(
            hintText: 'Cantidad',
          ),
        ),
      ),
    );
  }

  showEditPos(BuildContext context) {
    final migoProvider = Provider.of<MigoProvider>(context, listen: false);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () => {
              print('Nuevo valor ${migoProvider.newValue}'),
              migoProvider.updatePosQty(posicion),
              // migoProvider.pedido.posiciones.map(
              //   (pos) => {
              //     if (pos.numeroMaterial == posicion.numeroMaterial)
              //       {pos.cantidad = migoProvider.newValue as int}
              //   },
              // ),
              Navigator.pop(context),
            },
            child: const Text('Guardar'),
          )
        ],
        alignment: Alignment.topCenter,
        title: const Text(
          'Editar Posición',
          textAlign: TextAlign.center,
        ),
        content: TextField(
          controller: TextEditingController()
            ..text = posicion.cantidad.toString(),
          autofocus: true,
          autocorrect: false,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(
              RegExp(r'[0-9]+[,.]{0,1}[0-9]*'),
            ),
          ],
          textAlign: TextAlign.center,
          onChanged: (value) => {
            if (value != null)
              {
                print(value),
                migoProvider.newValue = value,
              }
          },
          decoration: const InputDecoration(
            hintText: 'Cantidad',
          ),
        ),
      ),
    );
  }
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
            posicion.cantidad.toString(),
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
