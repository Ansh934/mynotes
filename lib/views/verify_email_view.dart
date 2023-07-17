import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/utilities/dialogs/show_logout_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        centerTitle: true,
        title: const Text(
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            "Verification"),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              "We've sent you an verification email, please open it in order to verify your email.",
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "If you haven't received an verification email yet, press the button below  ",
            ),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<AuthBloc>()
                  .add(const AuthEventSendEmailverification());
            },
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.primaryContainer)),
            child: const Text("Send verification email"),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventReload());
            },
            child: const Text("Refresh"),
          ),
          TextButton(
            onPressed: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                if (context.mounted) {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                }
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.errorContainer)),
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
