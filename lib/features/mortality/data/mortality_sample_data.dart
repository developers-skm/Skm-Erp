/// ============================================================
/// TEMPORARY PHASE 1 SAMPLE DATA — MORTALITY
/// ============================================================
/// UI-only placeholder records so the Mortality list can be visualized
/// before a repository/API exists. Isolated here for easy removal.
/// Do NOT treat these as real records.
library;

enum MortalitySession { morning, evening }

class MortalityRecord {
  const MortalityRecord({
    required this.date,
    required this.flockName,
    required this.ageInWeeks,
    required this.mortality,
    required this.culls,
    required this.session,
  });

  final DateTime date;
  final String flockName;
  final int ageInWeeks;
  final int mortality;
  final int culls;
  final MortalitySession session;
}

final List<MortalityRecord> sampleMortalityRecords = [
  MortalityRecord(
    date: DateTime(2026, 9, 20),
    flockName: 'Shed A1 — Batch 24',
    ageInWeeks: 80,
    mortality: 18,
    culls: 0,
    session: MortalitySession.morning,
  ),
  MortalityRecord(
    date: DateTime(2026, 9, 19),
    flockName: 'Shed A1 — Batch 24',
    ageInWeeks: 79,
    mortality: 15,
    culls: 0,
    session: MortalitySession.morning,
  ),
  MortalityRecord(
    date: DateTime(2026, 9, 18),
    flockName: 'Shed A1 — Batch 24',
    ageInWeeks: 78,
    mortality: 18,
    culls: 2,
    session: MortalitySession.morning,
  ),
  MortalityRecord(
    date: DateTime(2026, 9, 17),
    flockName: 'Shed A1 — Batch 24',
    ageInWeeks: 77,
    mortality: 12,
    culls: 0,
    session: MortalitySession.morning,
  ),
];
