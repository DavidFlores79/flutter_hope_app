import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/ui/input_decorations.dart';
import 'package:provider/provider.dart';

class UpdateContent extends StatelessWidget {
  final Posicion material;
  const UpdateContent({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    final solpedProvider = Provider.of<SolpedProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Material: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${material.material}',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Descripción: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${material.textoBreve}',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'UM: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${material.unidadMedida}',
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Centro: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(material.centros!.idcentro!),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Clase Doc.: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(material.clasedocto!),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Tipo Mat.: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(material.tipoMaterial!),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 35),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: double.parse(material.cantidad!).toString(),
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
                print(value);
                solpedProvider.quantity = value;
              },
              decoration: InputDecorations.authInputDecoration(
                color: ThemeProvider.blueColor,
                hintText: '0',
                labelText: 'Cantidad',
                suffixIcon: FontAwesomeIcons.cartArrowDown,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
