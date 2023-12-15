import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations_rounded.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';

class InventarioTiendaScreen extends StatelessWidget {
  static const String routeName = 'inventariotienda';

  const InventarioTiendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: InventarioTienda(),
    );
  }
}

class InventarioTienda extends StatefulWidget {
  const InventarioTienda({super.key});

  @override
  State<InventarioTienda> createState() => _InventarioTiendaState();
}

class _InventarioTiendaState extends State<InventarioTienda> {
  @override
  void initState() {
    super.initState();
    final inventarioTiendaProvider = context.read<InventarioTiendaProvider>();
    inventarioTiendaProvider.getCatalogs();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<InventarioTiendaProvider>(
      builder: (context, inventarioTiendaProvider, _) {
        return (inventarioTiendaProvider.isLoadingCatalogs)
            ? Center(
                child: SpinKitCubeGrid(
                  color: ThemeProvider.blueColor,
                ),
              )
            : // Aquí colocas el contenido del screen cuando isLoading es false
            const SearchInventario();
      },
    );
  }
}

class SearchInventario extends StatelessWidget {
  const SearchInventario({super.key});

  @override
  Widget build(BuildContext context) {
    final inventarioTiendaProvider = Provider.of<InventarioTiendaProvider>(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 15,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: (Preferences.isDarkMode)
                ? ThemeProvider.lightColor
                : ThemeProvider.whiteColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CentrosUsuarioDrop(
                    provider: inventarioTiendaProvider,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InventarioDatePicker(),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              MaterialButton(
                onPressed: (inventarioTiendaProvider.isLoading || inventarioTiendaProvider.centrosUsuario!.isEmpty)
                    ? null
                    : () async {
                        // if (!inventarioTiendaProvider.isValidForm()) return;
                        FocusScope.of(context).unfocus();

                        //hacer la peticion al backend
                        final result = await inventarioTiendaProvider.searchInventory();
                        print('Result $result');
                      },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: ThemeProvider.blueColor.withAlpha(150),
                elevation: 0,
                color: ThemeProvider.blueColor,
                minWidth: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: inventarioTiendaProvider.isLoading
                      ? const CupertinoActivityIndicator()
                      : const Text(
                          'Buscar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
        (inventarioTiendaProvider.isLoading)
            ? Expanded(
                child: Center(
                  child: SpinKitCubeGrid(
                    color: ThemeProvider.blueColor,
                  ),
                ),
              )
            : Center(
              child: Text('Lista'),
            ),
      ],
    );
  }
}

class InventarioDatePicker extends StatefulWidget {
  InventarioDatePicker({super.key});

  @override
  State<InventarioDatePicker> createState() => _InventarioDatePickerState();
}

class _InventarioDatePickerState extends State<InventarioDatePicker> {
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final inventarioTiendaProvider = Provider.of<InventarioTiendaProvider>(context);
    final DateTime now = DateTime.now();
    dateController.text = inventarioTiendaProvider.fecha;

    return TextFormField(
      controller: dateController,
      readOnly: true,
      decoration: InputDecorationsRounded.authInputDecorationRounded(
        hintText: 'Fecha',
        labelText: 'Fecha',
        color: ThemeProvider.blueColor,
      ),
      textAlign: TextAlign.center,
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          locale: const Locale('es'),
          context: context,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: now,
          firstDate: DateTime(now.year, 1, 1),
          lastDate: DateTime(now.year, 12, 31),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: ThemeProvider
                          .blueColor, // Cambia el color primario al azul
                      onPrimary: Colors
                          .white, // Cambia el color del texto sobre el color primario
                    ),
                buttonTheme: const ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
              ),
              child: child!,
            );
          },
        );

        if (selectedDate == null) {
          return; // Si se cancela la selección
        }

        var formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        dateController.text = formattedDate;
        print('Selected Date: $formattedDate');
        inventarioTiendaProvider.fecha = formattedDate;
        setState(() {});
      },
    );
  }
}
