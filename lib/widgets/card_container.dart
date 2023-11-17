import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:provider/provider.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: (loginForm.isLoading)
          ? Center(
              child: SpinKitCubeGrid(
                color: ThemeProvider.whiteColor,
              ),
            )
          : Container(
              width: (size.width > 767) ? 400 : double.infinity,
              decoration: _CardShape(),
              padding: const EdgeInsets.all(20),
              child: child,
            ),
    );
  }

  BoxDecoration _CardShape() => BoxDecoration(
          color: Preferences.isDarkMode
              ? const Color.fromRGBO(35, 35, 35, 1)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Colors.black87, blurRadius: 20, offset: Offset(0, 5))
          ]);
}
