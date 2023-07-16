import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });
  // factory AuthUser.fromFirebase(User user) {
  //   return AuthUser(
  //     id: user.uid,
  //     email: user.email!,
  //     isEmailVerified: user.emailVerified,
  //   );
  // }

  //my own constructor
  AuthUser.fromFirebase(User user)
      : id = user.uid,
        email = user.email!,
        isEmailVerified = user.emailVerified;
}
