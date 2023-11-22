import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/widgets/order_list.dart';
import 'package:provider/provider.dart';

class PedidosScreen extends StatelessWidget {
  static const String routeName = 'ordenes';

  const PedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<PedidosProvider>(context);
    bool isLoading = orderProvider.isLoading;

    Future<void> onRefresh() async {
      await orderProvider.getOrdenes();
    }

    return Scaffold(
      body: RefreshIndicator(
        color: ThemeProvider.darkColor,
        onRefresh: onRefresh,
        child: (!isLoading)
            ? PedidosList(pedidosProv: orderProvider.pedidosXProv)
            : Center(
                child: SpinKitCubeGrid(
                  color: ThemeProvider.darkColor,
                ),
              ),
      ),
    );
  }
}
