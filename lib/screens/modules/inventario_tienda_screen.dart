import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations_rounded.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';

class InventarioTiendaScreen extends StatelessWidget {
  static const String routeName = 'inventariotienda';

  const InventarioTiendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: InventarioTienda(),
    );
  }
}

class InventarioTienda extends StatefulWidget {
  const InventarioTienda({super.key});

  @override
  State<InventarioTienda> createState() => _InventarioTiendaState();
}

class _InventarioTiendaState extends State<InventarioTienda> {
  @override
  void initState() {
    super.initState();
    final inventarioTiendaProvider = context.read<InventarioTiendaProvider>();
    inventarioTiendaProvider.getCatalogs();
    inventarioTiendaProvider.inventarios = [];
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController rackController = TextEditingController();
    TextEditingController barCodeController = TextEditingController();

    return Consumer<InventarioTiendaProvider>(
      builder: (context, inventarioTiendaProvider, _) {
        return // Aquí colocas el contenido del screen cuando isLoading es false
            SearchInventario(
                barCodeController: barCodeController,
                rackController: rackController);
      },
    );
  }
}

class SearchInventario extends StatefulWidget {
  TextEditingController rackController;
  TextEditingController barCodeController;

  SearchInventario(
      {super.key,
      required this.barCodeController,
      required this.rackController});

  @override
  State<SearchInventario> createState() => _SearchInventarioState();
}

class _SearchInventarioState extends State<SearchInventario> {

  Future<void> scanQR(
      InventarioTiendaProvider inventarioProvider, barCodeController) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#115c99', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    print(barcodeScanRes);

