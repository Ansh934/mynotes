import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/show_error_dialog.dart';
import 'package:mynotes/utilities/dialogs/show_logout_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateNeedsVerification) {
          if (state.exception is TooManyRequestsAuthException) {
            await showErrorDialog(context,
                'Too many tries. Check/Refresh mail box for email or try again later');
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
              "Verification"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Text(
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                "We've sent you an verification email, please open it in order to verify your email.",
              ),
              const Text(
                "If you haven't received an verification email yet, press the button below  ",
              ),
              const SizedBox(
                height: 16.0,
              ),
              FilledButton.tonal(
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(const AuthEventSendEmailverification());
                },
                child: const Text("Send verification email"),
              ),
              FilledButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventReload());
                },
                child: const Text("Refresh"),
              ),
              OutlinedButton(
                onPressed: () async {
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    if (context.mounted) {
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    }
                  }
                },
                child: const Text("Log Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
