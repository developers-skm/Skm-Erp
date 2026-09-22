import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';

class SummaryMetric {
  const SummaryMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

/// Compact horizontal-strip summary shown below the main KPI grid —
/// a quick "at a glance" recap of the day's core numbers.
class TodaysSummaryCard extends StatelessWidget {
  const TodaysSummaryCard({super.key, required this.metrics});

  final List<SummaryMetric> metrics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SkmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: "Today's Overview",
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            runSpacing: AppSpacing.md,
            children: [
              for (final metric in metrics)
                SizedBox(
                  width: 150,
                  child: Row(
                    children: [
                      Icon(
                        metric.icon,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              metric.value,
                              style: theme.textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              metric.label,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
