import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/search/transfers_material_search_delegate.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations_rounded.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class TransferenciasInternasScreen extends StatelessWidget {
  static String routeName = 'transferenciasinternas';

  const TransferenciasInternasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      // TODO: Configurar el screen para Tablet, mostrar inputs en horizontal
      body: (orientation == Orientation.landscape && Preferences.deviceModel != 'iPad')
          ? EmptyContainer(
              assetImage: 'assets/images/icons/portrait.png',
              text:
                  'Coloque el dispositivo en posición VERTICAL para una mejor experiencia.')
          : const TransferenciasInternas(),
    );
  }
}

class TransferenciasInternas extends StatefulWidget {
  const TransferenciasInternas({super.key});

  @override
  State<TransferenciasInternas> createState() => _TransferenciasInternasState();
}

class _TransferenciasInternasState extends State<TransferenciasInternas> {
  @override
  void initState() {
    super.initState();
    final transferenciasInternasProvider =
        context.read<TransferenciaInternaProvider>();
    transferenciasInternasProvider.getCatalogs();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchControllerFrom = TextEditingController();
    TextEditingController searchControllerTo = TextEditingController();

    return Consumer<TransferenciaInternaProvider>(
      builder: (context, transferenciasInternasProvider, _) {
        return (transferenciasInternasProvider.isLoadingCatalogs)
            ? Center(
                child: SpinKitCubeGrid(
                  color: ThemeProvider.blueColor,
                ),
              )
            : // Aquí colocas el contenido del screen cuando isLoading es false
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  children: [
                    Form(
                      key: transferenciasInternasProvider.formKey,
                      child: Column(
                        children: [
                          ItemLabelValue(
                              label: 'Referencia: ',
                              value: transferenciasInternasProvider.referencia),
                          const SizedBox(height: 15),
                          SearchMaterialFrom(
                              searchController: searchControllerFrom),
                          const SizedBox(height: 10),
                          if (transferenciasInternasProvider
                                  .materialSelectedFrom.numeroMaterial !=
                              null)
                            MaterialDescription(
                              material: transferenciasInternasProvider
                                  .materialSelectedFrom,
                            ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Expanded(child: _QuantityFrom()),
                              const SizedBox(
                                width: 15,
                              ),
                              _orgComprasFrom(
                                  orgComprasFrom: transferenciasInternasProvider
                                      .orgComprasFrom)
                            ],
                          ),
                          Divider(
                            height: 50.0,
                            thickness: 2.0,
                            color: ThemeProvider.lightColor,
                          ),
                          SearchMaterialTo(
                              searchController: searchControllerTo),
                          const SizedBox(height: 10),
                          if (transferenciasInternasProvider
                                  .materialSelectedTo.numeroMaterial !=
                              null)
                            MaterialDescription(
                              material: transferenciasInternasProvider
                                  .materialSelectedTo,
                            ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Expanded(child: _QuantityTo()),
                              const SizedBox(
                                width: 15,
                              ),
                              _OrgComprasDropdown(
                                transferenciasInternasProvider:
                                    transferenciasInternasProvider,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          AddTransferBtn(
                            transferenciasInternasProvider:
                                transferenciasInternasProvider,
                            searchControllerFrom: searchControllerFrom,
                            searchControllerTo: searchControllerTo,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: transferenciasInternasProvider
                                  .transferencias.isEmpty
                              ? null
                              : () {
                                  Navigator.pushNamed(
                                      context, ShowTransfersScreen.routeName);
                                },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          disabledColor: ThemeProvider.darkColor.withAlpha(150),
                          elevation: 0,
                          color: ThemeProvider.darkColor,
                          // minWidth: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: Text(
                              'Mostrar ${transferenciasInternasProvider.transferencias.length} Transferencia(s)',
                              style: TextStyle(color: ThemeProvider.whiteColor),
                            ),
                          ),
                        )
                      ],
                    )),
                    SubmitTransfersButton(
                        transferenciasInternasProvider:
                            transferenciasInternasProvider),
                  ],
                ),
              );
      },
    );
  }
}

class MaterialFromDescription extends StatelessWidget {
  const MaterialFromDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final transferenciasInternasProvider =
        Provider.of<TransferenciaInternaProvider>(context);
    final materialSelectedFrom =
        transferenciasInternasProvider.materialSelectedFrom;

    return Column(
      children: [
        CardItemLabelValue(
            label: 'Descripción: ', value: '${materialSelectedFrom.textoBreve}')
      ],
    );
  }
}

class SearchMaterialFrom extends StatefulWidget {
  final TextEditingController searchController;

  SearchMaterialFrom({super.key, required this.searchController});

  @override
  State<SearchMaterialFrom> createState() => _SearchMaterialFromState();
}

