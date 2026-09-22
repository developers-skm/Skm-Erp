# Local Database (planned)

This project will use **Drift** (SQLite) for offline-first local storage of
operational records (daily entry, mortality, production, feed, medicine,
vaccination, disease, egg sales).

**Why Drift:**
- Type-safe SQL with compile-time verified queries — important for the
  relational filtering Reports needs (date ranges, farm/flock joins).
- Mature reactive streams for watching "pending sync" record counts, which
  power the global sync-status indicator.
- Actively maintained, fully compatible with the current Flutter/Dart SDK
  (Flutter 3.47.x / Dart 3.13.x).

**Not added yet:** Drift requires `build_runner` code generation and schema
definitions per feature. Adding it before any feature actually persists
data would be premature. It will be introduced in the phase that
implements real offline storage for Daily Entry / Mortality, etc.
