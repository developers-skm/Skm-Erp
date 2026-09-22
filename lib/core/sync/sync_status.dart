/// Represents the sync state of a single record, or the aggregate sync
/// state of the whole app (shown in the global sync indicator).
///
/// This is intentionally just a data model in Phase 1 — the actual
/// local-storage + background sync engine (Drift + connectivity-aware
/// [SyncService]) will be implemented when offline persistence is added.
enum SyncStatus {
  synced,
  pending,
  failed,
  offline;

  bool get needsAttention => this != SyncStatus.synced;
}
