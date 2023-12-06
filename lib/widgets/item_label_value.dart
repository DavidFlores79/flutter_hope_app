import 'package:flutter/material.dart';

class ItemLabelValue extends StatelessWidget {
  final String label;
  final String value;
  final int maxLines;

  const ItemLabelValue({super.key, required this.label, required this.value, this.maxLines = 2});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
            flex: 2,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              maxLines: maxLines,
            )),
      ],
    );
  }
}