class _SearchMaterialFromState extends State<SearchMaterialFrom> {
  @override
  Widget build(BuildContext context) {
    final materialProvider = Provider.of<MaterialProvider>(context);
    final transferenciasInternasProvider =
        Provider.of<TransferenciaInternaProvider>(context);
    widget.searchController.text = (transferenciasInternasProvider
                .materialSelectedFrom.numeroMaterial !=
            null)
        ? transferenciasInternasProvider.materialSelectedFrom.numeroMaterial!
        : '';

    return TextFormField(
      readOnly: true,
      controller: widget.searchController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecorationsRounded.authInputDecorationRounded(
        hintText: 'Buscar Material...',
        labelText: 'De:',
        color: ThemeProvider.blueColor,
        suffixIcon: FontAwesomeIcons.magnifyingGlass,
      ),
      onTap: () async {
        await showSearch(
          context: context,
          delegate: TransferMaterialSearchDelegate(esDE: true),
        );

        if (materialProvider.materialSelected.numeroMaterial != '') {
          widget.searchController.text =
              materialProvider.materialSelected.numeroMaterial ?? '';
          transferenciasInternasProvider.materialSelectedFrom =
              materialProvider.materialSelected;
          setState(() {});
        } else {
          widget.searchController.clear();
        }
      },
      validator: (value) {
        return (value != null && value.length >= 3)
            ? null
            : 'Por favor agrega un material.';
      },
    );
  }
}

class SearchMaterialTo extends StatefulWidget {
  final TextEditingController searchController;

  SearchMaterialTo({super.key, required this.searchController});

  @override
  State<SearchMaterialTo> createState() => _SearchMaterialToState();
}

class _SearchMaterialToState extends State<SearchMaterialTo> {
  @override
  Widget build(BuildContext context) {
    final materialProvider = Provider.of<MaterialProvider>(context);
    final transferenciasInternasProvider =
        Provider.of<TransferenciaInternaProvider>(context);
    widget.searchController.text =
        (transferenciasInternasProvider.materialSelectedTo.numeroMaterial !=
                null)
            ? transferenciasInternasProvider.materialSelectedTo.numeroMaterial!
            : '';

    return TextFormField(
      readOnly: true,
      controller: widget.searchController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecorationsRounded.authInputDecorationRounded(
        hintText: 'Buscar Material...',
        labelText: 'A:',
        color: ThemeProvider.blueColor,
        suffixIcon: FontAwesomeIcons.magnifyingGlass,
      ),
      onTap: () async {
        await showSearch(
          context: context,
          delegate: TransferMaterialSearchDelegate(esDE: false),
        );

        if (materialProvider.materialSelected.numeroMaterial != '') {
          widget.searchController.text =
              materialProvider.materialSelected.numeroMaterial ?? '';
          setState(() {
            transferenciasInternasProvider.materialSelectedTo =
                materialProvider.materialSelected;
          });
        } else {
          widget.searchController.clear();
        }
      },
      validator: (value) {
        return (value != null && value.length >= 3)
            ? null
            : 'Por favor agrega un material.';
      },
    );
  }
}

class _QuantityFrom extends StatefulWidget {
  const _QuantityFrom({super.key});

  @override
  State<_QuantityFrom> createState() => _QuantityFromState();
}

