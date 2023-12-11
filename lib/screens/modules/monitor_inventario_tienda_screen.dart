import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MonitorInventarioTiendaScreen extends StatefulWidget {
  static const String routeName = 'monitorinvtienda';

  const MonitorInventarioTiendaScreen({super.key});

  @override
  State<MonitorInventarioTiendaScreen> createState() => _MonitorInventarioTiendaScreenState();
}

class _MonitorInventarioTiendaScreenState extends State<MonitorInventarioTiendaScreen> {
  @override
  void initState() {
    super.initState();
    final monitorInvTienda = context.read<MonitorInventarioTiendaProvider>();
    monitorInvTienda.fecha1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    monitorInvTienda.fecha2 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    monitorInvTienda.searchByDates();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MonitorInventarioTiendaProvider>(
      builder: (context, monitorInvTienda, _) {
        return (monitorInvTienda.isLoadingCatalogs)
            ? Center(
                child: SpinKitCubeGrid(
                  color: ThemeProvider.blueColor,
                ),
              )
            : // Aquí colocas el contenido del screen cuando isLoading es false
            const MonitorInvTienda();
      },
    );
  }
}

class MonitorInvTienda extends StatelessWidget {
  const MonitorInvTienda({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}