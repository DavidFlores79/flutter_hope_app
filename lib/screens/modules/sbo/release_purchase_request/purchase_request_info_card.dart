import 'package:flutter/material.dart';
import 'package:hope_app/models/sbo/purchase_request/purchase_request_response.dart';
import 'package:hope_app/shared/preferences.dart';

class PurchaseRequestInfoCard extends StatelessWidget {
  final DocumentLine documentLine;

  const PurchaseRequestInfoCard({super.key, required this.documentLine});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _solpedField(
                  label: 'Artículo:',
                  value: '${documentLine.itemCode}',
                  alignment: CrossAxisAlignment.start,
                ),
                const SizedBox(height: 15),
                _solpedField(
                  label: 'Descripción:',
                  value: '${documentLine.itemDescription}',
                  alignment: CrossAxisAlignment.start,
                ),
                const SizedBox(height: 15),
                _solpedField(
                  label: 'Usuario:',
                  value: '${documentLine.createdBy}',
                  alignment: CrossAxisAlignment.start,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _solpedField(
                        label: 'Centro',
                        value: '${documentLine.warehouseCode}'),
                    _solpedField(
                        label: 'Línea', value: '${documentLine.lineNum!}'),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _solpedField(
                      label: 'UM',
                      value: '${documentLine.inventoryUom}',
                    ),
                    _solpedField(
                      label: 'Proveedor:',
                      value: (documentLine.lineVendor != null)
                          ? documentLine.lineVendor
                          : 'Sin Proveedor',
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
                            Preferences.formatDate(documentLine.requestedAt!)),
                    _solpedField(
                      label: 'F. Entrega',
                      value: Preferences.formatDate(documentLine.deliveredAt!),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _solpedField(
                  label: 'Comentarios:',
                  value: '${documentLine.comments}',
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
