import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ME21NMaterialSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar Material';

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
        final me21nProvider =
            Provider.of<ME21NProvider>(context, listen: false);
        me21nProvider.materialSelected = Materials();
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
    final me21nProvider = Provider.of<ME21NProvider>(context, listen: false);

    if (query.isEmpty) {
      return const emptyContainer();
    }

    me21nProvider.getMaterialsByQuery(query);

    return StreamBuilder(
      stream: me21nProvider.materialStream,
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
