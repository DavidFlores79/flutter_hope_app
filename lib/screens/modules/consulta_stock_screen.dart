import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ConsultaStockScreen extends StatefulWidget {
  static const String routeName = 'consultastock';

  const ConsultaStockScreen({super.key});

  @override
  State<ConsultaStockScreen> createState() => _ConsultaStockScreenState();
}

class _ConsultaStockScreenState extends State<ConsultaStockScreen> {
  bool _dialogShown = false;

  @override
  void initState() {
    print('initState');
    final consultaStockProvider = context.read<ConsultaStockProvider>();
    // consultaStockProvider.getCatalogs();
    consultaStockProvider.materials = [];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();

    // Llamamos a showDialog dentro de didChangeDependencies
    if (!_dialogShown) {
      _dialogShown = true;
      Future.delayed(Duration.zero, () {
        consultaStockModal(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final consultaStockProvider = Provider.of<ConsultaStockProvider>(context);
    final materials = consultaStockProvider.materials;
    return Scaffold(
      body: (materials!.isEmpty && !consultaStockProvider.isLoading)
          ? Center(
              child: EmptyContainer(
                assetImage: 'assets/images/modules/order-tracking.png',
                text: "Sin resultados",
              ),
            )
          : Column(
              children: [
                (!consultaStockProvider.isLoading)
                    ? Container(
                      decoration: BoxDecoration(
                        color: ThemeProvider.blueColor
                      ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),
                        child: Text(
                          'Búsqueda de materiales del centro ${consultaStockProvider.centroDefault}. Se encontraron ${materials.length} resultados',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500, color: ThemeProvider.whiteColor),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: ListView.builder(
                    itemCount: materials.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MaterialStockCard(
                          stockMaterial: materials![index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
