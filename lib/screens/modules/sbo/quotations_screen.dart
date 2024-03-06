import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:provider/provider.dart';

class QuotationsScreen extends StatelessWidget {
  static const String routeName = 'sbo-quotations';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Quotations(),
    );
  }
}

class Quotations extends StatefulWidget {
  const Quotations({Key? key}) : super(key: key);

  @override
  State<Quotations> createState() => _QuotationsState();
}

class _QuotationsState extends State<Quotations> {
  @override
  void initState() {
    super.initState();
    final quotationsProvider = context.read<QuotationsProvider>();
    quotationsProvider.getCatalogs();
  }

  @override
  Widget build(BuildContext context) {
    final quotationsProvider = Provider.of<QuotationsProvider>(context);

    return RefreshIndicator(
      onRefresh: () => quotationsProvider.getCatalogs(),
      child: Consumer<QuotationsProvider>(
        builder: (context, quotationsProvider, _) {
          return (quotationsProvider.isLoading)
              ? Center(
                  child: SpinKitCubeGrid(
                    color: ThemeProvider.blueColor,
                  ),
                )
              : // Aquí colocas el contenido del screen cuando isLoading es false
              Container(
                  child: Center(
                    child: Text('Hola mundo desde Quotations'),
                  ),
                );
        },
      ),
    );
  }
}
