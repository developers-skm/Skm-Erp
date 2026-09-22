/// Generic contract for a feature's local (offline-first) data source.
///
/// Backed by a local database (Drift/SQLite is the planned choice — see
/// project notes) once real persistence is implemented. Phase 1 only
/// establishes the shape of the layer.
abstract class LocalDataSource<T> {
  Future<List<T>> getAll();

  Future<void> upsert(T record);

  Future<void> delete(String id);
}
