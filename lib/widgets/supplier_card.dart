import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class SupplierCard extends StatelessWidget {
  final Supplier supplier;

  const SupplierCard({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {

    final supplierProvider = Provider.of<SupplierProvider>(context);

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
                '${supplier.numeroProveedor}',
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
            '${supplier.nombres}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Preferences.isDarkMode
                  ? ThemeProvider.whiteColor
                  : ThemeProvider.lightColor,
            ),
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
          print('Proveedor Selected: ${supplier.nombres}');
          
          supplierProvider.supplierSelected = supplier;
          Navigator.pop(context);
        },
      ),
    );
  }
}
