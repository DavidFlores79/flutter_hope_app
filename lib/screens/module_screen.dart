import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:provider/provider.dart';

class ModuleScreen extends StatelessWidget {
  static const String routeName = 'module_screen';

  const ModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Modulo modulo = ModalRoute.of(context)!.settings.arguments as Modulo;
    final screenProvider = Provider.of<ModuleScreenProvider>(context);

    List<ModuleScreenDTO> items = [
    ModuleScreenDTO(
      label: 'Solicitud de Pedidos',
      route: SolpedScreen.routeName,
      widget: SolpedScreen(),
    ),
    ModuleScreenDTO(
      label: 'Liberar Solicitud de Pedidos',
      route: LiberarSolpedScreen.routeName,
      widget: LiberarSolpedScreen(),
      icon: FontAwesomeIcons.calendar,
      onPressedCallback: (BuildContext context) {
        showDialog(
          context: context,
          builder: showDatesModal,
        );
      },
    ),
    ModuleScreenDTO(
      label: 'MIGO',
      route: MigoScreen.routeName,
      widget: const MigoScreen(),
    ),
    ModuleScreenDTO(
      label: 'Monitor Solped',
      route: MonitorSolpedScreen.routeName,
      widget: MonitorSolpedScreen(),
    ),
    ModuleScreenDTO(
      label: 'Creación de Pedidos',
      route: ME21NScreen.routeName,
      widget: ME21NScreen(),
    ),
    ModuleScreenDTO(
      label: 'Consulta Stock',
      route: ConsultaStockScreen.routeName,
      widget: ConsultaStockScreen(),
    ),
    ModuleScreenDTO(
      label: 'Recibo Embarque',
      route: ReciboEmbarqueScreen.routeName,
      widget: ReciboEmbarqueScreen(),
    ),
  ];

    final ModuleScreenDTO moduleScreen = items.firstWhere(
        (element) => element.route == modulo.ruta,
        orElse: () => screenProvider.selectedScreen);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(moduleScreen.label!),
        actions: [
          IconButton(
            onPressed: () => moduleScreen.onPressedCallback?.call(context),
            icon: Icon(moduleScreen.icon),
          )
        ],
      ),
      body: moduleScreen.widget,
    );
  }

  Widget showDatesModal(BuildContext context) {
      return AlertDialog(
        title: const Text('Título del AlertDialog'),
        content: const Text('Contenido del AlertDialog'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    }
}
