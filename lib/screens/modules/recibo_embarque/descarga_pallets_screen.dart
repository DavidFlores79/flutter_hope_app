import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations_rounded.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DescargaPalletsScreen extends StatefulWidget {
  static const String routeName = 'descarga-pallets';

  const DescargaPalletsScreen({super.key});

  @override
  State<DescargaPalletsScreen> createState() => _DescargaPalletsScreenState();
}

class _DescargaPalletsScreenState extends State<DescargaPalletsScreen> {
  String _scanBarcode = '';
  TextEditingController _barCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _barCodeController.text = _scanBarcode;
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR(ReciboEmbarqueProvider reciboEmbarqueProvider, barCodeController) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() async {
      _scanBarcode = barcodeScanRes;
      reciboEmbarqueProvider.palletCaptured = barcodeScanRes;
      final result = await reciboEmbarqueProvider.isPalletCapturedValid();
      print('Result $result');
      if(result) {
        reciboEmbarqueProvider.palletCaptured = '';
        reciboEmbarqueProvider.embarqueSelected = reciboEmbarqueProvider.reciboEmbarqueResponse!.dato!;
        setState(() {
          barCodeController.text = '';
        });
      }
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reciboEmbarqueProvider = Provider.of<ReciboEmbarqueProvider>(context);
    // reciboEmbarqueProvider.embarqueSelected = ModalRoute.of(context)!.settings.arguments as Embarque;
    final List<Pallet> palletsDescargados =
        reciboEmbarqueProvider.embarqueSelected.pallets!;

    print('Embarque ID ${reciboEmbarqueProvider.embarqueSelected.id}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Descarga de Pallets'),
        centerTitle: true,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CardItemLabelValue(label: 'ID: ', value: '${reciboEmbarqueProvider.embarqueSelected.id}'),
                CardItemLabelValue(
                    label: 'Entrega: ', value: '${reciboEmbarqueProvider.embarqueSelected.entrega}'),
                CardItemLabelValue(
                    label: 'Ingresados: ',
                    value:
                        '${reciboEmbarqueProvider.embarqueSelected.pallets!.where((pallet) => pallet.estatus == 'DESCARGADO').length}'),
                CardItemLabelValue(
                    label: 'Restantes: ',
                    value:
                        '${reciboEmbarqueProvider.embarqueSelected.pallets!.where((pallet) => pallet.estatus != 'DESCARGADO').length}'),
                CardItemLabelValue(
                    label: 'Peso Total: ',
                    value: reciboEmbarqueProvider.embarqueSelected.pallets!
                        .where((pallet) => pallet.estatus == 'DESCARGADO')
                        .fold(0.0, (prev, pallet) => prev + pallet.peso!)
                        .toStringAsFixed(3)),
                CardItemLabelValue(
                    label: 'Volumen Total: ',
                    value: reciboEmbarqueProvider.embarqueSelected.pallets!
                        .where((pallet) => pallet.estatus == 'DESCARGADO')
                        .fold(0.0, (prev, pallet) => prev + pallet.volumen!)
                        .toStringAsFixed(3)),
              ],
            ),
          ),
          AddPalletForm(barCodeController: _barCodeController),
          PalletList(
            pallets: palletsDescargados
                .where((pallet) => pallet.estatus == 'DESCARGADO')
                .toList(),
          ),
          // Text(
          //   'Scan result : $_scanBarcode\n',
          //   style: const TextStyle(fontSize: 20),
          // ),
          ConfirmButton(reciboEmbarqueProvider: reciboEmbarqueProvider),
          const SizedBox(height: 25),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (reciboEmbarqueProvider.embarqueSelected.pallets!.where((pallet) => pallet.estatus != 'DESCARGADO').isNotEmpty) ? () => scanQR(reciboEmbarqueProvider, _barCodeController) : null,
        child: const Icon(FontAwesomeIcons.barcode),
      ),
      bottomNavigationBar: BottomAppBar(
          color: ThemeProvider.lightColor,
          shape: const CircularNotchedRectangle(),
          child: const SizedBox(
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[],
            ),
          )),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    super.key,
    required this.reciboEmbarqueProvider,
  });

  final ReciboEmbarqueProvider reciboEmbarqueProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: (Preferences.isDarkMode)
            ? ThemeProvider.lightColor
            : ThemeProvider.whiteColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0, -4),
          )
        ],
      ),
      child: MaterialButton(
        onPressed: (reciboEmbarqueProvider.embarqueSelected.pallets!
                        .where(
                          (pallet) => pallet.estatus == 'DESCARGADO',
                        )
                        .length !=
                    reciboEmbarqueProvider.embarqueSelected.pallets!.length ||
                reciboEmbarqueProvider.isLoading)
            ? null
            : () async {
                FocusScope.of(context).unfocus();
                reciboEmbarqueProvider.embarqueSelected.horaFinalizacion =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                //hacer la peticion al backend
                final result =
                    await reciboEmbarqueProvider.contabilizarEmbarque();
                if (result) {
                  Future.delayed(const Duration(milliseconds: 600), () {
                    reciboEmbarqueProvider.searchEmbarques();
                  });
                  Future.microtask(() => Navigator.pop(context));
                }
                print('Result $result');
              },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: ThemeProvider.blueColor.withAlpha(150),
        elevation: 0,
        color: ThemeProvider.blueColor,
        minWidth: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: reciboEmbarqueProvider.isLoading
              ? const CupertinoActivityIndicator()
              : const Text(
                  'Confirmar Surtido',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    );
  }
}