    inventarioProvider.barCode = barcodeScanRes;
    setState(() {
      barCodeController.text = (barcodeScanRes != '-1') ? barcodeScanRes : '';
      inventarioProvider.validateBarcode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final inventarioTiendaProvider =
        Provider.of<InventarioTiendaProvider>(context);

        setState(() {
      widget.barCodeController.text = inventarioTiendaProvider.barCode;
      widget.rackController.text = inventarioTiendaProvider.rack;
      
    });

    print(
        'inventarioTiendaProvider.inventarios: ${inventarioTiendaProvider.inventarios}');
    return (inventarioTiendaProvider.isLoadingCatalogs)
        ? Center(
            child: SpinKitCubeGrid(
              color: ThemeProvider.blueColor,
            ),
          )
        : (inventarioTiendaProvider.inventarios!.isEmpty)
            ? Column(
                children: [
                  Container(
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
                    child: _SearchInventory(
                        inventarioTiendaProvider: inventarioTiendaProvider),
                  ),
                ],
              )
            : (inventarioTiendaProvider.materialContado.material != null)
                ? ConteoCiegoForm(
                    inventarioTiendaProvider: inventarioTiendaProvider,
                    rackController: widget.rackController,
                    barCodeController: widget.barCodeController)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Form(
                            key: inventarioTiendaProvider.formKey,
                            child: Column(
                              children: [
                                const Text(
                                  'Iniciar Conteo Ciego',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  maxLength: 10,
                                  controller: widget.rackController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.characters,
                                  decoration: InputDecorationsRounded
                                      .authInputDecorationRounded(
                                          hintText: 'Mueble',
                                          labelText: 'Mueble',
                                          color: ThemeProvider.blueColor,
                                          suffixIcon:
                                              FontAwesomeIcons.boxesStacked),
                                  onChanged: (value) {
                                    print('value Mueble $value');
                                    inventarioTiendaProvider.rack = value;
                                  },
                                  validator: (value) {
                                    print('valueMueble $value');
                                    return (value != null && value.isNotEmpty)
                                        ? null
                                        : 'Captura el mueble';
                                  },
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  // readOnly: true,
                                  // maxLength: 20,
                                  controller: widget.barCodeController,
                                  autofocus: (inventarioTiendaProvider.rack != '') ? true:false,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecorationsRounded
                                      .authInputDecorationRounded(
                                    hintText: 'Captura Código...',
                                    labelText: 'Código de Barra',
                                    suffixIcon: FontAwesomeIcons.barcode,
                                    color: ThemeProvider.blueColor,
                                  ),
                                  //TODO: comentar onChanged y descomentar OnTap
                                  onTap: () => scanQR(inventarioTiendaProvider,
                                      widget.barCodeController),
                                  // onChanged: (value) {
                                  //   inventarioTiendaProvider.barCode = value;
                                  //   inventarioTiendaProvider.validateBarcode();
                                  // },
                                  validator: (value) {
                                    print('valueBarcode $value');
                                    return (value != null)
                                        ? null
                                        : 'Agrega el Código de Barra';
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
  }
}

class _SearchInventory extends StatelessWidget {
  const _SearchInventory({
    super.key,
    required this.inventarioTiendaProvider,
  });

  final InventarioTiendaProvider inventarioTiendaProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CentrosUsuarioDrop(
              provider: inventarioTiendaProvider,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InventarioDatePicker(),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SearchInventoryBtn(inventarioTiendaProvider: inventarioTiendaProvider),
      ],
    );
  }
}

class SearchInventoryBtn extends StatelessWidget {
  const SearchInventoryBtn({
    super.key,
    required this.inventarioTiendaProvider,
  });

  final InventarioTiendaProvider inventarioTiendaProvider;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: (inventarioTiendaProvider.isLoadingCatalogs ||
              inventarioTiendaProvider.centrosUsuario!.isEmpty)
          ? null
          : () async {
              // if (!inventarioTiendaProvider.isValidForm()) return;
              FocusScope.of(context).unfocus();

              //hacer la peticion al backend
              final result =
                  await inventarioTiendaProvider.searchInventory();
              print('Result $result');
            },
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      disabledColor: ThemeProvider.blueColor.withAlpha(150),
      elevation: 0,
      color: ThemeProvider.blueColor,
      minWidth: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: inventarioTiendaProvider.isLoadingCatalogs
            ? const CupertinoActivityIndicator()
            : const Text(
                'Buscar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
      ),
    );
  }
}

class InventarioDatePicker extends StatefulWidget {
  InventarioDatePicker({super.key});

  @override
  State<InventarioDatePicker> createState() => _InventarioDatePickerState();
}

class _InventarioDatePickerState extends State<InventarioDatePicker> {
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final inventarioTiendaProvider =
        Provider.of<InventarioTiendaProvider>(context);
    final DateTime now = DateTime.now();
    dateController.text = inventarioTiendaProvider.fecha;

    return TextFormField(
      controller: dateController,
      readOnly: true,
      decoration: InputDecorationsRounded.authInputDecorationRounded(
        hintText: 'Fecha',
        labelText: 'Fecha',
        color: ThemeProvider.blueColor,
      ),
      textAlign: TextAlign.center,
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          locale: const Locale('es'),
          context: context,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: now,
          firstDate: DateTime(now.year, 1, 1),
          lastDate: DateTime(now.year, 12, 31),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: ThemeProvider
                          .blueColor, // Cambia el color primario al azul
                      onPrimary: Colors
                          .white, // Cambia el color del texto sobre el color primario
                    ),
                buttonTheme: const ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
              ),
              child: child!,
            );
          },
        );

        if (selectedDate == null) {
          return; // Si se cancela la selección
        }

        var formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        dateController.text = formattedDate;
        print('Selected Date: $formattedDate');
        inventarioTiendaProvider.fecha = formattedDate;
        setState(() {});
      },
    );
  }
}

class ConteoCiegoForm extends StatefulWidget {
  InventarioTiendaProvider inventarioTiendaProvider;
  TextEditingController rackController;
  TextEditingController barCodeController;

  ConteoCiegoForm(
      {super.key,
      required this.inventarioTiendaProvider,
      required this.rackController,
      required this.barCodeController});

  @override
  State<ConteoCiegoForm> createState() => _ConteoCiegoFormState();
}

