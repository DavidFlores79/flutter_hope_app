import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/search/me21n_material_search_delegate.dart';
import 'package:hope_app/ui/input_decorations.dart';
import 'package:provider/provider.dart';

class ME21NScreen extends StatelessWidget {
  static const String routeName = 'me21n';

  ME21NScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final me21nProvider = Provider.of<ME21NProvider>(context);

    return Scaffold(
      body: (me21nProvider.isLoading)
          ? Center(
              child: SpinKitCubeGrid(
                color: ThemeProvider.blueColor,
              ),
            )
          : const CreateOrder(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(FontAwesomeIcons.arrowsRotate),
        onPressed: () => {
          me21nProvider.getCatalogs(),
          me21nProvider.formKey.currentState?.reset(),
          me21nProvider.materialSelected = Materials(),
        },
      ),
    );
  }
}

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final me21nProvider = Provider.of<ME21NProvider>(context);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: Form(
          key: me21nProvider.formKey,
          child: Column(
            children: [
              ClasesDocumentoDropdownList(me21nProvider: me21nProvider),
              const SizedBox(height: 25),
              OrgComprasDropdown(me21nProvider: me21nProvider),
              const SizedBox(height: 25),
              CentrosUsuarioDropdown(me21nProvider: me21nProvider),
              const SizedBox(height: 25),
              TextFormField(
                readOnly: true,
                controller: _searchController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecorations.authInputDecoration(
                  color: ThemeProvider.blueColor,
                  hintText: '904001526',
                  labelText: 'Material',
                  suffixIcon: FontAwesomeIcons.magnifyingGlass,
                ),
                onTap: () async {
                  await showSearch(
                    context: context,
                    delegate: ME21NMaterialSearchDelegate(),
                  );

                  if (me21nProvider.materialSelected.numeroMaterial != '') {
                    print('se asigno el valor');
                    _searchController.text =
                        me21nProvider.materialSelected.numeroMaterial ?? '';
                  } else {
                    _searchController.clear();
                  }
                },
                validator: (value) {
                  return (value != null && value.length >= 3)
                      ? null
                      : 'Por favor agrega un material para crear el Pedido.';
                },
              ),
              const SizedBox(height: 25),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Valor del Material: ${me21nProvider.materialSelected.numeroMaterial}',
                    ),
                    Text(
                      'Valor del Dropdown: ${me21nProvider.claseDocumentoSelected}',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ClasesDocumentoDropdownList extends StatelessWidget {
  final ME21NProvider me21nProvider;

  ClasesDocumentoDropdownList({super.key, required this.me21nProvider});

  @override
  Widget build(BuildContext context) {
    final List<ClasesDocumento> clasesDocumento = me21nProvider.clases;

    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Clase de Documento',
        labelStyle: TextStyle(
          color: ThemeProvider.lightColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeProvider.blueColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeProvider.blueColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeProvider.blueColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      focusColor: ThemeProvider.blueColor,
      value: me21nProvider.claseDocumentoSelected,
      onChanged: (String? newValue) {
        me21nProvider.claseDocumentoSelected = newValue!;
      },
      items: clasesDocumento
          .map<DropdownMenuItem<String>>((ClasesDocumento value) {
        return DropdownMenuItem<String>(
          value: value.code,
          child: Text(
            value.name!,
            style: const TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }
}

class OrgComprasDropdown extends StatelessWidget {
  final ME21NProvider me21nProvider;

  OrgComprasDropdown({super.key, required this.me21nProvider});

  @override
  Widget build(BuildContext context) {
    final List<OrgCompras> orgCompras = me21nProvider.orgCompras;

    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Org. Compras',
        labelStyle: TextStyle(
          color: ThemeProvider.lightColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeProvider.blueColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeProvider.blueColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeProvider.blueColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      focusColor: ThemeProvider.blueColor,
      value: me21nProvider.orgComprasSelected,
      onChanged: (String? newValue) {
        me21nProvider.orgComprasSelected = newValue!;
      },
      items: orgCompras.map<DropdownMenuItem<String>>((OrgCompras value) {
        return DropdownMenuItem<String>(
          value: value.code,
          child: Text(
            value.name!,
            style: const TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }
}

class CentrosUsuarioDropdown extends StatelessWidget {
  final ME21NProvider me21nProvider;

  CentrosUsuarioDropdown({super.key, required this.me21nProvider});

  @override
  Widget build(BuildContext context) {
    final List<Centros> centrosUsuario = me21nProvider.centrosUsuario!;

    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Centros',
        labelStyle: TextStyle(
          color: ThemeProvider.lightColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeProvider.blueColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeProvider.blueColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeProvider.blueColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      focusColor: ThemeProvider.blueColor,
      value: me21nProvider.centroDefault,
      onChanged: (String? newValue) {
        me21nProvider.centroDefault = newValue!;
      },
      items: centrosUsuario.map<DropdownMenuItem<String>>((Centros value) {
        return DropdownMenuItem<String>(
          value: value.idcentro,
          child: Text(
            '${value.idcentro!} ${value.nombre!}',
            style: const TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }
}



// DropdownMenu<String>(
// initialSelection: clasesDocumento.first.code,
// onSelected: (String? value) {
//   // This is called when the user selects an item.
//   me21nProvider.claseDocumentoSelected = value!;
//   print('Value: $value');
// },
// dropdownMenuEntries: clasesDocumento
//     .map<DropdownMenuEntry<String>>((ClaseDocumento value) {
//   return DropdownMenuEntry<String>(
//     value: value.code,
//     label: value.name,
//   );
// }).toList(),
// ),