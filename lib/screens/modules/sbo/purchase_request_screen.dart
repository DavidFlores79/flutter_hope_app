import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/search/sbo/main_item_search_delegate.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations_rounded.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/widgets/empty_container.dart';
import 'package:hope_app/widgets/status_label.dart';
import 'package:provider/provider.dart';

class PurchaseRequestScreen extends StatelessWidget {
  static const String routeName = 'sbo-solped';

  const PurchaseRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PurchaseRequest(),
    );
  }
}

class PurchaseRequest extends StatefulWidget {
  const PurchaseRequest({super.key});

  @override
  State<PurchaseRequest> createState() => _PurchaseRequestState();
}

class _PurchaseRequestState extends State<PurchaseRequest> {
  @override
  void initState() {
    super.initState();
    final purchaseRequestProvider = context.read<PurchaseRequestProvider>();
    purchaseRequestProvider.getCatalogs();
  }

  listenWSMessages(
      dynamic data, PurchaseRequestProvider purchaseRequestProvider) {
    final WebsocketMessage message = WebsocketMessage.fromMap(data);
    // print('WS: ${message.type} ${message.data!.id}');
    switch (message.type) {
      case 'store':
        print('WS: ${message.type} ${message.data!.id}');
        purchaseRequestProvider.addDocumentLine(message.data!);
        break;
      case 'update':
        print('WS: ${message.type} ${message.data!.id}');
        purchaseRequestProvider.updateDocumentLine(message.data!);
        break;
      case 'delete':
        print('WS: ${message.type} ${message.data!.id}');
        purchaseRequestProvider.removeDocumentLine(message.data!);
        break;
      default:
    }
  }

  listenWSReleaseMessages(
    dynamic data,
    PurchaseRequestProvider purchaseRequestProvider,
  ) {
    // print('Purchase Release or Reject $data');
    try {
      final List<DocumentLine> lines =
          (data['data'] as List<dynamic>).map((obj) {
        return DocumentLine.fromMap(obj as Map<String, dynamic>);
      }).toList();

      switch (data['type']) {
        case 'release':
          print('WS Release: ${data['type']} ${data['data']}');
          purchaseRequestProvider.removeDocumentLines(lines);
          break;
        case 'reject':
          print('WS Reject: ${data['type']} ${data['data']}');
          purchaseRequestProvider.updateDocumentLines(lines);
          break;
        default:
      }
    } catch (e) {
      Notifications.showSnackBar('Error WS Purchase Request: $e');
    }
  }

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    final purchaseRequestProvider =
        Provider.of<PurchaseRequestProvider>(context);
    final itemProvider = Provider.of<SBOItemProvider>(context);
    final documentLines = purchaseRequestProvider.documentLines;
    final orientation = MediaQuery.of(context).orientation;

    socketService.socket.on(
        'purchase-request',
        (data) => listenWSMessages(
              data,
              purchaseRequestProvider,
            ));

    socketService.socket.on(
        'release-purchase-request',
        (data) => listenWSReleaseMessages(
              data,
              purchaseRequestProvider,
            ));

