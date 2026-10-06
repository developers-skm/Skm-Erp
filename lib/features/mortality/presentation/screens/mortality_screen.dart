import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/sample_data.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/skm_app_bar.dart';
import '../../data/mortality_sample_data.dart';
import '../widgets/mortality_filter_panel.dart';
import '../widgets/mortality_record_card.dart';
import 'add_mortality_screen.dart';

/// Mortality service — filterable record list + entry point for Add
/// Mortality.
///
/// Modernized redesign of the reference app's Display Mortality screen:
/// session toggle, a proper filter card with a full-width Apply action
/// (replacing the tiny circular arrow), and card-based records instead
/// of a cramped table. No repository is wired yet, so filtering narrows
/// [sampleMortalityRecords] client-side rather than calling an API.
class MortalityScreen extends StatefulWidget {
  const MortalityScreen({super.key});

  @override
  State<MortalityScreen> createState() => _MortalityScreenState();
}

class _MortalityScreenState extends State<MortalityScreen> {
  MortalitySession _session = MortalitySession.morning;
  late SampleFarm _farm = sampleFarms.first;
  late SampleFlock _flock = sampleFlocks.first;
  int _month = DateTime.now().month;
  int _year = DateTime.now().year;

  List<MortalityRecord> _visibleRecords = sampleMortalityRecords;

  void _applyFilters() {
    setState(() {
      _visibleRecords = sampleMortalityRecords
          .where(
            (r) =>
                r.session == _session &&
                r.date.month == _month &&
                r.date.year == _year,
          )
          .toList();
    });
  }

  void _openAdd() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddMortalityScreen()));
  }

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkmAppBar(
        title: 'Mortality',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: FilledButton.icon(
              onPressed: _openAdd,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Add'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                0,
              ),
              child: _SessionToggle(
                session: _session,
                onChanged: (session) {
                  setState(() => _session = session);
                  _applyFilters();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                0,
              ),
              child: MortalityFilterPanel(
                farm: _farm,
                flock: _flock,
                month: _month,
                year: _year,
                onFarmChanged: (farm) {
                  final flocksForFarm = sampleFlocks.where(
                    (f) => f.farmId == farm.id,
                  );
                  setState(() {
                    _farm = farm;
                    _flock = flocksForFarm.isNotEmpty
                        ? flocksForFarm.first
                        : _flock;
                  });
                },
                onFlockChanged: (flock) => setState(() => _flock = flock),
                onMonthChanged: (month) => setState(() => _month = month),
                onYearChanged: (year) => setState(() => _year = year),
                onApply: _applyFilters,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: _visibleRecords.isEmpty
                  ? const EmptyState(
                      title: 'No mortality records yet',
                      message:
                          'Entries you save will appear here once local '
                          'storage is connected.',
                      icon: Icons.monitor_heart_outlined,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        0,
                        AppSpacing.lg,
                        AppSpacing.xl,
                      ),
                      itemCount: _visibleRecords.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final record = _visibleRecords[index];
                        return MortalityRecordCard(
                          record: record,
                          onView: () {},
                          onDelete: () {
                            setState(
                              () => _visibleRecords = List.of(_visibleRecords)
                                ..remove(record),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionToggle extends StatelessWidget {
  const _SessionToggle({required this.session, required this.onChanged});

  final MortalitySession session;
  final ValueChanged<MortalitySession> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.5,
        ),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SessionTab(
              label: 'Morning',
              icon: Icons.wb_sunny_outlined,
              selected: session == MortalitySession.morning,
              onTap: () => onChanged(MortalitySession.morning),
            ),
          ),
          Expanded(
            child: _SessionTab(
              label: 'Evening',
              icon: Icons.nights_stay_outlined,
              selected: session == MortalitySession.evening,
              onTap: () => onChanged(MortalitySession.evening),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionTab extends StatelessWidget {
  const _SessionTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
