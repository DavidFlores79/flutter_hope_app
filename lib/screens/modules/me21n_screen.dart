import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/search/me21n_material_search_delegate.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations_rounded.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/widgets/widgets.dart';
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

  @override
  Widget build(BuildContext context) {
    final me21nProvider = Provider.of<ME21NProvider>(context);

    return Column(
      children: [
        Form(
          key: me21nProvider.formKey,
          child: Container(
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
            child: Column(
              children: [
                Row(
                  children: [
                    ClasesDocumentoDropdownList(me21nProvider: me21nProvider),
                    const SizedBox(width: 10),
                    CentrosUsuarioDropdown(miProvider: me21nProvider),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    OrgComprasDropdown(me21nProvider: me21nProvider),
                    const SizedBox(width: 10),
                    _gpoCompras(gpoCompras: me21nProvider.gpoCompras)
                  ],
                ),
                const SizedBox(height: 15),
                SearchMaterial(searchController: _searchController),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _Quantity(),
                    const SizedBox(width: 10),
                    _addPositionButton(searchController: _searchController),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: ListView.builder(
              padding: const EdgeInsetsDirectional.only(
                bottom: 150,
              ),
              itemCount: me21nProvider.posiciones?.length,
              itemBuilder: (context, index) {
                final posicion = me21nProvider.posiciones![index];

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
                  confirmDismiss: (DismissDirection direction) async {
                    return true;
                  },
                  onDismissed: (DismissDirection direction) {
                    print('Eliminado ${index}');
                    setState(() {
                      me21nProvider.posiciones?.remove(posicion);
                    });
                  },
                  child: ME21NPositionCard(material: posicion),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: MaterialButton(
            onPressed: (me21nProvider.isLoading)
                ? null
                : () async {
                    me21nProvider.isLoading = true;
                    FocusScope.of(context).unfocus();

                    //hacer la peticion al backend
                    final result = await me21nProvider.createOrder();
                    if (result) {
                      Notifications.showSnackBar('Todo bien!!');
                    } else {
                      Notifications.showSnackBar('Todo mal!!');
                    }

                    me21nProvider.isLoading = false;
                  },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: ThemeProvider.blueColor,
            minWidth: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Text(
                me21nProvider.isLoading ? 'Espere' : 'Crear Pedido',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  confirmDuplicate(
      ME21NProvider me21nProvider, TextEditingController _searchController) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Confirmar Duplicado",
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
                  text: "¿Ya existe el material ",
                  children: [
                    TextSpan(
                      text: '${me21nProvider.materialSelected.numeroMaterial}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text:
                          ' en las posiciones del Pedido.\n\n¿Estás seguro en agregarlo?',
                    ),
                  ]),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Cancelar",
                style: TextStyle(color: ThemeProvider.redColor),
              ),
            ),
            TextButton(
              onPressed: () async {
                me21nProvider.formKey.currentState?.reset();
                _searchController.clear();
                setState(() {
                  me21nProvider.posiciones?.add(
                    PedidoPos(
                      cantidad: me21nProvider.quantity,
                      numeroMaterial:
                          me21nProvider.materialSelected.numeroMaterial,
                      textoBreve: me21nProvider.materialSelected.textoBreve,
                      centroReceptor: me21nProvider.centroDefault,
                      unidadMedida: me21nProvider.materialSelected.unidadMedida,
                      claseDocumento: me21nProvider.claseDocumentoSelected,
                      esDevolucion: false,
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: Text(
                "Confirmar",
                style: TextStyle(
                  color: ThemeProvider.blueColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ClasesDocumentoDropdownList extends StatelessWidget {
  final ME21NProvider me21nProvider;

  ClasesDocumentoDropdownList({super.key, required this.me21nProvider});

  @override
  Widget build(BuildContext context) {
    final List<ClasesDocumento> clasesDocumento = me21nProvider.clases;

    return Expanded(
      child: DropdownButtonFormField(
        isExpanded: true,
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
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
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

class OrgComprasDropdown extends StatelessWidget {
  final ME21NProvider me21nProvider;

  OrgComprasDropdown({super.key, required this.me21nProvider});

  @override
  Widget build(BuildContext context) {
    final List<OrgCompras> orgCompras = me21nProvider.orgCompras;

    return Expanded(
      child: DropdownButtonFormField(
        isExpanded: true,
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
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
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

class CentrosUsuarioDropdown extends StatelessWidget {
  final ME21NProvider miProvider;

  CentrosUsuarioDropdown({super.key, required this.miProvider});

  @override
  Widget build(BuildContext context) {
    final List<Centros> centrosUsuario = miProvider.centrosUsuario!;

    return Expanded(
      child: DropdownButtonFormField(
        isExpanded: true,
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
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
        ),
        focusColor: ThemeProvider.blueColor,
        value: miProvider.centroDefault,
        onChanged: (String? newValue) {
          miProvider.centroDefault = newValue!;
        },
        items: centrosUsuario.map<DropdownMenuItem<String>>((Centros value) {
          return DropdownMenuItem<String>(
            value: value.idcentro,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                value.idcentro!,
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

class _gpoCompras extends StatelessWidget {
  final String gpoCompras;

  const _gpoCompras({super.key, required this.gpoCompras});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        readOnly: true,
        textAlign: TextAlign.center,
        initialValue: gpoCompras,
        decoration: InputDecorationsRounded.authInputDecorationRounded(
          hintText: '',
          labelText: 'GpoCompras',
          color: ThemeProvider.blueColor,
        ),
      ),
    );
  }
}

class SearchMaterial extends StatefulWidget {
  final TextEditingController searchController;

  SearchMaterial({super.key, required this.searchController});

  @override
  State<SearchMaterial> createState() => _SearchMaterialState();
}

class _SearchMaterialState extends State<SearchMaterial> {
  @override
  Widget build(BuildContext context) {
    final me21nProvider = Provider.of<ME21NProvider>(context);

    return TextFormField(
      readOnly: true,
      controller: widget.searchController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecorationsRounded.authInputDecorationRounded(
        hintText: 'Buscar Material...',
        labelText: 'Material',
        color: ThemeProvider.blueColor,
        suffixIcon: FontAwesomeIcons.magnifyingGlass,
      ),
      onTap: () async {
        await showSearch(
          context: context,
          delegate: ME21NMaterialSearchDelegate(),
        );

        if (me21nProvider.materialSelected.numeroMaterial != '') {
          widget.searchController.text =
              me21nProvider.materialSelected.numeroMaterial ?? '';
        } else {
          widget.searchController.clear();
        }
      },
      validator: (value) {
        return (value != null && value.length >= 3)
            ? null
            : 'Por favor agrega un material para crear el Pedido.';
      },
    );
  }
}

class _Quantity extends StatefulWidget {
  const _Quantity({super.key});

  @override
  State<_Quantity> createState() => __QuantityState();
}

class __QuantityState extends State<_Quantity> {
  final TextEditingController _qtyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final me21nProvider = Provider.of<ME21NProvider>(context);

    return Expanded(
      flex: 2,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _qtyController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.digitsOnly
        ],
        validator: (value) {
          return (value != null && value.isNotEmpty)
              ? null
              : 'Por favor agrega la cantidad.';
        },
        onChanged: (value) {
          print(value);
          me21nProvider.quantity = value;
        },
        decoration: InputDecorationsRounded.authInputDecorationRounded(
          hintText: 'Cantidad',
          labelText: 'Cantidad',
          color: ThemeProvider.blueColor,
          suffixIcon: FontAwesomeIcons.coins,
        ),
      ),
    );
  }
}

class _addPositionButton extends StatefulWidget {
  final TextEditingController searchController;

  _addPositionButton({super.key, required this.searchController});

  @override
  State<_addPositionButton> createState() => __addPositionButtonState();
}

class __addPositionButtonState extends State<_addPositionButton> {
  @override
  Widget build(BuildContext context) {
    final me21nProvider = Provider.of<ME21NProvider>(context);

    return Expanded(
      flex: 1,
      child: MaterialButton(
        onPressed: me21nProvider.isLoading
            ? null
            : () async {
                if (!me21nProvider.isValidForm()) return;
                me21nProvider.isLoading = true;
                FocusScope.of(context).unfocus();

                if (!me21nProvider.posiciones!
                    .contains(me21nProvider.materialSelected)) {
                  print('Cantidad vale: ${me21nProvider.quantity}');
                  me21nProvider.posiciones?.add(PedidoPos(
                    cantidad: me21nProvider.quantity,
                    numeroMaterial:
                        me21nProvider.materialSelected.numeroMaterial,
                    textoBreve: me21nProvider.materialSelected.textoBreve,
                    grupoCompras: me21nProvider.gpoCompras,
                    centroReceptor: me21nProvider.centroDefault,
                    unidadMedida: me21nProvider.materialSelected.unidadMedida,
                    claseDocumento: me21nProvider.claseDocumentoSelected,
                    esDevolucion: false,
                  ));
                  me21nProvider.formKey.currentState?.reset();
                  widget.searchController.clear();
                  setState(() {});
                } else {
                  await confirmDuplicate(
                      me21nProvider, widget.searchController);
                }

                me21nProvider.isLoading = false;
              },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: Colors.grey[500],
        elevation: 5,
        color: ThemeProvider.blueColor,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
        child: Text(
          'Agregar',
          style: TextStyle(
            color: ThemeProvider.whiteColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  confirmDuplicate(
      ME21NProvider me21nProvider, TextEditingController _searchController) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Confirmar Duplicado",
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
                  text: "¿Ya existe el material ",
                  children: [
                    TextSpan(
                      text: '${me21nProvider.materialSelected.numeroMaterial}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text:
                          ' en las posiciones del Pedido.\n\n¿Estás seguro en agregarlo?',
                    ),
                  ]),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Cancelar",
                style: TextStyle(color: ThemeProvider.redColor),
              ),
            ),
            TextButton(
              onPressed: () async {
                me21nProvider.posiciones?.add(PedidoPos(
                  cantidad: me21nProvider.quantity,
                  numeroMaterial: me21nProvider.materialSelected.numeroMaterial,
                  textoBreve: me21nProvider.materialSelected.textoBreve,
                  centroReceptor: me21nProvider.centroDefault,
                  unidadMedida: me21nProvider.materialSelected.unidadMedida,
                  claseDocumento: me21nProvider.claseDocumentoSelected,
                  esDevolucion: false,
                ));
                me21nProvider.formKey.currentState?.reset();
                _searchController.clear();
                setState(() {});
                Navigator.pop(context);
              },
              child: Text(
                "Confirmar",
                style: TextStyle(
                  color: ThemeProvider.blueColor,
                ),
              ),
            ),
          ],
        );
      },
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