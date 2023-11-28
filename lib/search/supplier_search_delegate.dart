import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SupplierSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar Proveedor';

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
        final supplierProvider = Provider.of<SupplierProvider>(context, listen: false);
        supplierProvider.supplierSelected = Supplier();
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
    final supplierProvider = Provider.of<SupplierProvider>(context, listen: false);

    if (query.isEmpty) {
      return const emptyContainer();
    }

    supplierProvider.getSupplierByQuery(query);

    return StreamBuilder(
      stream: supplierProvider.supplierStream,
      builder: (context, AsyncSnapshot<List<Supplier>> snapshot) {
        if (!snapshot.hasData) {
          return const emptyContainer();
        }

        final List<Supplier> suppliers = snapshot.data!;
        print('Cuantos: ${suppliers.length}');
        return (suppliers.isEmpty)
            ? emptyContainer(resultCount: suppliers)
            : SupplierSearchList(suppliers: suppliers);
      },
    );
  }
}
