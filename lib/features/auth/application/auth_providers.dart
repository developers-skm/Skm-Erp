import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';

/// Provides the [AuthRepository] implementation. Swap [DemoAuthRepository]
/// for the real backend-backed implementation once the API is available —
/// no UI code should need to change.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return DemoAuthRepository();
});

enum AuthStatus { signedOut, authenticating, signedIn, error }

class AuthState {
  const AuthState({
    this.status = AuthStatus.signedOut,
    this.userDisplayName,
    this.errorMessage,
  });

  final AuthStatus status;
  final String? userDisplayName;
  final String? errorMessage;

  bool get isLoading => status == AuthStatus.authenticating;
  bool get isSignedIn => status == AuthStatus.signedIn;

  AuthState copyWith({
    AuthStatus? status,
    String? userDisplayName,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      userDisplayName: userDisplayName ?? this.userDisplayName,
      errorMessage: errorMessage,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(
      status: AuthStatus.authenticating,
      errorMessage: null,
    );

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.login(
      username: username,
      password: password,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        status: AuthStatus.signedIn,
        userDisplayName: result.userDisplayName,
      );
    } else {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: result.errorMessage,
      );
    }
  }

  void signOut() {
    state = const AuthState();
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
