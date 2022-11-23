import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/shared/preferences.dart';

class OrderList extends StatelessWidget {
  List<PedidosProv> pedidosProv = [];

  OrderList({super.key, required this.pedidosProv});

  @override
  Widget build(BuildContext context) {
    const double titleSize = 15;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Text(
            'Liberacion de Pedidos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: pedidosProv.length,
              itemBuilder: (context, index) {
                final nombreProveedor = pedidosProv[index].proveedor;
                final pedidos = pedidosProv[index].pedidos;

                return ExpansionTile(
                  title: Text(nombreProveedor),
                  children: pedidos.map((pedido) {
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 25),
                        child: const FaIcon(
                          FontAwesomeIcons.check,
                          color: Colors.white,
                        ),
                      ),
                      direction: DismissDirection.startToEnd,
                      confirmDismiss: (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              title: const Text("Confirmar Liberar"),
                              content: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Preferences.isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                      text:
                                          "Estas seguro que deseas liberar el pedido ",
                                      children: [
                                        TextSpan(
                                          text: pedido.pedido,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const TextSpan(
                                          text: "??",
                                        ),
                                      ]),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Confirmar")),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text(
                                    "Cancelar",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (DismissDirection direction) {
                        // setState(() {
                        //   widget.pedidos.removeAt(index);
                        // });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'El documento ${pedido.pedido} ha sido liberado')));
                      },
                      child: ListTile(
                        onTap: () {},
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Pedido: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: titleSize),
                                  ),
                                  Text(
                                    pedido.pedido,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: titleSize),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Creó: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: titleSize),
                                  ),
                                  Text(
                                    pedido.responsableSap,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: titleSize),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pedido.fechaDocumento,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 15),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration:
                                    const BoxDecoration(color: Colors.blue),
                                child: Text(
                                  numberFormat(pedido.importe),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
      ],
    );
  }
}

String numberFormatDlls(double numero) {
  NumberFormat f = NumberFormat("USD\$###,###,###.0##", "es_US");
  String result = f.format(numero);
  return result;
}

String numberFormat(double numero) {
  NumberFormat f = NumberFormat("\$###,###,###.0##", "es_MX");
  String result = f.format(numero);
  return result;
}