class _ConteoCiegoFormState extends State<ConteoCiegoForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: widget.inventarioTiendaProvider.formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Iniciar Conteo Ciego',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          resetBlindCounting(widget.inventarioTiendaProvider);
                          setState(() {
                            // widget.rackController.text = '';
                            widget.barCodeController.text = '';
                          });
                        },
                        icon: const Icon(FontAwesomeIcons.arrowsRotate),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    initialValue: widget
                        .inventarioTiendaProvider.materialContado.material,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    decoration:
                        InputDecorationsRounded.authInputDecorationRounded(
                      hintText: '',
                      labelText: 'Material',
                      color: ThemeProvider.blueColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    readOnly: true,
                    initialValue: widget
                        .inventarioTiendaProvider.materialContado.descripcion,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration:
                        InputDecorationsRounded.authInputDecorationRounded(
                      hintText: '',
                      labelText: 'Descripción',
                      color: ThemeProvider.blueColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      (widget.inventarioTiendaProvider.materialContado
                                  .umeComercial !=
                              null)
                          ? Expanded(
                              child: TextFormField(
                                readOnly: true,
                                textAlign: TextAlign.center,
                                initialValue: widget.inventarioTiendaProvider
                                    .materialContado.umeComercial,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecorationsRounded
                                    .authInputDecorationRounded(
                                  hintText: '',
                                  labelText: 'UM',
                                  color: ThemeProvider.blueColor,
                                ),
                              ),
                            )
                          : Container(),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          textAlign: TextAlign.center,
                          initialValue: widget.inventarioTiendaProvider.rack,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecorationsRounded
                              .authInputDecorationRounded(
                            hintText: '',
                            labelText: 'Mueble',
                            color: ThemeProvider.blueColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          initialValue:
                              '${widget.inventarioTiendaProvider.materialContado.cantidad}',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]')),
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              final text = newValue.text;

                              return text.isEmpty
                                  ? newValue
                                  : (double.tryParse(text) == null ||
                                          (!RegExp(r'^\d*\.?\d{0,3}$')
                                              .hasMatch(newValue.text)))
                                      ? oldValue
                                      : newValue;
                            }),
                          ],
                          validator: (value) {
                            return (value != null && value.isNotEmpty)
                                ? null
                                : 'Agrega Cant.';
                          },
                          onChanged: (value) {
                            print(value);
                            widget.inventarioTiendaProvider.materialContado
                                .cantidad = double.tryParse(value) ?? 0.0;
                          },
                          decoration: InputDecorationsRounded
                              .authInputDecorationRounded(
                            hintText: '',
                            labelText: 'Cant. Contada',
                            color: ThemeProvider.blueColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ConteoCiegoButtons(
                      inventarioTiendaProvider:
                          widget.inventarioTiendaProvider, rackController: widget.rackController, barCodeController: widget.barCodeController),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

}

class ConteoCiegoButtons extends StatefulWidget {
  final InventarioTiendaProvider inventarioTiendaProvider;
  final TextEditingController rackController;
  final TextEditingController barCodeController;

  const ConteoCiegoButtons({super.key, required this.inventarioTiendaProvider, required this.barCodeController, required this.rackController});

  @override
  State<ConteoCiegoButtons> createState() => _ConteoCiegoButtonsState();
}

class _ConteoCiegoButtonsState extends State<ConteoCiegoButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MaterialButton(
            onPressed: (widget.inventarioTiendaProvider.isLoadingCatalogs)
                ? null
                : () async {
                    // if (!widget.inventarioTiendaProvider.isValidForm()) return;
                    FocusScope.of(context).unfocus();
                    //hacer la peticion al backend
                    print('Finalizar Conteo!!');
                  },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: ThemeProvider.blueColor.withAlpha(150),
            elevation: 0,
            color: ThemeProvider.tealColor,
            minWidth: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: widget.inventarioTiendaProvider.isLoadingCatalogs
                  ? const CupertinoActivityIndicator()
                  : const Text(
                      'Finalizar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: MaterialButton(
            onPressed: (widget.inventarioTiendaProvider.isSaving)
                ? null
                : () async {
                    if (!widget.inventarioTiendaProvider.isValidForm()) return;
                    FocusScope.of(context).unfocus();
                    //hacer la peticion al backend
                    print('Guardar Conteo!!');
                    print(widget.inventarioTiendaProvider.materialContado.toJson());
                    final result =
                        await widget.inventarioTiendaProvider.saveCounting();
                    print('Result $result');
                    if(result) {
                      resetBlindCounting(widget.inventarioTiendaProvider);
                      setState(() {
                        // widget.rackController.text = '';
                        widget.barCodeController.text = '';
                      });
                    };
                  },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: ThemeProvider.blueColor.withAlpha(150),
            elevation: 0,
            color: ThemeProvider.blueColor,
            minWidth: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: widget.inventarioTiendaProvider.isSaving
                  ? const CupertinoActivityIndicator()
                  : const Text(
                      'Guardar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

void resetBlindCounting(InventarioTiendaProvider inventarioTiendaProvider) {
  inventarioTiendaProvider.materialContado = IMdetalle();
  inventarioTiendaProvider.material = '';
  // inventarioTiendaProvider.rack = '';
  inventarioTiendaProvider.barCode = '';
}