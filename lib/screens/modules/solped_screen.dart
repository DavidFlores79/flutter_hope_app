import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/search/material_search_delegate.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations.dart';
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
    final posiciones = solpedProvider.posiciones;

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
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
                              decoration: InputDecorations.authInputDecoration(
                                color: ThemeProvider.blueColor,
                                hintText: '904001526',
                                labelText: 'Material',
                                suffixIcon: FontAwesomeIcons.magnifyingGlass,
                              ),
                              onTap: () async {
                                await showSearch(
                                  context: context,
                                  delegate: MaterialSearchDelegate(),
                                );

                                if (solpedProvider
                                        .materialSelected.numeroMaterial !=
                                    '') {
                                  _searchController.text = solpedProvider
                                          .materialSelected.numeroMaterial ??
                                      '';
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
                            (solpedProvider.materialSelected.textoBreve == null)
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
                                            'Descripcion: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${solpedProvider.materialSelected.textoBreve}',
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
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
                                                '${solpedProvider.materialSelected.umeComercial}',
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
                                      const SizedBox(height: 35),
                                      TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _qtyController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          // for below version 2 use this
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        validator: (value) {
                                          return (value != null &&
                                                  value.isNotEmpty)
                                              ? null
                                              : 'Por favor agrega la cantidad.';
                                        },
                                        decoration: InputDecorations
                                            .authInputDecoration(
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
                              onPressed: (solpedProvider.isLoading ||
                                      !solpedProvider.isValidForm())
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
                                          solpedProvider.materialSelected =
                                              Materials();
                                          _searchController.clear();
                                          _qtyController.clear();
                                        });
                                      } else {
                                        setState(() {
                                          solpedProvider.formKey.currentState
                                              ?.reset();
                                          solpedProvider.materialSelected =
                                              Materials();
                                          _searchController.clear();
                                          _qtyController.clear();
                                        });

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
      floatingActionButton: FloatingActionButton(
        child: const Icon(FontAwesomeIcons.plus),
        onPressed: () => crearSolped(context),
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

  crearSolped(context) {
    print('Crear Solped');
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Crear Pedido",
            textAlign: TextAlign.center,
          ),
          content: const Text('Crear Solped'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {},
              child: const Text(
                "Guardar",
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
