import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';

class ActivationScreen extends StatelessWidget {
  static const String routeName = 'activation';

  const ActivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activationService = Provider.of<ActivationService>(context);

    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

    final Map<String, dynamic> formValues = {
      "codigo": "",
    };

    return Scaffold(
      backgroundColor: ThemeProvider.lightColor,
      body: Center(
        child: FutureBuilder(
          future: activationService.isLicenseExpired(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator.adaptive();
            final isLicenseExpired = snapshot.data ?? true;

            if (isLicenseExpired) {
              print('licencia vencida');
              return SingleChildScrollView(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Column(
                  children: [
                    const Image(
                      image: AssetImage('assets/hope-logo.png'),
                      width: 150,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Código de Activación Requerido',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Barlow',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Form(
                      key: myFormKey,
                      child: Column(
                        children: [
                          CustomInputField(
                            hintText: '4 Caracteres',
                            labelText: 'Introduzca su Código',
                            // suffixIcon: FontAwesomeIcons.carRear,
                            keyboardType: TextInputType.text,
                            formProperty: 'codigo',
                            formValues: formValues,
                            textCapitalization: TextCapitalization.characters,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 17, 92, 153)),
                            ),
                            onPressed: () {
                              // ignore: todo
                              // TODO: Imprimir valores del formulario
                              FocusScope.of(context).requestFocus(
                                  FocusNode()); //ocultar el teclado del movil

                              if (!myFormKey.currentState!.validate()) {
                                return;
                              }
                              print(formValues);

                              final result = Provider.of<ActivationService>(
                                      context,
                                      listen: false)
                                  .getLicence(formValues['codigo']);

                              result.then((value) {
                                print('Resultado: $value');
                                if (value == true) {
                                  Future.microtask(
                                    () {
                                      Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  const AuthTokenScreen(),
                                              transitionDuration:
                                                  const Duration(seconds: 0)));
                                    },
                                  );
                                }
                                return;
                              });
                            },
                            child: const SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: Text('Activar'),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
            } else {
              Future.microtask(
                () {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const AuthTokenScreen(),
                          transitionDuration: const Duration(seconds: 0)));
                },
              );
            }

            return Container();
          }),
        ),
      ),
    );
  }
}
