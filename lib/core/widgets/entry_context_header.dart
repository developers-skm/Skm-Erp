import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import 'date_selector.dart';
import 'skm_card.dart';

/// Standard Farm / Flock / Date / Age header shown at the top of every
/// data-entry form (Daily Entry, Mortality, Disease, ...).
class EntryContextHeader extends StatelessWidget {
  const EntryContextHeader({
    super.key,
    required this.farmName,
    required this.flockName,
    required this.date,
    required this.onDateChanged,
    required this.ageInWeeks,
  });

  final String farmName;
  final String flockName;
  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;
  final int ageInWeeks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SkmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.agriculture_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(farmName, style: theme.textTheme.labelLarge),
                    Text(flockName, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withValues(
                    alpha: 0.4,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Age: $ageInWeeks w',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          DateSelector(label: 'Date', value: date, onChanged: onDateChanged),
        ],
      ),
    );
  }
}
