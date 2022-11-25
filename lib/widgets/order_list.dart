import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:provider/provider.dart';

class PedidosList extends StatefulWidget {
  List<PedidosProv> pedidosProv = [];

  PedidosList({super.key, required this.pedidosProv});

  @override
  State<PedidosList> createState() => _PedidosListState();
}

class _PedidosListState extends State<PedidosList> {
  //confirmar liberar todos los pedidos del proveedor
  confirmarLiberarTodos(
      List<Pedido> pedidos, String nombreProveedor, int index) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Confirmar Liberar",
            textAlign: TextAlign.center,
          ),
          content: Padding(
            padding: const EdgeInsets.all(5.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(
                      fontSize: 15,
                      color:
                          Preferences.isDarkMode ? Colors.white : Colors.black),
                  text: "¿Desea liberar todos los pedidos del Proveedor:   ",
                  children: [
                    TextSpan(
                      text: nombreProveedor,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: '?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: "??",
                    ),
                  ]),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final orderProvider =
                    Provider.of<PedidosProvider>(context, listen: false);
                orderProvider.liberarMultiple(pedidos, nombreProveedor);
                Navigator.of(context).pop(true);
              },
              child: const Text("Confirmar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double titleSize = 15;
    int selected = 0;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 25, bottom: 10),
          child: Text(
            'Liberación de Pedidos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: widget.pedidosProv.length,
              itemBuilder: (context, index) {
                final nombreProveedor = widget.pedidosProv[index].proveedor;
                final pedidos = widget.pedidosProv[index].pedidos;

                return ExpansionTile(
                  childrenPadding: const EdgeInsets.only(bottom: 15, left: 5),
                  backgroundColor: Preferences.isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
                  textColor: Preferences.isDarkMode
                      ? ThemeProvider.darkColor
                      : ThemeProvider.lightColor,
                  iconColor: Preferences.isDarkMode
                      ? ThemeProvider.darkColor
                      : ThemeProvider.lightColor,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombreProveedor,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                      TextButton(
                        style: const ButtonStyle(
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () => confirmarLiberarTodos(
                            pedidos, nombreProveedor, index),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 7),
                            decoration: BoxDecoration(
                                color: Preferences.isDarkMode
                                    ? ThemeProvider.darkColor
                                    : Colors.blue),
                            child: const Text(
                              'Liberar todos',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                        return await confirmarLiberar(
                            context, pedido, nombreProveedor);
                      },
                      onDismissed: (DismissDirection direction) {
                        setState(() {
                          pedidos.removeAt(index);
                        });
                      },
                      child: ListTile(
                        onTap: () {},
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
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

  Future<bool?> confirmarLiberar(
      BuildContext context, Pedido pedido, String nombreProveedor) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Confirmar Liberar",
            textAlign: TextAlign.center,
          ),
          content: Padding(
            padding: const EdgeInsets.all(5.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(
                      fontSize: 15,
                      color:
                          Preferences.isDarkMode ? Colors.white : Colors.black),
                  text: "¿Quieres liberar el pedido ",
                  children: [
                    TextSpan(
                      text: pedido.pedido,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: " del proveedor ",
                    ),
                    TextSpan(
                      text: nombreProveedor,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: "??",
                    ),
                  ]),
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  final orderProvider =
                      Provider.of<PedidosProvider>(context, listen: false);
                  final result = orderProvider.liberarPedido(pedido);
                  result.then(print);
                  result.then((value) {
                    if (value) {
                      Navigator.of(context).pop(true);
                    } else {
                      Navigator.of(context).pop(false);
                    }
                  });
                },
                child: const Text("Confirmar")),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
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