class AddPalletForm extends StatefulWidget {
  final TextEditingController barCodeController;

  const AddPalletForm({super.key, required this.barCodeController});

  @override
  State<AddPalletForm> createState() => _AddPalletFormState();
}

class _AddPalletFormState extends State<AddPalletForm> {
  @override
  Widget build(BuildContext context) {
    final reciboEmbarqueProvider = Provider.of<ReciboEmbarqueProvider>(context);

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 15,
        vertical: 20,
      ),
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
      child: Form(
        key: reciboEmbarqueProvider.formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    // readOnly: true,
                    maxLength: 20,
                    controller: widget.barCodeController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration:
                        InputDecorationsRounded.authInputDecorationRounded(
                      hintText: 'Escribe y Captura Código...',
                      labelText: 'Código de Barra',
                      color: ThemeProvider.blueColor,
                    ),
                    onChanged: (value) =>
                        reciboEmbarqueProvider.palletCaptured = value,
                    onTap: () async {},
                    validator: (value) {
                      print('value $value');
                      return (value != null)
                          ? null
                          : 'Agrega el Código de Barra';
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: MaterialButton(
                      onPressed: (reciboEmbarqueProvider
                                  .embarqueSelected.pallets!
                                  .where(
                                    (pallet) => pallet.estatus == 'DESCARGADO',
                                  )
                                  .length ==
                              reciboEmbarqueProvider
                                  .embarqueSelected.pallets!.length)
                          ? null
                          : () async {
                              if (!reciboEmbarqueProvider.isValidForm()) return;
                              FocusScope.of(context).unfocus();

                              //hacer la peticion al backend
                              // final result = await reciboEmbarqueProvider.agregarPallet();
                              final result = await reciboEmbarqueProvider.isPalletCapturedValid();
                              print('Result $result');
                              if(result) {
                                reciboEmbarqueProvider.palletCaptured = '';
                                reciboEmbarqueProvider.embarqueSelected = reciboEmbarqueProvider.reciboEmbarqueResponse!.dato!;
                                setState(() {
                                  widget.barCodeController.text = '';
                                });
                              }
                            },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      disabledColor: ThemeProvider.blueColor.withAlpha(150),
                      elevation: 0,
                      color: ThemeProvider.blueColor,
                      minWidth: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: reciboEmbarqueProvider.isLoading
                            ? const CupertinoActivityIndicator()
                            : Icon(
                                FontAwesomeIcons.floppyDisk,
                                color: ThemeProvider.whiteColor,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PalletList extends StatelessWidget {
  final List<Pallet> pallets;

  const PalletList({super.key, required this.pallets});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: pallets.length,
        itemBuilder: (context, index) {
          final pallet = pallets[index];
          return ListTile(
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  CardItemLabelValue(
                      label: 'Pallet: ', value: '${pallet.numeroContenedor}'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CardItemLabelValue(
                          label: 'Peso: ', value: '${pallet.peso}'),
                      CardItemLabelValue(
                          label: 'Volumen: ', value: '${pallet.volumen}'),
                    ],
                  ),
                ],
              ),
            ),
            subtitle: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CardItemLabelValue(
                  label: 'Estatus: ', value: '${pallet.estatus}'),
            ),
            // Agrega más detalles según tus necesidades
          );
        },
      ),
    );
    ;
  }
}
