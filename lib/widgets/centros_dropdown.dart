import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import '../providers/providers.dart';

class CentrosUsuarioDrop extends StatelessWidget {
  final ChangeNotifier provider;

  const CentrosUsuarioDrop({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    
    final List<Centros> centrosUsuario = (provider as dynamic).centrosUsuario;
    final String centroDefault = (provider as dynamic).centroDefault;

    return Expanded(
      child: DropdownButtonFormField(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Centros',
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
        value: centroDefault,
        onChanged:  (String? newValue) {
                (provider as dynamic).centroDefault = newValue!;
              }
            ,
        items: centrosUsuario.map<DropdownMenuItem<String>>((Centros value) {
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
      ),
    );
  }
}