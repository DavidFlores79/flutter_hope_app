import 'package:flutter/material.dart';

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
