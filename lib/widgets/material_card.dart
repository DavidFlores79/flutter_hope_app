import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class MaterialCard extends StatelessWidget {
  final Materials material;

  const MaterialCard({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    final solpedProvider = Provider.of<SolpedProvider>(context);
    final me21Provider = Provider.of<ME21NProvider>(context);

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
                '${material.numeroMaterial}',
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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${material.textoBreve}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Preferences.isDarkMode
                  ? ThemeProvider.whiteColor
                  : ThemeProvider.lightColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "UME: ${material.umeComercial}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Preferences.isDarkMode ? Colors.grey : Colors.grey,
                ),
              ),
              Text(
                "Gpo.Comp.: ${material.grupoCompras}",
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
      trailing: IconButton(
        padding: EdgeInsets.zero,
        icon: FaIcon(
          FontAwesomeIcons.plus,
          color: ThemeProvider.blueColor,
        ),
        onPressed: () {
          print('Material Selected: ${material.textoBreve}');
          solpedProvider.materialSelected = material;
          me21Provider.materialSelected = material;
          Navigator.pop(context);
        },
      ),
    );
  }
}
