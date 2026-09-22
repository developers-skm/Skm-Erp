import 'package:flutter/material.dart';

import '../../../../core/constants/sample_data.dart';
import '../../../../core/widgets/entry_context_header.dart';
import '../../../../core/widgets/numeric_field.dart';
import '../../../../core/widgets/primary_button.dart';

/// Feeds & Eggs — the modernized "Daily Entry" workflow from the reference
/// app, split into its two original sections (Feed & Birds / Production)
/// using a segmented tab bar instead of the old app's separate screens.
///
/// No calculations are invented here — fields are captured as-is and the
/// architecture leaves room for derived values (e.g. production %) to be
/// added once business rules are confirmed.
class FeedsEggsScreen extends StatefulWidget {
  const FeedsEggsScreen({super.key});

  @override
  State<FeedsEggsScreen> createState() => _FeedsEggsScreenState();
}

class _FeedsEggsScreenState extends State<FeedsEggsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flock = sampleFlocks.first;
    final farm = sampleFarms.first;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: EntryContextHeader(
                farmName: farm.name,
                flockName: flock.name,
                date: _date,
                onDateChanged: (value) => setState(() => _date = value),
                ageInWeeks: flock.ageInWeeks,
              ),
            ),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'FEED & BIRDS'),
                Tab(text: 'PRODUCTION'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [_FeedAndBirdsTab(), _ProductionTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedAndBirdsTab extends StatefulWidget {
  const _FeedAndBirdsTab();

  @override
  State<_FeedAndBirdsTab> createState() => _FeedAndBirdsTabState();
}

class _FeedAndBirdsTabState extends State<_FeedAndBirdsTab> {
  final _mortalityController = TextEditingController();
  final _cullsController = TextEditingController();
  final _bodyWeightController = TextEditingController();
  final _waterController = TextEditingController();
  final _feedController = TextEditingController();

  @override
  void dispose() {
    _mortalityController.dispose();
    _cullsController.dispose();
    _bodyWeightController.dispose();
    _waterController.dispose();
    _feedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: NumericField(
                label: 'Mortality',
                controller: _mortalityController,
                unit: 'birds',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NumericField(
                label: 'Culls',
                controller: _cullsController,
                unit: 'birds',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        NumericField(
          label: 'Body Weight',
          controller: _bodyWeightController,
          unit: 'g',
          allowDecimal: true,
        ),
        const SizedBox(height: 16),
        NumericField(
          label: 'Water Consumption',
          controller: _waterController,
          unit: 'L',
          allowDecimal: true,
        ),
        const SizedBox(height: 16),
        NumericField(
          label: 'Feed Consumption',
          controller: _feedController,
          unit: 'kg',
          allowDecimal: true,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Save Feed & Birds',
          icon: Icons.check_rounded,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Feed & Birds saved (local demo only)'),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ProductionTab extends StatefulWidget {
  const _ProductionTab();

  @override
  State<_ProductionTab> createState() => _ProductionTabState();
}

class _ProductionTabState extends State<_ProductionTab> {
  final _totalEggsController = TextEditingController();
  final _brokenController = TextEditingController();
  final _rejectController = TextEditingController();
  final _saleableController = TextEditingController();

  @override
  void dispose() {
    _totalEggsController.dispose();
    _brokenController.dispose();
    _rejectController.dispose();
    _saleableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        NumericField(
          label: 'Total Eggs',
          controller: _totalEggsController,
          unit: 'eggs',
          required: true,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: NumericField(
                label: 'Broken Eggs',
                controller: _brokenController,
                unit: 'eggs',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NumericField(
                label: 'Reject Eggs',
                controller: _rejectController,
                unit: 'eggs',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        NumericField(
          label: 'Saleable Eggs',
          controller: _saleableController,
          unit: 'eggs',
        ),
        const SizedBox(height: 8),
        const _CalculationsNotice(),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Save Production',
          icon: Icons.check_rounded,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Production saved (local demo only)'),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CalculationsNotice extends StatelessWidget {
  const _CalculationsNotice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Production % and other derived values will be added once business '
              'rules are confirmed.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
