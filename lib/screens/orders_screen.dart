import 'package:flutter/material.dart';
import 'package:productos_app/models/error_response.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/widgets/order_list.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = 'ordenes';

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      body: OrderList(pedidos: orderProvider.pedidos),
    );
  }
}
