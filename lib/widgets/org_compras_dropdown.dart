import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:provider/provider.dart';

class OrgComprasDropdown extends StatelessWidget {
  ChangeNotifier provider;

  OrgComprasDropdown({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    String orgComprasSelected = (provider as dynamic).orgComprasSelected;
    List<OrgCompras> orgCompras = (provider as dynamic).orgCompras;
    
    return Expanded(
      child: DropdownButtonFormField(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Org. Compras',
          labelStyle: TextStyle(
            color: ThemeProvider.lightColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ThemeProvider.blueColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: ThemeProvider.blueColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ThemeProvider.blueColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
        ),
        focusColor: ThemeProvider.blueColor,
        value: orgComprasSelected,
        onChanged: (String? newValue) {
          orgComprasSelected = newValue!;
        },
        items: orgCompras.map<DropdownMenuItem<String>>((OrgCompras value) {
          return DropdownMenuItem<String>(
            value: value.code,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                value.name!,
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}