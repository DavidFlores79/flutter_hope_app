import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/ui/input_decorations_rounded.dart';
import 'package:intl/intl.dart';

class DateContainer extends StatefulWidget {
  final String hintText1;
  final String labelText1;
  final String hintText2;
  final String labelText2;
  final ChangeNotifier provider;
  const DateContainer(
      {super.key,
      required this.provider,
      required this.hintText1,
      required this.labelText1,
      required this.hintText2,
      required this.labelText2});

  @override
  State<DateContainer> createState() => DateContainerState();
}

class DateContainerState extends State<DateContainer> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dateController2 = TextEditingController();
  String fechaInicio = "";
  final fechaFin = "";

  dynamic dynamicProvider;
  @override
  void initState() {
    super.initState();
    dynamic dynamicProvider = widget.provider;
    _dateController.text = dynamicProvider.fecha1;
    print("fecha1${_dateController.text}");
    _dateController2.text = dynamicProvider.fecha2;
    print("fecha2${_dateController2.text}");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      // Configura el color del fondo del Card
      child: Column(children: [
        SizedBox(
          width: size.width * .58,
          child: TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: InputDecorationsRounded.authInputDecorationRounded(
              hintText: widget.hintText1,
              labelText: widget.labelText1,
              suffixIcon: Icons.calendar_month,
              color: ThemeProvider.blueColor,
            ),
            textAlign: TextAlign.center,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                locale: const Locale('es'),
                context: context,
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                initialDate:
                    DateFormat('yyyy-MM-dd').parse(_dateController.text),
                firstDate: DateTime(1950),
                lastDate: DateFormat('yyyy-MM-dd').parse(_dateController2.text),
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

              setState(() {
                var formattedDate =
                    DateFormat('yyyy-MM-dd').format(selectedDate);
                // print('Fecha seleccionada: ${formattedDate.toString()}');
                dynamic dynamicProvider = widget.provider;
                _dateController.text = formattedDate;
                dynamicProvider.fecha1 = formattedDate;
                // print("new valor ${dynamicProvider.start}");
              });
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: size.width * .58,
          child: TextFormField(
            controller: _dateController2,
            readOnly: true,
            decoration: InputDecorationsRounded.authInputDecorationRounded(
              hintText: widget.hintText2,
              labelText: widget.labelText2,
              suffixIcon: Icons.calendar_month,
              color: ThemeProvider.blueColor,
            ),
            textAlign: TextAlign.center,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                locale: const Locale('es'),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                initialDate:
                    DateFormat('yyyy-MM-dd').parse(_dateController2.text),
                firstDate: DateFormat('yyyy-MM-dd').parse(_dateController.text),
                lastDate: DateTime(2025),
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

              setState(() {
                var formattedDate2 =
                    DateFormat('yyyy-MM-dd').format(selectedDate);
                dynamic dynamicProvider = widget.provider;
                _dateController2.text = formattedDate2;
                dynamicProvider.fecha2 = formattedDate2;
                // dynamicProvider.end = _dateController2.text;
              });
            },
          ),
        ),
      ]),
    );
  }
}