class _QuantityFromState extends State<_QuantityFrom> {
  final TextEditingController _qtyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final transferenciasInternasProvider =
        Provider.of<TransferenciaInternaProvider>(context);

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _qtyController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        TextInputFormatter.withFunction((oldValue, newValue) {
          final text = newValue.text;
          return text.isEmpty
              ? newValue
              : double.tryParse(text) == null
                  ? oldValue
                  : newValue;
        }),
      ],
      validator: (value) {
        return (value != null && value.isNotEmpty)
            ? null
            : 'Por favor agrega la cantidad.';
      },
      onChanged: (value) {
        print('Quantity From: $value');
        transferenciasInternasProvider.quantityFrom = value;
      },
      decoration: InputDecorationsRounded.authInputDecorationRounded(
        hintText: 'Cantidad',
        labelText: 'Cantidad',
        color: ThemeProvider.blueColor,
        suffixIcon: FontAwesomeIcons.coins,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _QuantityTo extends StatefulWidget {
  const _QuantityTo({super.key});

  @override
  State<_QuantityTo> createState() => _QuantityToState();
}

class _QuantityToState extends State<_QuantityTo> {
  final TextEditingController _qtyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final transferenciasInternasProvider =
        Provider.of<TransferenciaInternaProvider>(context);

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _qtyController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        TextInputFormatter.withFunction((oldValue, newValue) {
          final text = newValue.text;
          return text.isEmpty
              ? newValue
              : double.tryParse(text) == null
                  ? oldValue
                  : newValue;
        }),
      ],
      validator: (value) {
        return (value != null && value.isNotEmpty)
            ? null
            : 'Por favor agrega la cantidad.';
      },
      onChanged: (value) {
        print('Quantity From: $value');
        transferenciasInternasProvider.quantityTo = value;
      },
      decoration: InputDecorationsRounded.authInputDecorationRounded(
        hintText: 'Cantidad',
        labelText: 'Cantidad',
        color: ThemeProvider.blueColor,
        suffixIcon: FontAwesomeIcons.coins,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class AddTransferBtn extends StatelessWidget {
  final TransferenciaInternaProvider transferenciasInternasProvider;
  final TextEditingController searchControllerFrom;
  final TextEditingController searchControllerTo;

  const AddTransferBtn(
      {super.key,
      required this.transferenciasInternasProvider,
      required this.searchControllerFrom,
      required this.searchControllerTo});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        if (!transferenciasInternasProvider.isValidForm()) return;
        FocusScope.of(context).unfocus();

        //hacer la peticion al backend
        // final result = await transferenciasInternasProvider.storeTransfer();
        final result = transferenciasInternasProvider.addTransfer();
        print('Result $result');
        if (result) {
          transferenciasInternasProvider.materialSelectedFrom = Materials();
          transferenciasInternasProvider.materialSelectedTo = Materials();
          transferenciasInternasProvider.formKey.currentState!.reset();
          searchControllerTo.text = '';
          searchControllerFrom.clear();
          searchControllerTo.clear();
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      disabledColor: ThemeProvider.blueColor.withAlpha(150),
      elevation: 0,
      color: ThemeProvider.blueColor,
      // minWidth: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: transferenciasInternasProvider.isLoading
            ? const CupertinoActivityIndicator()
            : Icon(
                FontAwesomeIcons.plus,
                color: ThemeProvider.whiteColor,
              ),
      ),
    );
  }
}

class MaterialDescription extends StatefulWidget {
  final Materials material;

  const MaterialDescription({super.key, required this.material});

  @override
  State<MaterialDescription> createState() => _MaterialDescriptionState();
}

class _MaterialDescriptionState extends State<MaterialDescription> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemLabelValue(
          label: 'Material: ',
          value: '${widget.material.numeroMaterial}',
        ),
        ItemLabelValue(
          label: 'Descripción: ',
          value: '${widget.material.textoBreve}',
        ),
        ItemLabelValue(
          label: 'UM: ',
          value: '${widget.material.unidadMedida}',
        ),
      ],
    );
  }
}

class SubmitTransfersButton extends StatelessWidget {
  final TransferenciaInternaProvider transferenciasInternasProvider;

  const SubmitTransfersButton(
      {super.key, required this.transferenciasInternasProvider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: MaterialButton(
        onPressed: (transferenciasInternasProvider.isLoading ||
                transferenciasInternasProvider.transferencias.isEmpty)
            ? null
            : () async {
                FocusScope.of(context).unfocus();

                //hacer la peticion al backend
                // final result = await transferenciasInternasProvider.storeTransfer();
                final result =
                    await transferenciasInternasProvider.storeTransfers();
                print('Result $result');
              },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: ThemeProvider.blueColor.withAlpha(150),
        elevation: 0,
        color: ThemeProvider.blueColor,
        minWidth: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: transferenciasInternasProvider.isLoading
              ? const CupertinoActivityIndicator()
              : const Text(
                  'Contabilizar Todo',
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

class _orgComprasFrom extends StatelessWidget {
  final String orgComprasFrom;

  const _orgComprasFrom({super.key, required this.orgComprasFrom});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        readOnly: true,
        textAlign: TextAlign.center,
        initialValue: orgComprasFrom,
        decoration: InputDecorationsRounded.authInputDecorationRounded(
          hintText: '',
          labelText: 'Org. Compras',
          color: ThemeProvider.blueColor,
        ),
      ),
    );
  }
}

class _OrgComprasDropdown extends StatelessWidget {
  final TransferenciaInternaProvider transferenciasInternasProvider;

  _OrgComprasDropdown(
      {super.key, required this.transferenciasInternasProvider});

  @override
  Widget build(BuildContext context) {
    final List<OrgCompras> orgCompras =
        transferenciasInternasProvider.orgCompras;

    return Expanded(
      child: DropdownButtonFormField(
        isExpanded: true,
        decoration: InputDecorationsRounded.authInputDecorationRounded(
            hintText: 'Org. Compras',
            labelText: 'Org. Compras',
            color: ThemeProvider.blueColor),
        focusColor: ThemeProvider.blueColor,
        value: transferenciasInternasProvider.orgComprasSelected,
        onChanged: (String? newValue) {
          transferenciasInternasProvider.orgComprasSelected = newValue!;
        },
        items: orgCompras.map<DropdownMenuItem<String>>((OrgCompras value) {
          return DropdownMenuItem<String>(
            value: value.code,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                value.name!,
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
