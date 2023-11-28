import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/widgets/widgets.dart';

class SupplierSearchList extends StatelessWidget {
  final List<Supplier> suppliers;
  const SupplierSearchList({super.key, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suppliers.length,
      itemBuilder: (BuildContext context, int index) {
        final Supplier supplier = suppliers[index];

        return SupplierCard(supplier: supplier);
      },
    );
  }
}
