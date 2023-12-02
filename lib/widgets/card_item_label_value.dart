import 'package:flutter/material.dart';

class CardItemLabelValue extends StatelessWidget {
  final String label;
  final String value;
  const CardItemLabelValue(
      {super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}