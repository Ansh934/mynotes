import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}

class AuthStateUninitialised extends AuthState {
  const AuthStateUninitialised({
    required super.isLoading,
  });
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({
    required this.user,
    required super.isLoading,
  });
}

class AuthStateShouldRegister extends AuthState {
  final Exception? exception;
  const AuthStateShouldRegister({
    required this.exception,
    required super.isLoading,
    super.loadingText,
  });
}

class AuthStateNeedsVerification extends AuthState {
  final Exception? exception;
  const AuthStateNeedsVerification({
    required this.exception,
    required super.isLoading,
    super.loadingText,
  });
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required super.isLoading,
    super.loadingText,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}
