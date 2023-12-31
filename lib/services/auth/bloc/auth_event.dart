import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialise extends AuthEvent {
  const AuthEventInitialise();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  const AuthEventRegister(this.email, this.password);
}

class AuthEventSendEmailverification extends AuthEvent {
  const AuthEventSendEmailverification();
}

class AuthEventReload extends AuthEvent {
  const AuthEventReload();
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
