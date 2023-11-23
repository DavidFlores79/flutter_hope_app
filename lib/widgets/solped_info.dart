import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations.dart';
import 'package:provider/provider.dart';

class SolpedInfo extends StatelessWidget {
  final Posicion material;
  const SolpedInfo({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    final solpedProvider = Provider.of<SolpedProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _solpedField(
                  label: 'Material:',
                  value: material.material!,
                  alignment: CrossAxisAlignment.start,
                ),
                const SizedBox(height: 15),
                _solpedField(
                  label: 'Descripción:',
                  value: material.textoBreve!,
                  alignment: CrossAxisAlignment.start,
                ),
                const SizedBox(height: 15),
                _solpedField(
                  label: 'Usuario:',
                  value: '${material.usuarioCreacion!}',
                  alignment: CrossAxisAlignment.start,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _solpedField(
                        label: 'Centro', value: material.centros!.idcentro!),
                    _solpedField(label: 'Pos', value: '${material.posicion!}'),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _solpedField(label: 'UM', value: material.unidadMedida!),
                    _solpedField(
                      label: 'Clase Doc.',
                      value: '${material.clasedocto}',
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _solpedField(
                        label: 'Tipo Mat.', value: material.tipoMaterial!),
                    // _solpedField(label: 'Pos: ', value: '${material.posicion!}'),
                    _solpedField(
                      label: 'Org. Compras',
                      value: '${material.orgCompras}',
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _solpedField(
                        label: 'F. Solicitud',
                        value:
                            Preferences.formatDate(material.fechaSolicitud!)),
                    _solpedField(
                      label: 'F. Entrega',
                      value: Preferences.formatDate(material.fechaEntrega!),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _solpedField(
                        label: 'Gpo. Artículos',
                        value: '${material.gpoArticulo}'),
                    _solpedField(
                      label: 'Gpo. Compras',
                      value: '${material.gpoCompras}',
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _solpedField(
                        label: 'Tipo Imputación',
                        value: '${material.tipoImputacion}'),
                    _solpedField(
                      label: 'Moneda',
                      value: '${material.claveMoneda}',
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _solpedField(
                  label: 'Comentarios:',
                  value: material.comentarios!,
                  alignment: CrossAxisAlignment.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _solpedField extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment alignment;

  const _solpedField({
    super.key,
    required this.value,
    required this.label,
    this.alignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value),
      ],
    );
  }
}
