import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/auth_service.dart';
import 'package:hope_app/ui/input_decorations.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginScreen extends StatelessWidget {
  static const String routeName = 'login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final oneSignalProvider = Provider.of<OneSignalProvider>(context);
    if (!kIsWeb && !Platform.isWindows) {
      oneSignalProvider.initOneSignal(context);
    }

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CardContainer(
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700]),
                    ),
                    // _LoginForm(),
                    ChangeNotifierProvider(
                      create: (context) => LoginFormProvider(),
                      child: const _LoginForm(),
                    ),
                    // _newAccountButton(),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _newAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(const StadiumBorder()),
      ),
      onPressed: () => Navigator.pushReplacementNamed(
        context,
        RegisterScreen.routeName,
      ),
      child: Text(
        'Crear nueva cuenta',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final Color myColor = ThemeProvider.blueColor;
    final mp = Provider.of<NavbarProvider>(context);
    final oneSignalProvider = Provider.of<OneSignalProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final pedidosProvider =
        Provider.of<PedidosProvider>(context, listen: false);

    if (!kIsWeb && !Platform.isWindows) {
      Timer(
        const Duration(seconds: 10),
        () => oneSignalProvider.setOneSignalId(),
      );
    }

    return Form(
      key: loginForm.formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textCapitalization: TextCapitalization.none,
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
                color: myColor,
                hintText: 'john.doe',
                labelText: 'Nickname',
                prefixIcon: Icons.person_outline),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              return (value != null) ? null : 'Nickname inválido.';
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecorations.authInputDecoration(
                color: myColor,
                hintText: 'Mínimo 8 caracteres',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outlined),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 8)
                  ? null
                  : 'Contraseña inválida.';
            },
          ),
          const SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;
                    FocusScope.of(context).unfocus();

                    //hacer la peticion al backend para validar usuario
                    final String? loginMessage = await authService.loginUser(
                        loginForm.email, loginForm.password);

                    if (loginMessage == 'true') {
                      oneSignalProvider.saveUpdateId();
                      final result = await pedidosProvider.getOrdenes();
                      print('EL RESULTADO!!!!!!!!! $result');
                      mp.items.elementAt(1).enabled = result;
                      Future.microtask(
                        () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const HomeScreen(),
                              transitionDuration: const Duration(seconds: 0),
                            ),
                          );
                        },
                      );
                    } else {
                      Notifications.showSnackBar(loginMessage.toString());
                      loginForm.isLoading = false;
                    }
                  },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: ThemeProvider.blueColor.withAlpha(150),
            elevation: 0,
            color: myColor,
            minWidth: MediaQuery.of(context).size.width * 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: loginForm.isLoading
                  ? const CupertinoActivityIndicator()
                  : const Text(
                      'Iniciar Sesión',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
