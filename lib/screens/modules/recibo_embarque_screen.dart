import 'package:flutter/material.dart';
import 'package:hope_app/models/centros.dart';
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

class ReciboEmbarque extends StatelessWidget {
  const ReciboEmbarque({super.key});

  @override
  Widget build(BuildContext context) {
    final reciboEmbarqueProvider = Provider.of<ReciboEmbarqueProvider>(context);

    return Container(
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
                    if (!reciboEmbarqueProvider.isValidForm()) return;
                    reciboEmbarqueProvider.isLoading = true;
                    FocusScope.of(context).unfocus();

                    //hacer la peticion al backend
                    final result =
                        await reciboEmbarqueProvider.searchEmbarques();

                    print('Result $result');
                  },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: ThemeProvider.blueColor,
            minWidth: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Text(
                reciboEmbarqueProvider.isLoading ? 'Espere' : 'Buscar',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
      ),
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
