/// Placeholder API client contract.
///
/// Real HTTP implementation (base URL, headers, auth token injection,
/// timeouts) will be added once backend API details are provided.
/// UI code must never call HTTP directly — always go through a
/// Repository, which uses this client via a RemoteDataSource.
abstract class ApiClient {
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query});

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body});
}
