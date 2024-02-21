import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:provider/provider.dart';

class ItemSearchList extends StatelessWidget {
  final List<SBO_Item> items;
  const ItemSearchList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final SBO_Item item = items[index];

        return ItemCard(item: item);
      },
    );
  }
}

class ItemCard extends StatelessWidget {
  final SBO_Item item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final purchaseRequestProvider =
        Provider.of<PurchaseRequestProvider>(context);

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
                '${item.itemCode}',
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
            '${item.itemName}',
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
                "UME: ${item.inventoryUOM}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Preferences.isDarkMode ? Colors.grey : Colors.grey,
                ),
              ),
              Text(
                "Producción: ${item.inCostRollup}",
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
          print('Artículo Selected: ${item.itemName}');
          purchaseRequestProvider.itemSelected = item;
          Navigator.pop(context);
        },
      ),
    );
  }
}
