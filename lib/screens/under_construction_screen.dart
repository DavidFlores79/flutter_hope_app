import 'package:flutter/material.dart';

class UnderConstructionScreen extends StatelessWidget {
  static const String routeName = 'under_construction';

  const UnderConstructionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: FadeInImage(
              placeholder: AssetImage('assets/loading.gif'),
              image: AssetImage('assets/images/underconstruction.png'),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Text(
                  'Módulo en Desarrollo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'Anton',
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          )
        ],
      ),
    );
  }
}
