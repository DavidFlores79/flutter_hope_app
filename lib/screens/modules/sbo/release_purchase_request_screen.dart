import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/modules/sbo/release_purchase_request/selectable_purchase_request_card.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ReleasePurchaseRequestScreen extends StatefulWidget {
  static const String routeName = 'sbo-liberarsolped';

  const ReleasePurchaseRequestScreen({super.key});

  @override
  State<ReleasePurchaseRequestScreen> createState() =>
      _ReleasePurchaseRequestScreenState();
}

class _ReleasePurchaseRequestScreenState
    extends State<ReleasePurchaseRequestScreen> {
  @override
  void initState() {
    super.initState();
    final releasePurchaseRequest =
        context.read<ReleasePurchaseRequestProvider>();
    releasePurchaseRequest.getCatalogs();
  }

  listenWSMessages(
    dynamic data,
    ReleasePurchaseRequestProvider releasePurchaseRequestProvider,
  ) {
    final WebsocketMessage message = WebsocketMessage.fromMap(data);
    // print('WS: ${message.type} ${message.data!.id}');
    switch (message.type) {
      case 'store':
        print('WS: ${message.type} ${message.data!.id}');
        releasePurchaseRequestProvider.addDocumentLine(message.data!);
        break;
      case 'update':
        print('WS: ${message.type} ${message.data!.id}');
        releasePurchaseRequestProvider.updateDocumentLine(message.data!);
        break;
      case 'delete':
        print('WS: ${message.type} ${message.data!.id}');
        releasePurchaseRequestProvider.removeDocumentLine(message.data!);
        break;
      default:
    }
  }

  listenWSReleaseMessages(
    dynamic data,
    ReleasePurchaseRequestProvider releasePurchaseRequestProvider,
  ) {
    try {
      final List<DocumentLine> lines =
          (data['data'] as List<dynamic>).map((obj) {
        return DocumentLine.fromMap(obj as Map<String, dynamic>);
      }).toList();

      switch (data['type']) {
        case 'release':
          print('WS: ${data['type']} ${lines}');
          //releasePurchaseRequestProvider.updateDocumentLines(lines!);
          releasePurchaseRequestProvider.removeDocumentLines(lines!);
          break;
        case 'reject':
          print('WS: ${data['type']} ${lines}');
          releasePurchaseRequestProvider.removeDocumentLines(lines!);
          break;
        default:
      }
    } catch (e) {
      Notifications.showSnackBar('Error WS Release Purchase Request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final releasePurchaseRequestProvider =
        Provider.of<ReleasePurchaseRequestProvider>(context);
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.checkConnection();
    final releasePurchaseRequest =
        Provider.of<ReleasePurchaseRequestProvider>(context);
    final documentLines = releasePurchaseRequest.documentLines;
    final List<int> linesSelected = releasePurchaseRequest.linesSelected;
    final orientation = MediaQuery.of(context).orientation;

    socketService.socket.on(
        'purchase-request',
        (data) => listenWSMessages(
              data,
              releasePurchaseRequestProvider,
            ));
    socketService.socket.on(
        'release-purchase-request',
        (data) => listenWSReleaseMessages(
              data,
              releasePurchaseRequestProvider,
            ));

    return RefreshIndicator.adaptive(
      onRefresh: () => releasePurchaseRequestProvider.searchByDates(),
      child: Consumer<ReleasePurchaseRequestProvider>(
        builder: (context, releasePurchaseRequest, _) {
          return (releasePurchaseRequest.isLoading)
              ? Center(
                  child: SpinKitCubeGrid(
                    color: ThemeProvider.blueColor,
                  ),
                )
              : // Aquí colocas el contenido del screen cuando isLoading es false
              (orientation == Orientation.portrait ||
                      Preferences.deviceModel == 'iPad' ||
                      Preferences.deviceModel == 'Tablet')
                  ? (releasePurchaseRequest.isLoadingData)
                      ? Center(
                          child: SpinKitCubeGrid(
                            color: ThemeProvider.blueColor,
                          ),
                        )
                      : (documentLines!.isEmpty)
                          ? GestureDetector(
                              onTap: () => releasePurchaseRequestProvider
                                  .searchByDates(),
                              child: EmptyContainer(
                                assetImage:
                                    'assets/images/modules/order-tracking.png',
                                text:
                                    'No hay Solicitudes de Pedido disponibles.\nToca para refrescar',
                              ),
                            )
                          : PurchaseRequestList(
                              documentLines: documentLines,
                              linesSelected: linesSelected)
                  : EmptyContainer(
                      assetImage: 'assets/images/icons/portrait.png',
                      text:
                          'Coloque el dispositivo en posición VERTICAL para una mejor experiencia.');
        },
      ),
    );
  }
}

class PurchaseRequestList extends StatelessWidget {
  const PurchaseRequestList({
    super.key,
    required this.documentLines,
    required this.linesSelected,
  });

  final List<DocumentLine>? documentLines;
  final List<int> linesSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView(
            children: documentLines!.map((line) {
              print('Line ${line.id}');
              return SelectablePurchaseRequestCard(
                isSelected: (linesSelected.contains(line.id)) ? true : false,
                documentLine: line,
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
          child: Row(
            children: [
              _RejectPurchaseRequestButton(),
              _ReleasePurchaseRequestButton(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReleasePurchaseRequestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final releasePurchaseRequestProvider =
        Provider.of<ReleasePurchaseRequestProvider>(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () =>
              _validateSelected(releasePurchaseRequestProvider, context),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(ThemeProvider.blueColor),
          ),
          child: Text(
            'Liberar',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: ThemeProvider.whiteColor),
          ),
        ),
      ),
    );
  }
}

class _RejectPurchaseRequestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final releasePurchaseRequestProvider =
        Provider.of<ReleasePurchaseRequestProvider>(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => _addRejectedMessage(
            releasePurchaseRequestProvider,
            context,
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(ThemeProvider.redColor),
          ),
          child: Text(
            'Rechazar',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: ThemeProvider.whiteColor),
          ),
        ),
      ),
    );
  }

  _addRejectedMessage(
      ReleasePurchaseRequestProvider releasePurchaseRequestProvider, context) {
    releasePurchaseRequestProvider.rejectionText = '';
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.sendWsLog('Liberar Compra - Presionó el boton Rechazar');

    if (releasePurchaseRequestProvider.linesSelected.isEmpty) {
      Notifications.showSnackBar(
          "No existen posiciones seleccionadas. Favor de validar.");
      socketService.sendWsLog(
          'W: No existen posiciones seleccionadas. Favor de validar.');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: releasePurchaseRequestProvider.formKey,
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Motivo de Rechazo",
              textAlign: TextAlign.center,
            ),
            content: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                color: ThemeProvider.blueColor,
                hintText: 'Describa el motivo del rechazo',
                labelText: 'Motivo de Rechazo',
                prefixIcon: FontAwesomeIcons.notEqual,
              ),
              onChanged: (value) =>
                  releasePurchaseRequestProvider.rejectionText = value,
              validator: (value) {
                return (value != null && value.length >= 3)
                    ? null
                    : 'Debe escribir al menos 3 caracteres.';
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (!releasePurchaseRequestProvider.isValidForm()) return;
                  final bool result =
                      await releasePurchaseRequestProvider.rejectSolpeds();
                  if (result) {
                    print('result $result');
                    releasePurchaseRequestProvider.searchByDates();

                    // Mapear cada elemento con su índice y ejecutar toMap
                    final newList = (releasePurchaseRequestProvider
                            .purchaseRequestRejected!.isNotEmpty)
                        ? releasePurchaseRequestProvider
                            .purchaseRequestRejected!
                            .map((obj) => obj.toMap())
                            .toList()
                        : [];

                    socketService.sendWsMessage(
                      'release-purchase-request',
                      'reject',
                      newList,
                      'Solicitudes de Pedido Rechazadas!',
                    );
                  }

                  Navigator.pop(context);
                },
                child: const Text(
                  "Confirmar Rechazar",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

_validateSelected(ReleasePurchaseRequestProvider releasePurchaseRequestProvider,
    BuildContext context) async {
  final socketService = Provider.of<SocketService>(context, listen: false);
  socketService.sendWsLog('Liberar Compra - Presionó el boton Liberar');

  if (releasePurchaseRequestProvider.linesSelected.isEmpty) {
    Notifications.showSnackBar(
        "No existen posiciones seleccionadas. Favor de validar.");
    socketService
        .sendWsLog('W: No existen posiciones seleccionadas. Favor de validar.');
    return;
  }

  if (await releasePurchaseRequestProvider.releaseSolpeds()) {
    releasePurchaseRequestProvider.searchByDates();

    // Mapear cada elemento con su índice y ejecutar toMap
    final newList =
        (releasePurchaseRequestProvider.purchaseRequestReleased!.isNotEmpty)
            ? releasePurchaseRequestProvider.purchaseRequestReleased!
                .map((obj) => obj.toMap())
                .toList()
            : [];

    socketService.sendWsMessage(
      'release-purchase-request',
      'release',
      newList,
      'Solicitudes de Pedido Aprobadas!',
    );
  }
}
