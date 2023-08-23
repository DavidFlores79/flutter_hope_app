import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:provider/provider.dart';

class MigoScreen extends StatefulWidget {
  static const String routeName = 'entrada-mercancia';

  const MigoScreen({super.key});

  @override
  State<MigoScreen> createState() => _MigoScreenState();
}

class _MigoScreenState extends State<MigoScreen> {
  @override
  Widget build(BuildContext context) {
    final migoProvider = Provider.of<MigoProvider>(context);
    final Color myColor = ThemeProvider.lightColor;
    bool response = false;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Form(
              key: migoProvider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Text(
                    'Actividad',
                    style: TextStyle(
                      fontSize: 14,
                      color: myColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    alignment: AlignmentDirectional.center,
                    isExpanded: true,
                    value: migoProvider.actividadSelected,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    items: const [
                      DropdownMenuItem(
                          value: 'A01',
                          alignment: AlignmentDirectional.center,
                          child: Text('A01 - Entrada de Mercancías')),
                      DropdownMenuItem(
                          value: 'A07',
                          alignment: AlignmentDirectional.center,
                          child: Text('A07 - Salida de Mercancías')),
                    ],
                    onChanged: (value) {
                      // print(value);
                      migoProvider.actividadSelected = value ?? 'A01';
                    },
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Pedido: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: myColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    autocorrect: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) => migoProvider.numero_pedido = value,
                    validator: (value) {
                      return (value != null && value.length == 10)
                          ? null
                          : 'Debe contener 10 numeros.';
                    },
                  ),
                  const SizedBox(height: 35),
                  (migoProvider.isLoading)
                      ? Center(
                          child: CircularProgressIndicator(
                            color: ThemeProvider.blueColor,
                          ),
                        )
                      : MaterialButton(
                          onPressed: migoProvider.isLoading
                              ? null
                              : () async {
                                  if (!migoProvider.isValidForm()) return;
                                  FocusScope.of(context).unfocus();

                                  //hacer la peticion al backend
                                  //DEV: 4500002493
                                  //QA: 4500087697
                                  response = await migoProvider
                                      .getPedido(migoProvider.numero_pedido);
                                },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          disabledColor: Colors.grey[500],
                          elevation: 0,
                          color: myColor,
                          minWidth: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Text(
                              migoProvider.isLoading
                                  ? 'Espere'
                                  : 'Buscar Pedido',
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            (migoProvider.result)
                ? PedidoBox(
                    pedido: migoProvider.pedido,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class PedidoBox extends StatelessWidget {
  PedidoMigo pedido;

  PedidoBox({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Text(pedido.cabeceraPedido.numeroPedido),
        const SizedBox(height: 25),
        Text(pedido.cabeceraPedido.numeroPedido),
        const SizedBox(height: 25),
        Text('${pedido.posiciones.length.toString()} Posicion(es)'),
      ],
    );
  }
}
