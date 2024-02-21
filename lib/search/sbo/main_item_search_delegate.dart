import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MainItemSearchDelegate extends SearchDelegate {
  final String moduleName;

  MainItemSearchDelegate(this.moduleName);

  @override
  String get searchFieldLabel => 'Buscar Artículo';

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
        final itemProvider =
            Provider.of<SBOItemProvider>(context, listen: false);
        itemProvider.itemSelected = SBO_Item();
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
    final itemProvider = Provider.of<SBOItemProvider>(context, listen: false);

    if (query.isEmpty) {
      return const emptyContainer();
    }

    itemProvider.getItemsByQuery(query, moduleName);

    return StreamBuilder(
      stream: itemProvider.itemStream,
      builder: (context, AsyncSnapshot<List<SBO_Item>> snapshot) {
        if (!snapshot.hasData) {
          return const emptyContainer();
        }

        final List<SBO_Item> items = snapshot.data!;

        return (items.isEmpty)
            ? emptyContainer(resultCount: items)
            : ItemSearchList(items: items);
      },
    );
  }
}
