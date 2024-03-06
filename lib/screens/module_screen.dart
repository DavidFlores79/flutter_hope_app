import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/modules/sbo/quotations_screen.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/widgets/show_alert_filter_calendar.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ModuleScreen extends StatelessWidget {
  static const String routeName = 'module_screen';

  const ModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Modulo modulo = ModalRoute.of(context)!.settings.arguments as Modulo;
    final screenProvider = Provider.of<ModuleScreenProvider>(context);
    final monitorSolpedProvider =
        Provider.of<MonitorSolpedProvider>(context, listen: false);
    final liberarSolpedProvider =
        Provider.of<LiberarSolpedProvider>(context, listen: false);
    final verificacionFacturaMiroProvider =
        Provider.of<VerificacionFacturaMiroProvider>(context, listen: true);
    final monitorInvTiendaProvider =
        Provider.of<MonitorInventarioTiendaProvider>(context);
    final releasePurchaseRequestProvider =
        Provider.of<ReleasePurchaseRequestProvider>(context);

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
        onPressedCallback: (BuildContext context) =>
            showDatesModal(context, liberarSolpedProvider),
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
        icon: FontAwesomeIcons.calendar,
        onPressedCallback: (BuildContext context) =>
            showDatesModal(context, monitorSolpedProvider),
      ),
      ModuleScreenDTO(
        label: 'Creación de Pedidos',
        route: ME21NScreen.routeName,
        widget: ME21NScreen(),
      ),
      ModuleScreenDTO(
        label: 'Consulta Stock',
        route: ConsultaStockScreen.routeName,
        widget: const ConsultaStockScreen(),
        icon: FontAwesomeIcons.magnifyingGlass,
        onPressedCallback: (BuildContext context) =>
            consultaStockModal(context),
      ),
      ModuleScreenDTO(
        label: 'Recibo Embarque',
        route: ReciboEmbarqueScreen.routeName,
        widget: const ReciboEmbarqueScreen(),
      ),
      ModuleScreenDTO(
        label: 'Transf. Internas',
        route: TransferenciasInternasScreen.routeName,
        widget: const TransferenciasInternasScreen(),
      ),
      ModuleScreenDTO(
        label: 'Verificar Factura (Miro)',
        route: VerificarFacturaMiroScreen.routeName,
        widget: const VerificarFacturaMiroScreen(),
        icon: verificacionFacturaMiroProvider.result != false
            ? FontAwesomeIcons.calendar
            : null,
        onPressedCallback: (BuildContext context) {
          if (verificacionFacturaMiroProvider.result != false) {
            showDatesModalMiro(context, verificacionFacturaMiroProvider);
          }
        },
      ),
      ModuleScreenDTO(
        label: 'Inventario IM',
        route: InventarioTiendaScreen.routeName,
        widget: const InventarioTiendaScreen(),
      ),
      ModuleScreenDTO(
        label: 'Monitor Inventario',
        route: MonitorInventarioTiendaScreen.routeName,
        widget: const MonitorInventarioTiendaScreen(),
        icon: FontAwesomeIcons.calendar,
        onPressedCallback: (BuildContext context) =>
            showDatesModal(context, monitorInvTiendaProvider),
        floatingActionButton: const MonitorInvFloatingActionButton(),
      ),
      // ****************** SAP BUSINESS ONE *******************
      ModuleScreenDTO(
        label: 'Solicitud de Compra',
        route: PurchaseRequestScreen.routeName,
        widget: const PurchaseRequestScreen(),
      ),
      ModuleScreenDTO(
        label: 'Liberar Solicitud de Compra',
        route: ReleasePurchaseRequestScreen.routeName,
        widget: ReleasePurchaseRequestScreen(),
        icon: FontAwesomeIcons.calendar,
        onPressedCallback: (BuildContext context) =>
            showDatesModal(context, releasePurchaseRequestProvider),
      ),
      ModuleScreenDTO(
        label: 'Oferta de Ventas',
        route: QuotationsScreen.routeName,
        widget: QuotationsScreen(),
      ),
      //****************** SAP BUSINESS ONE *********************
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
      floatingActionButton: moduleScreen.floatingActionButton,
    );
  }
}
