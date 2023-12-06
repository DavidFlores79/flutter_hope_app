import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/search/main_material_search_delegate.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations_rounded.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SolpedScreen extends StatefulWidget {
  static const String routeName = 'solped';

  const SolpedScreen({super.key});

  @override
  State<SolpedScreen> createState() => _SolpedScreenState();
}

class _SolpedScreenState extends State<SolpedScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final solpedProvider = Provider.of<SolpedProvider>(context);
    final materialProvider = Provider.of<MaterialProvider>(context);
    final liberarsolpedProvider = Provider.of<LiberarSolpedProvider>(context);
    final posiciones = solpedProvider.posiciones;

    // if(tipo_material === "ZACT"){
    //   if (isNaN(activo_fijo)) {
    //     return swal( solped.titulo, 'El activo fijo debe ser numérico', tiposDeMensaje.error );
    //   }
    //   if (activo_fijo === null || activo_fijo === null || activo_fijo.trim() === '') {
    //     return swal( solped.titulo, 'Ingresa el activo fijo', tiposDeMensaje.error );
    //   }
    // }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => solpedProvider.getCatalogs(),
        child: (solpedProvider.isLoading)
            ? Center(
                child: SpinKitCubeGrid(
                  color: ThemeProvider.blueColor,
                ),
              )
            : Column(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25),
                    child: Form(
                        key: solpedProvider.formKey,
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
                                color: ThemeProvider.blueColor,
                                hintText: '904001526',
                                labelText: 'Material',
                                suffixIcon: FontAwesomeIcons.magnifyingGlass,
                              ),
                              onTap: () async {
                                await showSearch(
                                  context: context,
                                  delegate: MainMaterialSearchDelegate('solped'),
                                );

                                final numeroMaterial = materialProvider
                                    .materialSelected.numeroMaterial;
                                final tipoMaterial = materialProvider
                                    .materialSelected.tipoMaterial;
                                print('Tipo de Material $tipoMaterial');

                                if (numeroMaterial != '' &&
                                    tipoMaterial != 'ZACT') {
                                  _searchController.text = solpedProvider
                                          .materialSelected.numeroMaterial ??
                                      '';
                                  if (tipoMaterial == 'ZACT') {
                                    Notifications.showSnackBar(
                                        'Tipo de Material $tipoMaterial inválido.');
                                  }
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
                            const SizedBox(height: 20),
                            (materialProvider.materialSelected.textoBreve ==
                                    null)
                                ? Container()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                            '${materialProvider.materialSelected.textoBreve}',
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'UME: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${materialProvider.materialSelected.umeComercial}',
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
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  solpedProvider.centroDefault),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Clase Doc.: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(solpedProvider
                                                  .claseDocumento),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      TextFormField(
                                        textAlign: TextAlign.center,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _qtyController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]')),
                                          TextInputFormatter.withFunction(
                                              (oldValue, newValue) {
                                            final text = newValue.text;
                                            return text.isEmpty
                                                ? newValue
                                                : double.tryParse(text) == null
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
                                          solpedProvider.quantity = value;
                                        },
                                        decoration: InputDecorationsRounded
                                            .authInputDecorationRounded(
                                          color: ThemeProvider.blueColor,
                                          hintText: '0',
                                          labelText: 'Cantidad',
                                          suffixIcon:
                                              FontAwesomeIcons.cartArrowDown,
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 35),
                            MaterialButton(
                              onPressed: (solpedProvider.isLoading)
                                  ? null
                                  : () async {
                                      if (!solpedProvider.isValidForm()) return;
                                      solpedProvider.isLoading = true;
                                      FocusScope.of(context).unfocus();

                                      //hacer la peticion al backend
                                      final result =
                                          await solpedProvider.createSolped();

                                      print('Result $result');
                                      if (!result) {
                                        setState(() {
                                          solpedProvider.formKey.currentState
                                              ?.reset();
                                          materialProvider.materialSelected =
                                              Materials();
                                          _searchController.clear();
                                          _qtyController.clear();
                                        });
                                      } else {
                                        setState(() {
                                          solpedProvider.formKey.currentState
                                              ?.reset();
                                          materialProvider.materialSelected =
                                              Materials();
                                          _searchController.clear();
                                          _qtyController.clear();
                                        });
                                        liberarsolpedProvider.getSolpeds();
                                        Notifications.showSnackBar(
                                            'Pedido creado correctamente.');
                                      }

                                      solpedProvider.isLoading = false;
                                    },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              disabledColor: Colors.grey,
                              elevation: 0,
                              color: ThemeProvider.blueColor,
                              minWidth: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                child: Text(
                                  solpedProvider.isLoading
                                      ? 'Espere'
                                      : 'Crear Pedido',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            (materialProvider.materialSelected.textoBreve ==
                                    null)
                                ? const Column(
                                    children: [
                                      SizedBox(height: 15),
                                      Text(
                                        'Para crear una Solicitud de Pedido seleccione el material y agregue la cantidad que desea pedir.',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        )),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: posiciones?.length,
                        itemBuilder: (context, index) {
                          final posicion = posiciones![index];

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
                              return await confirmarEliminar(
                                  context, solpedProvider, posicion);
                            },
                            onDismissed: (DismissDirection direction) {
                              print('Eliminado ${index}');
                            },
                            child: PositionCard(material: posicion),
                          );
                        }),
                  ),
                ],
              ),
      ),
    );
  }

  confirmarEliminar(BuildContext context, solpedProvider, Posicion posicion) {
    print('Eliminar ${posicion.id} ??');
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
                      text: '${posicion.material}',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                print('Eliminar! ${posicion.id}');
                final result = await solpedProvider.deleteSolped(posicion.id!);
                print('Eliminado! $result');
                if (result) {
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
