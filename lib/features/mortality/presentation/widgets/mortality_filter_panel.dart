import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/sample_data.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/searchable_selector.dart';
import '../../../../core/widgets/skm_card.dart';

const _months = [
  'January', 'February', 'March', 'April', // ignore: prefer-trailing-comma
  'May', 'June', 'July', 'August',
  'September', 'October', 'November', 'December',
];

/// Farm / Flock / Month / Year filters plus a primary "Apply Filters"
/// action, replacing the reference app's cramped 4-field grid + tiny
/// circular arrow button with full-width, clearly tappable controls.
class MortalityFilterPanel extends StatelessWidget {
  const MortalityFilterPanel({
    super.key,
    required this.farm,
    required this.flock,
    required this.month,
    required this.year,
    required this.onFarmChanged,
    required this.onFlockChanged,
    required this.onMonthChanged,
    required this.onYearChanged,
    required this.onApply,
  });

  final SampleFarm farm;
  final SampleFlock flock;
  final int month;
  final int year;
  final ValueChanged<SampleFarm> onFarmChanged;
  final ValueChanged<SampleFlock> onFlockChanged;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<int> onYearChanged;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final years = List.generate(5, (i) => DateTime.now().year - i);

    return SkmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SearchableSelector<SampleFarm>(
                  label: 'Farm',
                  items: sampleFarms,
                  itemLabel: (f) => f.name,
                  selected: farm,
                  onSelected: onFarmChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SearchableSelector<SampleFlock>(
                  label: 'Flock',
                  items: sampleFlocks
                      .where((f) => f.farmId == farm.id)
                      .toList(),
                  itemLabel: (f) => f.name,
                  selected: flock,
                  onSelected: onFlockChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: SearchableSelector<int>(
                  label: 'Month',
                  items: List.generate(12, (i) => i + 1),
                  itemLabel: (m) => _months[m - 1],
                  selected: month,
                  onSelected: onMonthChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SearchableSelector<int>(
                  label: 'Year',
                  items: years,
                  itemLabel: (y) => '$y',
                  selected: year,
                  onSelected: onYearChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Apply Filters',
            icon: Icons.filter_alt_rounded,
            onPressed: onApply,
          ),
        ],
      ),
    );
  }
}
