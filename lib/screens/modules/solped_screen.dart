import 'package:flutter/material.dart';
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
                                  suffixIcon: Icons.search_outlined),
                              onTap: () async {
                                await showSearch(
                                  context: context,
                                  delegate: MaterialSearchDelegate(),
                                );

                                if (solpedProvider
                                        .materialSelected.textoBreve !=
                                    '') {
                                  _searchController.text = solpedProvider
                                          .materialSelected.textoBreve ??
                                      '';
                                }
                              },
                              validator: (value) {
                                return (value != null && value.length >= 3)
                                    ? null
                                    : 'Paciente debe contener más de 3 caracteres.';
                              },
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
                                        setState(() {});
                                        _searchController.clear();
                                      } else {
                                        setState(() {});
                                        _searchController.clear();

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
