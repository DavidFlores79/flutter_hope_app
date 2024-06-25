import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:provider/provider.dart';

import '../ui/input_decorations_rounded.dart';

Future consultaStockModal(BuildContext context) {
  final orientation = MediaQuery.of(context).orientation;

  // mostrar si es igual a iPad o (si es portrait)
  // TODO: Configurar el screen para Tablet, mostrar inputs en horizontal
  return (orientation == Orientation.portrait ||
          Preferences.deviceModel == 'iPad')
      ? showDialog(
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            final consultaStockProvider =
                Provider.of<ConsultaStockProvider>(context);

            return (consultaStockProvider.isLoading)
                ? Center(
                    child: SpinKitCubeGrid(
                      color: ThemeProvider.blueColor,
                    ),
                  )
                : AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    title: const Text(
                      "Consultar",
                      textAlign: TextAlign.center,
                    ),
                    content: SingleChildScrollView(
                      child: Form(
                        key: consultaStockProvider.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              autofocus: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                  final text = newValue.text;
                                  return text.isEmpty
                                      ? newValue
                                      : int.tryParse(text) == null
                                          ? oldValue
                                          : newValue;
                                }),
                              ],
                              maxLength: 18,
                              validator: (value) {
                                return (value != null)
                                    ? null
                                    : 'Por favor agrega un material.';
                              },
                              onChanged: (value) {
                                print(value);
                                consultaStockProvider.material = value;
                              },
                              decoration: InputDecorationsRounded
                                  .authInputDecorationRounded(
                                hintText: 'Artículo (opcional)',
                                labelText: 'Artículo',
                                color: ThemeProvider.blueColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              autofocus: true,
                              autocorrect: false,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
                              maxLength: 10,
                              decoration: InputDecorationsRounded
                                  .authInputDecorationRounded(
                                      hintText: 'Grupo de artículo (opcional)',
                                      labelText: 'Grupo de Artículo',
                                      color: ThemeProvider.blueColor),
                              onChanged: (value) =>
                                  consultaStockProvider.grupoArticulo = value,
                              validator: (value) {
                                return (value != null)
                                    ? null
                                    : 'Al menos 3 caracteres.';
                              },
                            ),
                            const SizedBox(height: 10),
                            CentrosUsuario(miProvider: consultaStockProvider),
                          ],
                        ),
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
                          if (!consultaStockProvider.isValidForm()) return;
                          FocusScope.of(context).unfocus();
                          consultaStockProvider.materials = [];
                          final result = await consultaStockProvider.search();

                          if (result) {
                            Navigator.pop(context);
                          }
                          print('Result: $result');
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
        )
      : Future(() => null);
}

class CentrosUsuario extends StatelessWidget {
  final ConsultaStockProvider miProvider;

  CentrosUsuario({super.key, required this.miProvider});

  @override
  Widget build(BuildContext context) {
    final List<Centro> centrosUsuario = miProvider.centrosUsuario!;

    return DropdownButtonFormField(
      isExpanded: true,
      decoration: InputDecorationsRounded.authInputDecorationRounded(
        hintText: '',
        labelText: 'Centros',
        color: ThemeProvider.blueColor,
      ),
      focusColor: ThemeProvider.blueColor,
      value: miProvider.centroDefault,
      onChanged: (String? newValue) {
        miProvider.centroDefault = newValue!;
      },
      items: centrosUsuario.map<DropdownMenuItem<String>>((Centro value) {
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
    );
  }
}
