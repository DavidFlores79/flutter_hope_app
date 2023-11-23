import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/solped_response.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations.dart';
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
            final List<int> idsSeleccionados =
                liberarSolpedProvider.posicionesSelected;
            futureExecuted = true;

            return (liberarSolpedProvider.isLoading)
                ? Center(
                    child: SpinKitCubeGrid(
                      color: ThemeProvider.blueColor,
                    ),
                  )
                : (pedidos.isEmpty)
                    ? const _emptyContainer()
                    : SolpedList(
                        pedidos: pedidos, idsSeleccionados: idsSeleccionados);
          },
        ),
      ),
    );
  }
}

class SolpedList extends StatelessWidget {
  const SolpedList({
    super.key,
    required this.pedidos,
    required this.idsSeleccionados,
  });

  final List<Posicion> pedidos;
  final List<int> idsSeleccionados;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: pedidos.map((posicion) {
              print('Posicion ${posicion.id}');
              return PositionSelectedCard(
                material: posicion,
                isSelected:
                    (idsSeleccionados.contains(posicion.id)) ? true : false,
              );
            }).toList(),
          ),
        ),
        Row(
          children: [
            RejectSolpedButton(),
            ReleaseSolpedButton(),
          ],
        ),
      ],
    );
  }
}

class ReleaseSolpedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final liberarSolpedProvider = Provider.of<LiberarSolpedProvider>(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => validateSelected(liberarSolpedProvider),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(ThemeProvider.blueColor),
          ),
          child: Text(
            'Liberar',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: ThemeProvider.whiteColor),
          ),
        ),
      ),
    );
  }
}

class RejectSolpedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final liberarSolpedProvider = Provider.of<LiberarSolpedProvider>(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => addRejectedMessage(
            liberarSolpedProvider,
            context,
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(ThemeProvider.redColor),
          ),
          child: Text(
            'Rechazar',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: ThemeProvider.whiteColor),
          ),
        ),
      ),
    );
  }

  addRejectedMessage(LiberarSolpedProvider liberarSolpedProvider, context) {
    liberarSolpedProvider.motivoRechazo = '';

    return (liberarSolpedProvider.posicionesSelected.isEmpty)
        ? Notifications.showSnackBar(
            "No existen posiciones seleccionadas. Favor de validar. **")
        : showDialog(
            context: context,
            builder: (BuildContext context) {
              return Form(
                key: liberarSolpedProvider.formKey,
                child: AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  title: const Text(
                    "Motivo de Rechazo",
                    textAlign: TextAlign.center,
                  ),
                  content: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    decoration: InputDecorations.authInputDecoration(
                      color: ThemeProvider.blueColor,
                      hintText: 'Describa el motivo del rechazo',
                      labelText: 'Motivo de Rechazo',
                      prefixIcon: FontAwesomeIcons.notEqual,
                    ),
                    onChanged: (value) =>
                        liberarSolpedProvider.motivoRechazo = value,
                    validator: (value) {
                      return (value != null && value.length >= 3)
                          ? null
                          : 'Debe escribir al menos 3 caracteres.';
                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (!liberarSolpedProvider.isValidForm()) return;
                        liberarSolpedProvider.rejectSolpeds();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Confirmar Rechazar",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}

validateSelected(LiberarSolpedProvider liberarSolpedProvider) {
  (liberarSolpedProvider.posicionesSelected.isNotEmpty)
      ? liberarSolpedProvider.releaseSolpeds()
      : Notifications.showSnackBar(
          "No existen posiciones seleccionadas. Favor de validar.");
}

class _emptyContainer extends StatelessWidget {
  final resultCount;
  const _emptyContainer({super.key, this.resultCount});

  @override
  Widget build(BuildContext context) {
    final liberarSolpedProvider = Provider.of<LiberarSolpedProvider>(context);

    return Center(
      child: GestureDetector(
        onTap: () => liberarSolpedProvider.searchByDates(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/modules/order-tracking.png'),
              width: 130,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Text(
                'No hay Solicitudes de Pedido disponibles.\nToca para refrescar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[400],
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
