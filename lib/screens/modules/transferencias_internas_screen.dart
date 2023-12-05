import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/search/main_material_search_delegate.dart';
import 'package:hope_app/ui/input_decorations_rounded.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class TransferenciasInternasScreen extends StatelessWidget {
  static String routeName = 'transferenciasinternas';

  const TransferenciasInternasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TransferenciasInternas(),
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
                child: Form(
                    child: Column(
                  children: [
                    SearchMaterialFrom(searchController: searchControllerFrom),
                    const SizedBox(height: 15),
                    if (transferenciasInternasProvider
                            .materialSelectedFrom.numeroMaterial !=
                        null)
                      MaterialDescription(
                        material:
                            transferenciasInternasProvider.materialSelectedFrom,
                      ),
                    const SizedBox(height: 15),
                    const _QuantityFrom(),
                    Divider(
                      height: 70.0,
                      thickness: 2.0,
                      color: ThemeProvider.lightColor,
                    ),
                    SearchMaterialTo(searchController: searchControllerTo),
                    const SizedBox(height: 15),
                    if (transferenciasInternasProvider
                            .materialSelectedTo.numeroMaterial !=
                        null)
                      MaterialDescription(
                        material:
                            transferenciasInternasProvider.materialSelectedTo,
                      ),
                    const SizedBox(height: 15),
                    const _QuantityTo(),
                    const SizedBox(height: 15),
                    SubmitButton(
                        transferenciasInternasProvider:
                            transferenciasInternasProvider),
                  ],
                )),
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
    widget.searchController.text = transferenciasInternasProvider.materialSelectedFrom.numeroMaterial ?? '';

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
          delegate: MainMaterialSearchDelegate(),
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
    widget.searchController.text = transferenciasInternasProvider.materialSelectedTo.numeroMaterial ?? '';

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
          delegate: MainMaterialSearchDelegate(),
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
    final transferenciasInternasProvider = Provider.of<TransferenciaInternaProvider>(context);

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
    final transferenciasInternasProvider = Provider.of<TransferenciaInternaProvider>(context);

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


class SubmitButton extends StatelessWidget {
  final TransferenciaInternaProvider transferenciasInternasProvider;

  const SubmitButton({super.key, required this.transferenciasInternasProvider});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: (transferenciasInternasProvider.isLoading)
          ? null
          : () async {
              // if (!transferenciasInternasProvider.isValidForm()) return;
              FocusScope.of(context).unfocus();

              //hacer la peticion al backend
              final result =
                  await transferenciasInternasProvider.storeTransfer();
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
                'Guardar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
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
        LabelValueItem(
          label: 'Material: ',
          value: '${widget.material.numeroMaterial}',
        ),
        LabelValueItem(
          label: 'Descripción: ',
          value: '${widget.material.textoBreve}',
        ),
        LabelValueItem(
          label: 'UM: ',
          value: '${widget.material.unidadMedida}',
        ),
      ],
    );
  }
}

class LabelValueItem extends StatelessWidget {
  final String label;
  final String value;

  const LabelValueItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
            flex: 2,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            )),
      ],
    );
  }
}
