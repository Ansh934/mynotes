import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/show_error_dialog.dart';
import 'package:mynotes/utilities/dialogs/show_password_reset_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            await showPasswordResetSentDialog(context);
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              "The email address is not valid",
            );
          } else if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              "There is no user corresponding to the given email",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Authentication error',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 140,
          centerTitle: true,
          title: const Text(
            'Forgot Password',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(children: [
            const Text(
                'If you forgot your password, simply enter your email and we will send you a password reset link'),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              enableSuggestions: false,
              controller: _controller,
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
            FilledButton(
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPassword(email: email));
                },
                child: const Text('Send')),
            FilledButton.tonal(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text('Back to login page')),
          ]),
        ),
      ),
    );
  }
}
