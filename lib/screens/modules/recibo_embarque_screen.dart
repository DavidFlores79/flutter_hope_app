import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';

import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations_rounded.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReciboEmbarqueScreen extends StatelessWidget {
  static String routeName = 'reciboembarque';

  const ReciboEmbarqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ReciboEmbarque(),
    );
  }
}

class ReciboEmbarque extends StatefulWidget {
  const ReciboEmbarque({super.key});

  @override
  State<ReciboEmbarque> createState() => _ReciboEmbarqueState();
}

class _ReciboEmbarqueState extends State<ReciboEmbarque> {
  @override
  void initState() {
    super.initState();
    final reciboEmbarqueProvider = context.read<ReciboEmbarqueProvider>();
    reciboEmbarqueProvider.getCatalogs();
  }

  @override
  Widget build(BuildContext context) {
    final reciboEmbarqueProvider = context.read<ReciboEmbarqueProvider>();

    return Consumer<ReciboEmbarqueProvider>(
      builder: (context, reciboEmbarqueProvider, _) {
        return (reciboEmbarqueProvider.isLoadingCatalogs)
            ? Center(
                child: SpinKitCubeGrid(
                  color: ThemeProvider.blueColor,
                ),
              )
            : // Aquí colocas el contenido del screen cuando isLoading es false
            const SearchEmbarques();
      },
    );
  }
}

class SearchEmbarques extends StatelessWidget {
  const SearchEmbarques({super.key});

  @override
  Widget build(BuildContext context) {
    final reciboEmbarqueProvider = Provider.of<ReciboEmbarqueProvider>(context);

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
                    provider: reciboEmbarqueProvider,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DatePicker(),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              MaterialButton(
                onPressed: (reciboEmbarqueProvider.isLoading)
                    ? null
                    : () async {
                        // if (!reciboEmbarqueProvider.isValidForm()) return;
                        FocusScope.of(context).unfocus();

                        //hacer la peticion al backend
                        final result =
                            await reciboEmbarqueProvider.searchEmbarques();
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
                  child: reciboEmbarqueProvider.isLoading
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
        (reciboEmbarqueProvider.isLoading)
            ? Expanded(
                child: Center(
                  child: SpinKitCubeGrid(
                    color: ThemeProvider.blueColor,
                  ),
                ),
              )
            : const EmbarquesList(),
      ],
    );
  }
}

class DatePicker extends StatefulWidget {
  DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final reciboEmbarqueProvider = Provider.of<ReciboEmbarqueProvider>(context);
    final DateTime now = DateTime.now();
    dateController.text = reciboEmbarqueProvider.fecha;

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
        reciboEmbarqueProvider.fecha = formattedDate;
        setState(() {});
      },
    );
  }
}

class EmbarquesList extends StatelessWidget {
  const EmbarquesList({super.key});

  @override
  Widget build(BuildContext context) {
    final reciboEmbarqueProvider = Provider.of<ReciboEmbarqueProvider>(context);

    return Expanded(
      child: ListView.builder(
        itemCount: reciboEmbarqueProvider.embarques!.length,
        itemBuilder: (context, index) {
          final embarque = reciboEmbarqueProvider.embarques![index];
          return ListTile(
            title: EmbarqueCard(embarque: embarque),
          );
        },
      ),
    );
  }
}

class EmbarqueCard extends StatelessWidget {
  final Embarque embarque;

  EmbarqueCard({super.key, required this.embarque});

  @override
  Widget build(BuildContext context) {
    const double divider = 5;
    final estatus =
        (embarque.estatusId == null) ? embarque.estatus : 'EN PROCESO';

    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, DescargaPalletsScreen.routeName, arguments: embarque);
      },
      minLeadingWidth: 120,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 25, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/icons/pallet.png', width: 100),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                        color: (embarque.estatus == 'EMBARCADO')
                            ? ThemeProvider.greyColor
                            : ThemeProvider.greenColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      '$estatus',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ThemeProvider.whiteColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: divider),
                CardItemLabelValue(
                    label: 'Entrega: ', value: '${embarque.entrega}'),
                const SizedBox(height: divider),
                CardItemLabelValue(
                    label: 'F.Entrega: ', value: '${embarque.fechaEntrega}'),
                const SizedBox(height: divider),
                CardItemLabelValue(
                    label: 'F.Picking: ', value: '${embarque.fechaPicking}'),
                const SizedBox(height: divider),
                CardItemLabelValue(
                    label: 'Centro: ', value: '${embarque.centro}'),
                (embarque.usuarioVerificador != '' &&
                        embarque.usuarioVerificador != null)
                    ? Column(
                        children: [
                          const SizedBox(height: divider),
                          CardItemLabelValue(
                              label: 'Verif.: ',
                              value: '${embarque.usuarioVerificador}'),
                        ],
                      )
                    : const SizedBox(),
                (embarque.claseTransporte != '' &&
                        embarque.claseTransporte != null)
                    ? Column(
                        children: [
                          const SizedBox(height: divider),
                          CardItemLabelValue(
                              label: 'Clase Transp: ',
                              value: '${embarque.claseTransporte}'),
                        ],
                      )
                    : const SizedBox(),
                (embarque.claseTransporte != '' &&
                        embarque.claseTransporte != null)
                    ? Column(
                        children: [
                          const SizedBox(height: divider),
                          CardItemLabelValue(
                              label: 'Cod.Transp: ',
                              value: '${embarque.codigoTransporte}'),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Text("Doc.Pedido:${pedido.documentoOc}"),
          const SizedBox(height: divider),
          Row(
            children: [
              Text(
                'Peso Plan: ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeProvider.blueColor),
              ),
              Text(
                '${embarque.pesoPlan}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeProvider.blueColor),
              ),
            ],
          ),
          const SizedBox(height: divider),
          Row(
            children: [
              Text(
                'Peso Neto: ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeProvider.blueColor),
              ),
              Text(
                '${embarque.pesoNeto}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeProvider.blueColor),
              ),
            ],
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

class CardItemLabelValue extends StatelessWidget {
  final String label;
  final String value;
  const CardItemLabelValue(
      {super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}
