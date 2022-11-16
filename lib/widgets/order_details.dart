import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productos_app/models/models.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({
    Key? key,
    required this.pedidos,
    required this.titleSize,
  }) : super(key: key);

  final List<Pedido> pedidos;
  final double titleSize;

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
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              return ListTile(
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
                                fontSize: titleSize),
                          ),
                          Text(
                            pedidos[index].pedido,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: titleSize),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Creó: ',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: titleSize),
                          ),
                          Text(
                            pedidos[index].responsableSap,
                            style: TextStyle(
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
                      pedidos[index].fechaDocumento,
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
                          numberFormat(pedidos[index].importe),
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
