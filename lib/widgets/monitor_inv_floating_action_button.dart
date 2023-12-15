import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:provider/provider.dart';

class MonitorInvFloatingActionButton extends StatelessWidget {
  const MonitorInvFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final monitorInvTiendaProvider = Provider.of<MonitorInventarioTiendaProvider>(context);

    return (monitorInvTiendaProvider.posicionesSelected.isNotEmpty)
        ? FloatingActionButton(
            onPressed: () async {
              bool canCloseInv = true;
              monitorInvTiendaProvider.posicionesSelected.forEach((id) {
                final Inventario inventario = monitorInvTiendaProvider
                    .inventarios
                    .firstWhere((element) => element.id == id);
                if (inventario.estatus == 0 &&
                    inventario.documento != 'SIN DOCUMENTO') {
                  Notifications.showFloatingSnackBar(
                      'No fue posible cerrar el inventario ${inventario.documento}. No se ha realizado la contabilización del conteo');
                  canCloseInv = false;
                }
              });
              if (!canCloseInv) return;
              await monitorInvTiendaProvider.closeInventories();
            },
            backgroundColor: ThemeProvider.redColor,
            child: const Icon(FontAwesomeIcons.trashCan),
          )
        : Container();
  }
}
