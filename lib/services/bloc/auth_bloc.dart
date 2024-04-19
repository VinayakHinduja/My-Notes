import 'package:bloc/bloc.dart';
import '../auth/auth_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    //ReAuthentication
    on<AuthEventReAuthenticate>((event, emit) async {
      emit(
        const AuthStateReAuthentication(
          exception: null,
          hasReAuthenticate: false,
          isLoading: false,
        ),
      );
      final password = event.pass;
      if (password == null) {
        return; // user just wanted to go to forgot screen
      }
      emit(
        const AuthStateReAuthentication(
          exception: null,
          hasReAuthenticate: false,
          isLoading: true,
        ),
      );
      bool didReAuthenticate;
      Exception? exception;
      try {
        await provider.reAuthenticateWithCredentials(password: password);
        didReAuthenticate = true;
        exception = null;
      } on Exception catch (e) {
        didReAuthenticate = false;
        exception = e;
      }
      emit(
        AuthStateReAuthentication(
          exception: exception,
          hasReAuthenticate: didReAuthenticate,
          isLoading: false,
        ),
      );
    });
    // update username
    on<AuthEventUpdateUserName>((event, emit) async {
      emit(
        const AuthStateUpdateUsername(
          exception: null,
          isLoading: false,
          hasUpdated: false,
        ),
      );
      final newName = event.newName;
      if (newName == null) {
        return; // user just wanted to go to forgot screen
      }

      emit(
        const AuthStateUpdateUsername(
          exception: null,
          isLoading: true,
          hasUpdated: false,
        ),
      );
      bool hasUpdate;
      Exception? exception;
      try {
        await provider.updateDisplayName(displayName: newName);
        hasUpdate = true;
        exception = null;
      } on Exception catch (e) {
        hasUpdate = false;
        exception = e;
      }
      emit(
        AuthStateUpdateUsername(
          exception: exception,
          isLoading: false,
          hasUpdated: hasUpdate,
        ),
      );
    });
    // update password
    on<AuthEventUpdatePassword>((event, emit) async {
      emit(
        const AuthStateUpdatePassword(
          exception: null,
          hasUpdated: false,
          isLoading: false,
        ),
      );
      final newPassword = event.newPass;
      final oldPassword = event.oldPass;
      if (newPassword == null && oldPassword == null) {
        return; // user just wanted to go to forgot screen
      }
      emit(
        const AuthStateUpdatePassword(
          exception: null,
          hasUpdated: false,
          isLoading: true,
        ),
      );
      bool didUpdatePassword;
      Exception? exception;
      try {
        await provider.reAuthenticateWithCredentials(password: oldPassword!);
        await provider.updatePassword(newPassword: newPassword!);
        didUpdatePassword = true;
        exception = null;
      } on Exception catch (e) {
        didUpdatePassword = false;
        exception = e;
      }
      emit(
        AuthStateUpdatePassword(
          exception: exception,
          hasUpdated: didUpdatePassword,
          isLoading: false,
        ),
      );
    });
    // forgot password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(
        const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ),
      );
      final email = event.email;
      if (email == null) {
        return; // user just wanted to go to forgot screen
      }

      emit(
        const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: true,
        ),
      );
      bool didSendEmail;
      Exception? exception;
      try {
        await provider.sendPasswordResetEmail(email: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }
      emit(
        AuthStateForgotPassword(
          exception: exception,
          hasSentEmail: didSendEmail,
          isLoading: false,
        ),
      );
    });
    // send Email Verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    // register
    on<AuthEventShouldRegister>((event, emit) {
      emit(
        const AuthStateRegistering(
          exception: null,
          isLoading: false,
        ),
      );
    });
    // registering
    on<AuthEventRegister>((event, emit) async {
      final String email = event.email;
      final String password = event.pass;
      final String name = event.name;
      try {
        await provider
            .createUser(email: email, password: password)
            .whenComplete(
              () async => await provider
                  .updateDisplayName(displayName: name)
                  .whenComplete(
                    () async => await provider.sendEmailVerification(),
                  ),
            );
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(
          AuthStateRegistering(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    // Initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } else if (!user.isEmailVerifed) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(
          AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ),
        );
      }
    });
    // log in
    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Please wait while i log you in',
        ),
      );
      final email = event.email;
      final password = event.pass;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerifed) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    // log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    //
    on<AuthEventSettings>((event, emit) {
      emit(const AuthStateSettings(isLoading: false));
    });
    //
    on<AuthEventLoggedIn>((event, emit) {
      emit(AuthStateLoggedIn(
        user: provider.currentUser!,
        isLoading: false,
      ));
    });
  }
}
