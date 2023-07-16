import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/utilities/dialogs/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 140,
        centerTitle: true,
        title: const Text(
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
            "Login"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
              left: 24,
              right: 24,
              bottom: 8,
            ),
            child: TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  prefixIconColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.focused)) {
                      return Theme.of(context).colorScheme.primary;
                    }
                    if (states.contains(MaterialState.error)) {
                      return Theme.of(context).colorScheme.error;
                    }
                    return Theme.of(context).colorScheme.onSurface;
                  }),
                  hintText: "Enter your email",
                  border: const OutlineInputBorder(),
                  labelText: 'Email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 8,
            ),
            child: TextFormField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password_outlined),
                  prefixIconColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.focused)) {
                      return Theme.of(context).colorScheme.primary;
                    }
                    if (states.contains(MaterialState.error)) {
                      return Theme.of(context).colorScheme.error;
                    }
                    return Theme.of(context).colorScheme.onSurface;
                  }),
                  hintText: "Enter your password",
                  border: const OutlineInputBorder(),
                  labelText: 'Password'),
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                context.read<AuthBloc>().add(AuthEventLogIn(
                      email,
                      password,
                    ));
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  "User not found",
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  "Wrong Password",
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  "Invalid email",
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  "Authentication Error",
                );
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.primaryContainer)),
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Not registered yet? Click here"),
          )
        ],
      ),
    );
  }
}
