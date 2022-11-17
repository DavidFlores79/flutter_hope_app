import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/shared/preferences.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({
    Key? key,
    required this.pedidos,
    required this.titleSize,
  }) : super(key: key);

  final List<Pedido> pedidos;
  final double titleSize;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Text(
            'Liberacion de Pedidos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: widget.pedidos.length,
            itemBuilder: (context, index) {
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
                        title: const Text("Confirmar Liberar"),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
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
                                    text: "${widget.pedidos[index].pedido}",
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
                              onPressed: () => Navigator.of(context).pop(true),
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
                },
                onDismissed: (DismissDirection direction) {
                  setState(() {
                    widget.pedidos.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'El documento ${widget.pedidos[index].pedido} ha sido liberado')));
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
                            Text(
                              'Pedido: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: widget.titleSize),
                            ),
                            Text(
                              widget.pedidos[index].pedido,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: widget.titleSize),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Creó: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: widget.titleSize),
                            ),
                            Text(
                              widget.pedidos[index].responsableSap,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: widget.titleSize),
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
                        widget.pedidos[index].fechaDocumento,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 15),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: const BoxDecoration(color: Colors.blue),
                          child: Text(
                            numberFormat(widget.pedidos[index].importe),
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
            },
            separatorBuilder: (_, __) => const Divider(),
          ),
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
