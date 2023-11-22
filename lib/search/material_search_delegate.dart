import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:provider/provider.dart';

class MaterialSearchDelegate extends SearchDelegate {
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
        final solpedProvider =
            Provider.of<SolpedProvider>(context, listen: false);
        solpedProvider.materialSelected = Materials();
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
    final solpedProvider = Provider.of<SolpedProvider>(context, listen: false);

    if (query.isEmpty) {
      return const emptyContainer();
    }

    solpedProvider.getMaterialsByQuery(query);

    // return FutureBuilder(
    return StreamBuilder(
      // future: appointmentProv.searchUsers(query),
      stream: solpedProvider.materialStream,
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

class emptyContainer extends StatelessWidget {
  final resultCount;
  const emptyContainer({super.key, this.resultCount});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/images/modules/order-tracking.png'),
            width: 130,
          ),
          const SizedBox(height: 15),
          (resultCount != null)
              ? Text(
                  'Sin resultados de búsqueda.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[400],
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class MaterialSearchList extends StatelessWidget {
  final List<Materials> materials;
  const MaterialSearchList({super.key, required this.materials});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: materials.length,
      itemBuilder: (BuildContext context, int index) {
        final Materials material = materials[index];

        return MaterialCard(material: material);
      },
    );
  }
}

class MaterialCard extends StatelessWidget {
  final Materials material;

  const MaterialCard({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    final solpedProvider = Provider.of<SolpedProvider>(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      horizontalTitleGap: 10,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              Text(
                '${material.numeroMaterial}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Preferences.isDarkMode
                      ? ThemeProvider.whiteColor
                      : ThemeProvider.lightColor,
                ),
              ),
            ],
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${material.textoBreve}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Preferences.isDarkMode
                  ? ThemeProvider.whiteColor
                  : ThemeProvider.lightColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "UME: ${material.umeComercial}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Preferences.isDarkMode ? Colors.grey : Colors.grey,
                ),
              ),
              Text(
                "Gpo.Comp.: ${material.grupoCompras}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Preferences.isDarkMode ? Colors.grey : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        padding: EdgeInsets.zero,
        icon: FaIcon(
          FontAwesomeIcons.plus,
          color: ThemeProvider.blueColor,
        ),
        onPressed: () {
          print('Material Selected: ${material.textoBreve}');
          solpedProvider.materialSelected = material;
          Navigator.pop(context);
        },
      ),
    );
  }
}
