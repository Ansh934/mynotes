import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

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
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 8,
              right: 8,
            ),
            child: TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: "Enter your email",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 8.0,
            ),
            child: TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: "Enter your password",
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                if (AuthService.firebase().currentUser?.isEmailVerified ??
                    false) {
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false,
                    );
                  }
                } else {
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (route) => false,
                    );
                  }
                }
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
