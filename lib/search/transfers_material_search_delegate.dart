import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class TransferMaterialSearchDelegate extends SearchDelegate {
  final bool esDE;

  TransferMaterialSearchDelegate({required this.esDE});

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
    final materialProvider = Provider.of<MaterialProvider>(context, listen: false);
    
    if (query.isEmpty) {
      return const emptyContainer();
    }

    materialProvider.getTransferMaterialsByQuery(query, esDE);

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
