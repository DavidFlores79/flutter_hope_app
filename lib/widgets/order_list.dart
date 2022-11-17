import 'package:flutter/material.dart';
import 'package:productos_app/models/order_response.dart';
import 'package:productos_app/widgets/widgets.dart';

class OrderList extends StatelessWidget {
  List<Pedido> pedidos = [];

  OrderList({super.key, required this.pedidos});

  @override
  Widget build(BuildContext context) {
    const double titleSize = 15;

    return OrderDetails(pedidos: pedidos, titleSize: titleSize);
  }
}
