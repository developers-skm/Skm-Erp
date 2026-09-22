/// Result of an authentication attempt.
class AuthResult {
  const AuthResult.success(this.userDisplayName) : errorMessage = null;
  const AuthResult.failure(this.errorMessage) : userDisplayName = null;

  final String? userDisplayName;
  final String? errorMessage;

  bool get isSuccess => errorMessage == null;
}

/// Auth contract the UI depends on. The real implementation will call the
/// backend auth API (via ApiClient/RemoteDataSource) once it is provided.
///
/// [DemoAuthRepository] is a clearly-labelled temporary stand-in so the
/// login flow can be exercised in Phase 1 without a backend.
abstract class AuthRepository {
  Future<AuthResult> login({
    required String username,
    required String password,
  });
}

/// TEMPORARY Phase 1 stand-in for real authentication.
///
/// Accepts only the demo credentials provided for UI testing:
///   username: admin
///   password: Admin@123
///
/// Replace with a real implementation backed by RemoteDataSource +
/// AuthInterceptor once backend API details are available.
class DemoAuthRepository implements AuthRepository {
  static const String demoUsername = 'admin';
  static const String demoPassword = 'Admin@123';

  @override
  Future<AuthResult> login({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (username.trim().toLowerCase() == demoUsername &&
        password == demoPassword) {
      return const AuthResult.success('Admin');
    }

    return const AuthResult.failure('Invalid username or password.');
  }
}