    return RefreshIndicator(
      onRefresh: () => purchaseRequestProvider.getCatalogs(),
      child: Consumer<PurchaseRequestProvider>(
        builder: (context, purchaseRequestProvider, _) {
          // socketService.checkConnection();

          return (purchaseRequestProvider.isLoading)
              ? Center(
                  child: SpinKitCubeGrid(
                    color: ThemeProvider.blueColor,
                  ),
                )
              : // Aquí colocas el contenido del screen cuando isLoading es false
              (orientation == Orientation.portrait ||
                      Preferences.deviceModel == 'iPad' ||
                      Preferences.deviceModel == 'Tablet')
                  ? Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: (Preferences.isDarkMode)
                                ? ThemeProvider.lightColor
                                : ThemeProvider.whiteColor,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.only(top: 20, bottom: 5),
                          child: Form(
                              key: purchaseRequestProvider.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    readOnly: true,
                                    controller: _searchController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecorationsRounded
                                        .authInputDecorationRounded(
                                      color: (Preferences.isDarkMode)
                                          ? ThemeProvider.whiteColor
                                          : ThemeProvider.blueColor,
                                      hintText: '904001526',
                                      labelText: 'Material',
                                      suffixIcon:
                                          FontAwesomeIcons.magnifyingGlass,
                                    ),
                                    onTap: () async {
                                      await showSearch(
                                        context: context,
                                        delegate: MainItemSearchDelegate(
                                          'purchase-request',
                                        ),
                                      );

                                      final itemCode =
                                          itemProvider.itemSelected.itemCode;
                                      final isProductionItem = itemProvider
                                          .itemSelected.inCostRollup;
                                      print(
                                          'Artículo es Producción? $isProductionItem');

                                      // if (itemCode != '' && isProductionItem != 'tYES') {
                                      if (itemCode != '') {
                                        _searchController.text =
                                            purchaseRequestProvider
                                                    .itemSelected.itemCode ??
                                                '';
                                        if (isProductionItem == 'tYES') {
                                          Notifications.showSnackBar(
                                              'Artículo ${purchaseRequestProvider.itemSelected.itemCode} inválido.');
                                        }
                                      } else {
                                        _searchController.clear();
                                      }
                                    },
                                    validator: (value) {
                                      return (value != null &&
                                              value.length >= 3)
                                          ? null
                                          : 'Por favor agrega un artículo para crear la solicitud.';
                                    },
                                  ),
                                  (purchaseRequestProvider
                                              .itemSelected.itemName ==
                                          null)
                                      ? Container()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Descripción: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '${purchaseRequestProvider.itemSelected.itemName}',
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'UME: ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${purchaseRequestProvider.itemSelected.inventoryUOM}',
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'Centro: ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(purchaseRequestProvider
                                                        .defaultWarehouse),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'Producción: ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                        '${purchaseRequestProvider.itemSelected.inCostRollup}'),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            TextFormField(
                                              textAlign: TextAlign.center,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: _qtyController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                if (purchaseRequestProvider
                                                            .itemSelected
                                                            .inventoryUOM ==
                                                        'PZA' ||
                                                    purchaseRequestProvider
                                                            .itemSelected
                                                            .inventoryUOM ==
                                                        'Pieza')
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                else
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9.]')),
                                                TextInputFormatter.withFunction(
                                                    (oldValue, newValue) {
                                                  final text = newValue.text;
                                                  return text.isEmpty
                                                      ? newValue
                                                      : double.tryParse(text) ==
                                                              null
                                                          ? oldValue
                                                          : newValue;
                                                }),
                                              ],
                                              validator: (value) {
                                                return (value != null &&
                                                        value.isNotEmpty)
                                                    ? null
                                                    : 'Por favor agrega la cantidad.';
                                              },
                                              onChanged: (value) {
                                                print(value);
                                                purchaseRequestProvider
                                                    .quantity = value;
                                              },
                                              decoration: InputDecorationsRounded
                                                  .authInputDecorationRounded(
                                                color: (Preferences.isDarkMode)
                                                    ? ThemeProvider.whiteColor
                                                    : ThemeProvider.blueColor,
                                                hintText: '0',
                                                labelText: 'Cantidad',
                                                suffixIcon: FontAwesomeIcons
                                                    .cartArrowDown,
                                              ),
                                            ),
                                          ],
                                        ),
                                  const SizedBox(height: 15),
                                  MaterialButton(
                                    onPressed: (purchaseRequestProvider
                                            .isLoading)
                                        ? null
                                        : () async {
                                            socketService.sendWsLog(
                                                'Solicitud de Compra - Presionó el boton Guardar.');
                                            if (!purchaseRequestProvider
                                                .isValidForm()) return;
                                            purchaseRequestProvider.isLoading =
                                                true;
                                            FocusScope.of(context).unfocus();

                                            //hacer la peticion al backend
                                            final result =
                                                await purchaseRequestProvider
                                                    .createSolped();

                                            print('Result $result');
                                            if (result) {
                                              socketService.sendWsMessage(
                                                'purchase-request',
                                                'store',
                                                purchaseRequestProvider
                                                    .newDocumentLine,
                                              );
                                              setState(() {
                                                purchaseRequestProvider
                                                    .formKey.currentState
                                                    ?.reset();
                                                itemProvider.itemSelected =
                                                    SBO_Item();
                                                purchaseRequestProvider
                                                    .itemSelected = SBO_Item();
                                                _searchController.clear();
                                                _qtyController.clear();
                                              });
                                              // purchaseRequestProvider.getSolpeds();
                                              Notifications.showSnackBar(
                                                  'Pedido creado correctamente.');
                                            }

                                            purchaseRequestProvider.isLoading =
                                                false;
                                          },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    disabledColor: Colors.grey,
                                    elevation: 0,
                                    color: ThemeProvider.blueColor,
                                    minWidth: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: Text(
                                        purchaseRequestProvider.isLoading
                                            ? 'Espere'
                                            : 'Crear Pedido',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  (itemProvider.itemSelected.itemName == null)
                                      ? const Column(
                                          children: [
                                            SizedBox(height: 15),
                                            Text(
                                              'Para crear una Solicitud de Compra seleccione el artículo y agregue la cantidad que desea pedir.',
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 15),
                                          ],
                                        )
                                      : Container(),
                                ],
                              )),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: documentLines?.length,
                              itemBuilder: (context, index) {
                                final documentLine = documentLines![index];

                                return Dismissible(
                                  key: UniqueKey(),
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 25),
                                    child: const FaIcon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.white,
                                    ),
                                  ),
                                  direction: DismissDirection.startToEnd,
                                  confirmDismiss:
                                      (DismissDirection direction) async {
                                    return await confirmarEliminar(context,
                                        purchaseRequestProvider, documentLine);
                                  },
                                  onDismissed: (DismissDirection direction) {
                                    print('Eliminado Index ******* ${index}');
                                    purchaseRequestProvider.documentLines!
                                        .removeAt(index);
                                  },
                                  child:
                                      PurchaseRequestCard(line: documentLine),
                                );
                              }),
                        ),
                      ],
                    )
                  : EmptyContainer(
                      assetImage: 'assets/images/icons/portrait.png',
                      text:
                          'Coloque el dispositivo en posición VERTICAL para una mejor experiencia.');
        },
      ),
    );
  }

  confirmarEliminar(BuildContext context, purchaseRequestProvider,
      DocumentLine documentLine) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    // print('Eliminar ${documentLine.id} ??');
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Eliminar Pedido",
            textAlign: TextAlign.center,
          ),
          content: Padding(
            padding: const EdgeInsets.all(5.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(
                      fontSize: 15,
                      color:
                          Preferences.isDarkMode ? Colors.white : Colors.black),
                  text: "¿Quieres eliminar el pedido del material ",
                  children: [
                    TextSpan(
                      text: '${documentLine.itemCode}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: '\n\nUna vez eliminado no podrá recuperarse.',
                    ),
                  ]),
            ),
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
                socketService.sendWsLog(
                    'Solicitud de Compra - Presionó el boton Eliminar.');
                print('Eliminar! ${documentLine.id}');
                final result = await purchaseRequestProvider
                    .deleteSolped(documentLine.id!);
                print('Eliminado! $result');
                if (result) {
                  socketService.sendWsMessage(
                    'purchase-request',
                    'delete',
                    purchaseRequestProvider.newDocumentLine,
                    'Registro eliminado!',
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Confirmar Eliminar",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PurchaseRequestCard extends StatelessWidget {
  final DocumentLine line;
  const PurchaseRequestCard({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    final fechaSolicitud = Preferences.formatDate(line.requestedAt!);

    return GestureDetector(
      onTap: () => editPurchaseRequest(context, line),
      child: Card(
        elevation: 3,
        child: ListTile(
          tileColor: (line.modified != null && line.modified != false)
              ? Colors.blue.shade400
              : Colors.transparent,
          minVerticalPadding: 20,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                line.itemCode!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Cant. ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${line.quantity}'),
                ],
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(line.itemDescription!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Almacén: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${line.warehouseCode}'),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Creador: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${line.createdBy}'),
                    ],
                  ),
                  StatusLabel(
                    status: line.status ?? Estatus(),
                    color: (line.status != null && line.status!.id != 1)
                        ? Colors.red
                        : Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'F. Solicitud: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(fechaSolicitud),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

editPurchaseRequest(context, DocumentLine line) {
  final purchaseRequestProvider =
      Provider.of<PurchaseRequestProvider>(context, listen: false);
  final socketService = Provider.of<SocketService>(context, listen: false);
  purchaseRequestProvider.quantity = '';

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text(
          "Editar Solicitud",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        content: UpdateContent(
          line: line,
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
              socketService.sendWsLog(
                  'Solicitud de Compra - Presionó el boton Actualizar');
              Future.microtask(
                () => Navigator.pop(context),
              );
              final result = await purchaseRequestProvider.updateSolped(line);
              if (result) {
                socketService.sendWsMessage(
                    'purchase-request',
                    'update',
                    purchaseRequestProvider.newDocumentLine,
                    'Registro actualizado!');
                Notifications.showSnackBar(
                  // purchaseRequestProvider.purchaseRequestResponse!.message ??
                  'Pedido de Compra Actualizado',
                );
              }
            },
            child: const Text(
              "Actualizar",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      );
    },
  );
}

class UpdateContent extends StatelessWidget {
  final DocumentLine line;
  const UpdateContent({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    final purchaseRequestProvider =
        Provider.of<PurchaseRequestProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Material: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${line.itemCode}',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Descripción: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${line.itemDescription}',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'UM: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${line.inventoryUom}',
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Centro: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${line.warehouseCode}'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Creador: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${line.createdBy}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 35),
            TextFormField(
              textAlign: TextAlign.center,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: double.parse(line.quantity!).toString(),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                if (line.inventoryUom == 'PZA' || line.inventoryUom == 'Pieza')
                  FilteringTextInputFormatter.digitsOnly
                else
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final text = newValue.text;
                  return text.isEmpty
                      ? newValue
                      : double.tryParse(text) == null
                          ? oldValue
                          : newValue;
                }),
                // FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                // TextInputFormatter.withFunction((oldValue, newValue) {
                //   final text = newValue.text;
                //   return text.isEmpty
                //       ? newValue
                //       : double.tryParse(text) == null
                //           ? oldValue
                //           : newValue;
                // }),
              ],
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Por favor agrega la cantidad.';
              },
              onChanged: (value) {
                print(value);
                purchaseRequestProvider.quantity = value;
              },
              decoration: InputDecorationsRounded.authInputDecorationRounded(
                color: ThemeProvider.blueColor,
                hintText: '0',
                labelText: 'Cantidad',
                suffixIcon: FontAwesomeIcons.cartArrowDown,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
