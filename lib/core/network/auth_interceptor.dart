/// Placeholder for the future auth token interceptor.
///
/// Once a real HTTP client (e.g. Dio) and backend auth flow are wired up,
/// this will attach bearer tokens to outgoing requests and handle
///401/refresh logic. Left as a stub so the network layer shape is
/// established without inventing endpoints.
abstract class AuthInterceptor {
  Future<Map<String, String>> attachAuthHeaders(Map<String, String> headers);
}
