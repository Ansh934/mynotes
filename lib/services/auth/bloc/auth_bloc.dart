import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc.fromFirebase() : this(FirebaseAuthProvider());
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialised()) {
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
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });
    // log in
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: true,
      ));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (user != null) {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
          if (user.isEmailVerified) {
            emit(AuthStateLoggedIn(user));
          } else if (!user.isEmailVerified) {
            emit(const AuthStateNeedsVerification());
          }
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });
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
    // goto register
    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateShouldRegister());
      },
    );
    // register
    on<AuthEventRegister>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          await provider.createUser(email: email, password: password);
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification());
        } on Exception catch (e) {
          emit(AuthStateRegistering(e));
        }
      },
    );
    // send email verification
    on<AuthEventSendEmailverification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );
    // reload
    on<AuthEventReload>(
      (event, emit) async {
        await provider.reload();
        final user = provider.currentUser;
        if (user != null) {
          if (user.isEmailVerified) {
            emit(AuthStateLoggedIn(user));
          } else if (!user.isEmailVerified) {
            emit(state);
          }
        }
      },
    );
  }
}
