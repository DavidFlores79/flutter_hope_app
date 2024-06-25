import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SupplierMaterialSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar Material Prov';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        final materialProvider =
            Provider.of<MaterialProvider>(context, listen: false);
        materialProvider.materialSelected = Materials();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return const Text('Build Results!!');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final materialProvider =
        Provider.of<MaterialProvider>(context, listen: false);
    final supplierProvider =
        Provider.of<SupplierProvider>(context, listen: false);
    final me21nProvider = Provider.of<ME21NProvider>(context, listen: false);

    if (query.isEmpty) {
      return const emptyContainer();
    }

    if (supplierProvider.supplierSelected.numeroProveedor == null) {
      Notifications.showSnackBar(
          'El proveedor no ha sido seleccionado aun. No se pueden realizar búsquedas de material sin proveedor.');
    } else {
      materialProvider.getMaterialsBySupplierQuery(
          query,
          supplierProvider.supplierSelected.numeroProveedor!,
          me21nProvider.centroDefault);
    }

    return StreamBuilder(
      stream: materialProvider.materialStream,
      builder: (context, AsyncSnapshot<List<Materials>> snapshot) {
        if (!snapshot.hasData) {
          return const emptyContainer();
        }

        final List<Materials> materials = snapshot.data!;
        print('Cuantos: ${materials.length}');
        return (materials.isEmpty)
            ? emptyContainer(resultCount: materials)
            : MaterialSearchList(materials: materials);
      },
    );
  }
}
