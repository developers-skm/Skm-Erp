import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Compact header control for switching the active Farm / Flock context.
/// Used at the top of the Dashboard and Daily Entry style screens.
class FarmFlockSelector extends StatelessWidget {
  const FarmFlockSelector({
    super.key,
    required this.farmName,
    required this.flockName,
    required this.onTap,
  });

  final String farmName;
  final String flockName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.agriculture_rounded,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  farmName,
                  style: theme.textTheme.labelLarge?.copyWith(fontSize: 13),
                ),
                Text(flockName, style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
