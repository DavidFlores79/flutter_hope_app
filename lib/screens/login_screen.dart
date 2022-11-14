import 'package:flutter/material.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/ui/notifications.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'login';

  @override
  Widget build(BuildContext context) {
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
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width80 = (size.width * 0.15);
    final loginForm = Provider.of<LoginFormProvider>(context);
    final Color myColor = Color.fromARGB(255, 17, 92, 153);

    return Container(
      child: Form(
          key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
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
                        final authService =
                            Provider.of<AuthService>(context, listen: false);
                        final String? errorMessage = await authService
                            .loginUser(loginForm.email, loginForm.password);

                        if (errorMessage == null) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(
                            context,
                            HomeScreen.routeName,
                          );
                        } else {
                          Notifications.showSnackBar(errorMessage);
                          loginForm.isLoading = false;
                        }
                      },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: myColor,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: width80, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Espere' : 'Iniciar Sesión',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
