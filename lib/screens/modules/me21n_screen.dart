import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/search/main_material_search_delegate.dart';
import 'package:hope_app/search/material_by_supplier_search_delegate.dart';
import 'package:hope_app/search/supplier_search_delegate.dart';
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
    final supplierProvider = Provider.of<SupplierProvider>(context);
    final materialProvider = Provider.of<MaterialProvider>(context);
    final orientation = MediaQuery.of(context).orientation;
    print('Orientation: $orientation');
    return Scaffold(
      body: (orientation == Orientation.landscape &&
              Preferences.deviceModel != 'iPad' &&
              Preferences.deviceModel != 'Tablet')
          ? EmptyContainer(
              assetImage: 'assets/images/icons/portrait.png',
              text:
                  'Coloque el dispositivo en posición VERTICAL para una mejor experiencia.')
          : const CreateOrder(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(FontAwesomeIcons.arrowsRotate),
        onPressed: () => {
          me21nProvider.getCatalogs(),
          me21nProvider.formKey.currentState?.reset(),
          materialProvider.materialSelected = Materials(),
          me21nProvider.posiciones = [],
          supplierProvider.supplierSelected = Supplier(),
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
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchSupplierController =
      TextEditingController();
  final TextEditingController _searchSupplierMaterialController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final me21nProvider = Provider.of<ME21NProvider>(context);
    final supplierProvider = Provider.of<SupplierProvider>(context);
    final materialProvider = Provider.of<MaterialProvider>(context);

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
                    /**
                     * se pasan los texteditingcontroller para resetear 
                     * los input cuando hay cambio de clase de 
                     * documento
                     */
                    ClasesDocumentoDropdownList(
                      me21nProvider: me21nProvider,
                      searchSupplierController: _searchSupplierController,
                      searchSupplierMaterialController:
                          _searchSupplierMaterialController,
                    ),
                    const SizedBox(width: 10),
                    OrgComprasDropdown(me21nProvider: me21nProvider),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    CentrosUsuarioDrop(provider: me21nProvider),
                    const SizedBox(width: 10),
                    _GpoCompras(gpoCompras: me21nProvider.gpoCompras),
                    SizedBox(
                        width: (me21nProvider.clasesDocumentoProv
                                .contains(me21nProvider.claseDocumentoSelected))
                            ? 10
                            : 0),
                    (me21nProvider.clasesDocumentoProv
                            .contains(me21nProvider.claseDocumentoSelected))
                        ? _Almacen(almacen: me21nProvider.almacen)
                        : Container()
                  ],
                ),
                (!me21nProvider.clasesDocumentoProv
                        .contains(me21nProvider.claseDocumentoSelected))
                    ? Column(
                        children: [
                          const SizedBox(height: 15),
                          SearchMaterial(searchController: _searchController),
                        ],
                      )
                    : Column(
                        children: [
                          const SizedBox(height: 15),
                          SearchSupplier(
                              searchController: _searchSupplierController),
                          const SizedBox(height: 15),
                          SearchSupplierMaterial(
                              searchSupplierMaterialController:
                                  _searchSupplierMaterialController),
                        ],
                      ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Quantity(qtyController: _qtyController),
                    const SizedBox(width: 10),
                    //_addPositionButton(searchController: _searchController),
                    Expanded(
                      flex: 1,
                      child: MaterialButton(
                        onPressed: () async {
                          if (!me21nProvider.isValidForm()) return;
                          FocusScope.of(context).unfocus();

                          print('Cantidad vale: ${me21nProvider.quantity}');

                          final pos = PedidoPos(
                            cantidad: getCantidadConversion(
                                    materialProvider.materialSelected,
                                    me21nProvider.quantity)
                                .toString(),
                            numeroMaterial: materialProvider
                                .materialSelected.numeroMaterial,
                            textoBreve:
                                materialProvider.materialSelected.textoBreve,
                            grupoCompras: me21nProvider.gpoCompras,
                            centroReceptor: me21nProvider.centroDefault,
                            unidadMedida: materialProvider
                                .materialSelected.unidadMedidaVisual,
                            claseDocumento:
                                me21nProvider.claseDocumentoSelected,
                            //TODO: Depende de la Clase de Doc es si es devolucion o no
                            esDevolucion: false,
                          );

                          print('Material a insertar: ${pos.numeroMaterial}');
                          for (var pos in me21nProvider.posiciones!) {
                            print('Material pos: ${pos.numeroMaterial}');
                          }

                          // if (!me21nProvider.posiciones!.contains(pos)) {
                          if (!me21nProvider.posiciones!.any((element) =>
                              element.numeroMaterial == pos.numeroMaterial)) {
                            print('no existe');
                            setState(() {
                              if (me21nProvider.clasesDocumentoProv.contains(
                                  me21nProvider.claseDocumentoSelected)) {
                                //agregar el proveedor selecionado
                                me21nProvider.numeroProveedor = me21nProvider
                                    .getSupplierSelected(context)
                                    .numeroProveedor!;
                                //agregar almacen a cada posicion
                                pos.almacen = me21nProvider.almacen;
                              }

                              me21nProvider.posiciones?.add(pos);
                            });
                          } else {
                            print('si existe');
                            await confirmDuplicate(
                                me21nProvider, _searchController);
                          }
                          _searchSupplierMaterialController.clear();
                          _qtyController.clear();
                          setState(() {});
                          me21nProvider.isLoading = false;
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey[500],
                        elevation: 5,
                        color: ThemeProvider.blueColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 12),
                        child: Text(
                          'Agregar',
                          style: TextStyle(
                            color: ThemeProvider.whiteColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          flex: 10,
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
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: MaterialButton(
            onPressed:
                (me21nProvider.isLoading || me21nProvider.posiciones!.isEmpty)
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();

                        if (me21nProvider.posiciones!.isEmpty) {
                          Notifications.showSnackBar(
                            'Debe agregar al menos un material para crear el Pedido.',
                          );
                          return;
                        }

                        //hacer la peticion al backend
                        final result = await me21nProvider.createOrder();
                        if (result) {
                          materialProvider.materialSelected = Materials();
                          supplierProvider.supplierSelected = Supplier();
                          me21nProvider.posiciones = [];
                          me21nProvider.numeroProveedor = '';
                          _searchSupplierController.clear();
                          _searchSupplierMaterialController.clear();
                          _qtyController.text = '';
                          setState(() {});
                        }
                      },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: ThemeProvider.blueColor.withAlpha(150),
            elevation: 0,
            color: ThemeProvider.blueColor,
            minWidth: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: (me21nProvider.isLoading)
                  ? CircularProgressIndicator.adaptive(
                      backgroundColor: ThemeProvider.whiteColor,
                    )
                  : const Text(
                      'Crear Pedido',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  confirmDuplicate(
      ME21NProvider me21nProvider, TextEditingController _searchController) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final materialProvider = Provider.of<MaterialProvider>(context);

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
                      text:
                          '${materialProvider.materialSelected.numeroMaterial}',
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
                _searchController.clear();
                setState(() {
                  me21nProvider.posiciones?.add(
                    PedidoPos(
                      cantidad: getCantidadConversion(
                              materialProvider.materialSelected,
                              me21nProvider.quantity)
                          .toString(),
                      numeroMaterial:
                          materialProvider.materialSelected.numeroMaterial,
                      textoBreve: materialProvider.materialSelected.textoBreve,
                      grupoCompras: me21nProvider.gpoCompras,
                      centroReceptor: me21nProvider.centroDefault,
                      unidadMedida:
                          materialProvider.materialSelected.unidadMedidaVisual,
                      claseDocumento: me21nProvider.claseDocumentoSelected,
                      //TODO: Depende de la Clase de Doc es si es devolucion o no
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

  @override
  void initState() {
    super.initState();
    final me21nProvider = Provider.of<ME21NProvider>(context, listen: false);
    // Configurar el valor inicial solo la primera vez que se construye el widget
    _searchSupplierController.text = me21nProvider.numeroProveedor;
    me21nProvider.getCatalogs();
  }
}

getCantidadConversion(materialSelected, quantity) {
  final umren = materialSelected.denConversion;
  final umrez = materialSelected.numConversion;
  final cantidad = quantity;
  final cantidadConversion = (double.parse(umrez!) / double.parse(umren!)) *
      double.parse(cantidad); //CANTIDAD = (UMREZ / UMREN) * CANTIDAD
  return cantidadConversion;
}

class ClasesDocumentoDropdownList extends StatelessWidget {
  final ME21NProvider me21nProvider;
  final TextEditingController searchSupplierController;
  final TextEditingController searchSupplierMaterialController;

  ClasesDocumentoDropdownList(
      {super.key,
      required this.me21nProvider,
      required this.searchSupplierController,
      required this.searchSupplierMaterialController});

  @override
  Widget build(BuildContext context) {
    final supplierProvider = Provider.of<SupplierProvider>(context);
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
        onChanged: (me21nProvider.posiciones!.isEmpty)
            ? (String? newValue) {
                me21nProvider.claseDocumentoSelected = newValue!;
                supplierProvider.supplierSelected = Supplier();
                //TODO: Resetear el form
                me21nProvider.formKey.currentState!.reset();
                searchSupplierController.clear();
                searchSupplierMaterialController.clear();
              }
            : null,
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
        onChanged: (me21nProvider.posiciones!.isEmpty)
            ? (String? newValue) {
                me21nProvider.orgComprasSelected = newValue!;
              }
            : null,
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

class _GpoCompras extends StatefulWidget {
  final String gpoCompras;

  const _GpoCompras({super.key, required this.gpoCompras});

  @override
  State<_GpoCompras> createState() => _GpoComprasState();
}

class _GpoComprasState extends State<_GpoCompras> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final me21nProvider = Provider.of<ME21NProvider>(context);
    Future.delayed(const Duration(milliseconds: 500), () {
      textController.text = me21nProvider.gpoCompras;
    });

    return Expanded(
      child: TextFormField(
        readOnly: true,
        textAlign: TextAlign.center,
        controller: textController,
        decoration: InputDecorationsRounded.authInputDecorationRounded(
          hintText: '',
          labelText: 'GpoCompras',
          color: ThemeProvider.blueColor,
        ),
      ),
    );
  }
}

class _Almacen extends StatelessWidget {
  final String almacen;

  const _Almacen({super.key, required this.almacen});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        readOnly: true,
        textAlign: TextAlign.center,
        initialValue: almacen,
        decoration: InputDecorationsRounded.authInputDecorationRounded(
          hintText: '',
          labelText: 'Almacén',
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
    final materialProvider = Provider.of<MaterialProvider>(context);

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
          delegate: MainMaterialSearchDelegate('me21n'),
        );

        if (materialProvider.materialSelected.numeroMaterial != '') {
          widget.searchController.text =
              materialProvider.materialSelected.numeroMaterial ?? '';
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

class SearchSupplier extends StatefulWidget {
  final TextEditingController searchController;

  SearchSupplier({super.key, required this.searchController});

  @override
  State<SearchSupplier> createState() => _SearchSupplierState();
}

class _SearchSupplierState extends State<SearchSupplier> {
  @override
  Widget build(BuildContext context) {
    final supplierProvider = Provider.of<SupplierProvider>(context);
    final me21nProvider = Provider.of<ME21NProvider>(context);

    return TextFormField(
      readOnly: true,
      enabled: (me21nProvider.posiciones!.isEmpty) ? true : false,
      controller: widget.searchController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecorationsRounded.authInputDecorationRounded(
        hintText: 'Buscar Proveedor...',
        labelText: 'Proveedor',
        color: ThemeProvider.blueColor,
        suffixIcon: FontAwesomeIcons.magnifyingGlass,
      ),
      onTap: () async {
        await showSearch(
          context: context,
          delegate: SupplierSearchDelegate(),
        );

        if (supplierProvider.supplierSelected.numeroProveedor != '') {
          widget.searchController.text =
              supplierProvider.supplierSelected.numeroProveedor ?? '';
        } else {
          widget.searchController.clear();
        }
      },
      validator: (value) {
        return (value != null && value.length >= 3)
            ? null
            : 'Por favor agrega un proveedor para crear el Pedido.';
      },
    );
  }
}

class SearchSupplierMaterial extends StatefulWidget {
  final TextEditingController searchSupplierMaterialController;

  SearchSupplierMaterial(
      {super.key, required this.searchSupplierMaterialController});

  @override
  State<SearchSupplierMaterial> createState() => _SearchSupplierMaterialState();
}

class _SearchSupplierMaterialState extends State<SearchSupplierMaterial> {
  @override
  Widget build(BuildContext context) {
    final materialProvider = Provider.of<MaterialProvider>(context);
    final supplierProvider = Provider.of<SupplierProvider>(context);

    return TextFormField(
      readOnly: true,
      // enabled: (supplierProvider.supplierSelected.numeroProveedor != null) ? true:false,
      controller: widget.searchSupplierMaterialController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecorationsRounded.authInputDecorationRounded(
        hintText: 'Buscar Material Prov...',
        labelText: 'Material Prov',
        color: ThemeProvider.blueColor,
        suffixIcon: FontAwesomeIcons.magnifyingGlass,
      ),
      onTap: (supplierProvider.supplierSelected.numeroProveedor != null)
          ? () async {
              print(
                  'Ya fue seleccionado el Proveedor ${supplierProvider.supplierSelected.numeroProveedor}');
              await showSearch(
                context: context,
                delegate: SupplierMaterialSearchDelegate(),
              );

              if (materialProvider.materialSelected.numeroMaterial != '') {
                print('si se cumplio');
                widget.searchSupplierMaterialController.text =
                    materialProvider.materialSelected.numeroMaterial ?? '';
                setState(() {});
              } else {
                widget.searchSupplierMaterialController.clear();
              }
            }
          : null,
      validator: (value) {
        return (value != null && value.length >= 3)
            ? null
            : 'Por favor agrega un material prov para crear el Pedido.';
      },
    );
  }
}

class _Quantity extends StatefulWidget {
  final TextEditingController qtyController;

  const _Quantity({super.key, required this.qtyController});

  @override
  State<_Quantity> createState() => __QuantityState();
}

class __QuantityState extends State<_Quantity> {
  @override
  Widget build(BuildContext context) {
    final me21nProvider = Provider.of<ME21NProvider>(context);

    return Expanded(
      flex: 2,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.qtyController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          TextInputFormatter.withFunction((oldValue, newValue) {
            final text = newValue.text;
            return text.isEmpty
                ? newValue
                : (double.tryParse(text) == null ||
                        (!RegExp(r'^\d*\.?\d{0,3}$').hasMatch(newValue.text)))
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
          print(value);
          me21nProvider.quantity = value;
        },
        decoration: InputDecorationsRounded.authInputDecorationRounded(
          hintText: 'Cantidad',
          labelText: 'Cantidad',
          color: ThemeProvider.blueColor,
          suffixIcon: FontAwesomeIcons.coins,
        ),
        textAlign: TextAlign.center,
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
    final materialProvider = Provider.of<MaterialProvider>(context);

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
                    .contains(materialProvider.materialSelected)) {
                  print('Cantidad vale: ${me21nProvider.quantity}');
                  setState(() {
                    me21nProvider.posiciones?.add(PedidoPos(
                      cantidad: getCantidadConversion(
                          materialProvider.materialSelected,
                          me21nProvider.quantity),
                      numeroMaterial:
                          materialProvider.materialSelected.numeroMaterial,
                      textoBreve: materialProvider.materialSelected.textoBreve,
                      grupoCompras: me21nProvider.gpoCompras,
                      centroReceptor: me21nProvider.centroDefault,
                      unidadMedida:
                          materialProvider.materialSelected.unidadMedidaVisual,
                      claseDocumento: me21nProvider.claseDocumentoSelected,
                      //TODO: Depende de la Clase de Doc es si es devolucion o no
                      esDevolucion: false,
                    ));
                  });
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
        final materialProvider = Provider.of<MaterialProvider>(context);

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
                      text:
                          '${materialProvider.materialSelected.numeroMaterial}',
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
                  numeroMaterial:
                      materialProvider.materialSelected.numeroMaterial,
                  textoBreve: materialProvider.materialSelected.textoBreve,
                  centroReceptor: me21nProvider.centroDefault,
                  unidadMedida: materialProvider.materialSelected.unidadMedida,
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
