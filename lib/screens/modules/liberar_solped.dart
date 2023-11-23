import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/models/solped_response.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LiberarSolpedScreen extends StatelessWidget {
  static const String routeName = 'liberarsolped';
  bool futureExecuted = false;

  @override
  Widget build(BuildContext context) {
    final liberarSolpedProvider = Provider.of<LiberarSolpedProvider>(context);
    final pedidos = liberarSolpedProvider.pedidos;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => liberarSolpedProvider.searchByDates(),
        child: FutureBuilder<List<Posicion>>(
          // Llamada al método async desde el Provider
          future: (futureExecuted != true)
              ? liberarSolpedProvider.searchByDates()
              : Future.value(pedidos),
          builder: (context, snapshot) {
            print('futureExecuted $futureExecuted');

            if (!snapshot.hasData) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 150),
                height: 250,
                child: const CupertinoActivityIndicator(),
              );
            }

            final List<Posicion> pedidos = snapshot.data!;
            futureExecuted = true;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: pedidos.map((posicion) {
                      return PositionSelectedCard(
                        material: posicion,
                        isSelected: false,
                      );
                    }).toList(),
                  ),
                ),
                ReleaseSolpedButton(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ReleaseSolpedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final liberarSolpedProvider = Provider.of<LiberarSolpedProvider>(context);

    return (liberarSolpedProvider.posicionesSelected.isNotEmpty)
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => validateSelected(liberarSolpedProvider),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(ThemeProvider.blueColor),
              ),
              child: Text(
                'Liberar',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: ThemeProvider.whiteColor),
              ),
            ),
          )
        : Container();
  }
}

validateSelected(LiberarSolpedProvider liberarSolpedProvider) {
  (liberarSolpedProvider.posicionesSelected.isNotEmpty)
      ? liberarSolpedProvider.liberarSolpeds()
      : Notifications.showSnackBar(
          "No se tienen posiciones seleccionadas para liberar.");
}
