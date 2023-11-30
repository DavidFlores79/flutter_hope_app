import 'package:flutter/material.dart';
import 'package:hope_app/models/consulta_stock_response.dart';
import 'package:hope_app/shared/preferences.dart';

import '../providers/providers.dart';

class MaterialStockCard extends StatelessWidget {
  final DetalleStock stockMaterial;

  const MaterialStockCard({super.key, required this.stockMaterial});

  @override
  Widget build(BuildContext context) {
    print('Material: ${stockMaterial.descripcionMaterial}');
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      horizontalTitleGap: 10,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              Text(
                '${stockMaterial.numeroMaterial}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Preferences.isDarkMode
                      ? ThemeProvider.whiteColor
                      : ThemeProvider.lightColor,
                ),
              ),
            ],
          ),
        ],
      ),
      subtitle: Container(
        margin: const EdgeInsets.only(top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${stockMaterial.descripcionMaterial}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Preferences.isDarkMode
                    ? ThemeProvider.whiteColor
                    : ThemeProvider.lightColor,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Grupo: ${stockMaterial.grupoArticulo}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Preferences.isDarkMode ? Colors.grey : Colors.grey,
                  ),
                ),
                Text(
                  "Centro: ${stockMaterial.centro}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Preferences.isDarkMode ? Colors.grey : Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Stock Libre: ${stockMaterial.stockLibre}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Preferences.isDarkMode ? Colors.grey : Colors.grey,
                  ),
                ),
                Text(
                  "Stock Tránsito: ${stockMaterial.stockTransito}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Preferences.isDarkMode ? Colors.grey : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
