import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/widgets/order_list.dart';
import 'package:provider/provider.dart';

class PedidosScreen extends StatelessWidget {
  static const String routeName = 'ordenes';

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<PedidosProvider>(context);

    Future<void> onRefresh() async {
      orderProvider.getOrdenes();
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: PedidosList(pedidosProv: orderProvider.pedidosXProv),
      ),
    );
  }
}
