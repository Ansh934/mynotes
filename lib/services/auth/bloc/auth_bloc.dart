import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc.fromFirebase() : this(FirebaseAuthProvider());
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialised(isLoading: true)) {
    // initialise
    on<AuthEventInitialise>((event, emit) async {
      await provider.initialise();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(
          exception: null,
          isLoading: false,
        ));
      } else {
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    });

    // log in
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: true,
        loadingText: 'Please wait while we login',
      ));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (user != null) {
          if (user.isEmailVerified) {
            emit(AuthStateLoggedIn(
              user: user,
              isLoading: false,
            ));
          } else if (!user.isEmailVerified) {
            emit(const AuthStateNeedsVerification(
              exception: null,
              isLoading: false,
            ));
          }
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });

    // send forgot password email
    on<AuthEventForgotPassword>(
      (event, emit) async {
        final email = event.email;

        emit(const AuthStateForgotPassword(
          //user just wants to go to F.P. screen
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ));
        if (email == null) return;

        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: true,
        ));

        bool didSentEmail;
        Exception? exception;
        try {
          await provider.sendPasswordResetEmail(toEmail: email);
          exception = null;
          didSentEmail = true;
        } on Exception catch (e) {
          exception = e;
          didSentEmail = false;
        }
        emit(AuthStateForgotPassword(
          exception: exception,
          hasSentEmail: didSentEmail,
          isLoading: false,
        ));
      },
    );

    // goto register
    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateShouldRegister(
          exception: null,
          isLoading: false,
        ));
      },
    );

    // register
    on<AuthEventRegister>(
      (event, emit) async {
        emit(const AuthStateShouldRegister(
          exception: null,
          isLoading: true,
          loadingText: 'Please wait while we register',
        ));
        final email = event.email;
        final password = event.password;
        try {
          await provider.createUser(
            email: email,
            password: password,
          );
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(
            exception: null,
            isLoading: false,
          ));
        } on Exception catch (e) {
          emit(AuthStateShouldRegister(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );

    // send email verification
    on<AuthEventSendEmailverification>(
      (event, emit) async {
        emit(const AuthStateNeedsVerification(
          exception: null,
          isLoading: true,
        ));
        try {
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(
            exception: null,
            isLoading: false,
          ));
        } on Exception catch (e) {
          emit(AuthStateNeedsVerification(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );

    // reload
    on<AuthEventReload>(
      (event, emit) async {
        emit(const AuthStateNeedsVerification(
          exception: null,
          isLoading: true,
        ));
        await provider.reload();
        final user = provider.currentUser;
        if (user != null) {
          if (user.isEmailVerified) {
            emit(AuthStateLoggedIn(
              user: user,
              isLoading: false,
            ));
          } else if (!user.isEmailVerified) {
            emit(const AuthStateNeedsVerification(
              exception: null,
              isLoading: false,
            ));
          }
        }
      },
    );

    // log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });
  }
}
