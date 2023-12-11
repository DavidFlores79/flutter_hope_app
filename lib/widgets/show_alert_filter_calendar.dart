import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/providers/theme_provider.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/widgets/date_container.dart';

Future showDatesModal(BuildContext context, ChangeNotifier provider) {
  bool isLoading = (provider as dynamic).isLoading;

  return showDialog(
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      final size = MediaQuery.of(context).size;

      return (isLoading)
          ? Center(
              child: SpinKitCubeGrid(
                color: ThemeProvider.blueColor,
              ),
            )
          : AlertDialog(
              backgroundColor: (Preferences.isDarkMode)
                  ? ThemeProvider.lightColor
                  : ThemeProvider.whiteColor,
              title: const Text('Buscar'),
              content: Container(
                  constraints: BoxConstraints(
                      maxHeight: size.height *
                          .5), // Establece la altura máxima según tus necesidades
                  child: SingleChildScrollView(
                    child: DateContainer(
                        provider: provider,
                        hintText1: "Fecha inicio",
                        labelText1: "Fecha inicio",
                        hintText2: "Fecha fin",
                        labelText2: "Fecha fin"),
                  )),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ThemeProvider.lightRed,
                        disabledForegroundColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: Size((size.width / 5), 20),
                        foregroundColor: Colors.white,
                        backgroundColor: ThemeProvider.blueColor,
                        disabledForegroundColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                      ),
                      onPressed: () async {
                        try {
                          await (provider as dynamic).searchByDates();
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // Resto de tu lógica con el resultado
                        } catch (error) {
                          print('Error al obtener Solpeds: $error');
                          // Manejar el error según sea necesario
                        }
                      },
                      child: const Text('Buscar'),
                    ),
                  ],
                )
              ],
            );
    },
  );
}

Future showDatesModalMiro(BuildContext context, ChangeNotifier provider) {
  bool isLoading = (provider as dynamic).isLoading;

  return showDialog(
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      final size = MediaQuery.of(context).size;

      return (isLoading)
          ? Center(
              child: SpinKitCubeGrid(
                color: ThemeProvider.blueColor,
              ),
            )
          : AlertDialog(
              backgroundColor: (Preferences.isDarkMode)
                  ? ThemeProvider.lightColor
                  : ThemeProvider.whiteColor,
              title: const Text('Editar Fechas'),
              content: Container(
                  constraints: BoxConstraints(
                      maxHeight: size.height *
                          .5), // Establece la altura máxima según tus necesidades
                  child: SingleChildScrollView(
                    child: DateContainer(
                        provider: provider,
                        hintText1: "Fecha Factura",
                        labelText1: "Fecha Factura",
                        hintText2: "Fecha Contabilización",
                        labelText2: "Fecha Contabilización"),
                  )),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ThemeProvider.lightRed,
                        disabledForegroundColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cerrar'),
                    ),
                  ],
                )
              ],
            );
    },
  );
}
