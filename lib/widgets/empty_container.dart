import 'package:flutter/material.dart';

class EmptyContainer extends StatelessWidget {
  String assetImage;
  String text;
  EmptyContainer({super.key, required this.assetImage, required this.text});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(assetImage),
            width:
                size.width < size.height ? size.width * .40 : size.width * .12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[400],
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
