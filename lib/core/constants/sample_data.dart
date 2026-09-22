/// ============================================================
/// TEMPORARY PHASE 1 SAMPLE DATA
/// ============================================================
/// Everything in this file exists ONLY to visualize the UI before real
/// APIs/local storage are connected. It is intentionally isolated here so
/// it can be deleted in one step once real data sources are wired up.
/// Do NOT treat any of these values as business defaults or real records.
library;

class SampleFarm {
  const SampleFarm({required this.id, required this.name});

  final String id;
  final String name;
}

class SampleFlock {
  const SampleFlock({
    required this.id,
    required this.farmId,
    required this.name,
    required this.ageInWeeks,
    required this.birdCount,
  });

  final String id;
  final String farmId;
  final String name;
  final int ageInWeeks;
  final int birdCount;
}

const List<SampleFarm> sampleFarms = [
  SampleFarm(id: 'farm_1', name: 'SKM Farm — Sector 4'),
  SampleFarm(id: 'farm_2', name: 'SKM Farm — Sector 7'),
  SampleFarm(id: 'farm_3', name: 'SKM Farm — Hillside'),
];

const List<SampleFlock> sampleFlocks = [
  SampleFlock(
    id: 'flock_1',
    farmId: 'farm_1',
    name: 'Shed A1 — Batch 24',
    ageInWeeks: 42,
    birdCount: 42850,
  ),
  SampleFlock(
    id: 'flock_2',
    farmId: 'farm_1',
    name: 'Shed A2 — Batch 25',
    ageInWeeks: 28,
    birdCount: 38120,
  ),
  SampleFlock(
    id: 'flock_3',
    farmId: 'farm_2',
    name: 'Shed B1 — Batch 19',
    ageInWeeks: 55,
    birdCount: 31500,
  ),
];
