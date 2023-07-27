import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateShouldRegister) {
          if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              "There already exists an account with the given email address",
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              "The email address is not valid",
            );
          } else if (state.exception is OperationNotAllowedAuthException) {
            await showErrorDialog(
              context,
              "email/password accounts are not enabled",
            );
          } else if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              "The password is not strong enough",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              "Authentication Error",
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 140,
          centerTitle: true,
          title: const Text(
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              "Register"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(
                height: 8.0,
              ),
              TextField(
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
              const SizedBox(
                height: 8.0,
              ),
              TextField(
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
              const SizedBox(
                height: 8.0,
              ),
              FilledButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventRegister(
                          email,
                          password,
                        ),
                      );
                },
                child: const Text("Register"),
              ),
              OutlinedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text("Goto Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
