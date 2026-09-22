import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart' show AppSpacing, AppRadius;

/// Base rounded card surface shared by KPI cards, quick actions, list
/// items, and section containers. Keeps corner radius / padding / border
/// consistent without every screen re-declaring a [Card] + [BoxDecoration].
class SkmCard extends StatelessWidget {
  const SkmCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Padding(padding: padding, child: child);

    return Material(
      color: color ?? theme.cardTheme.color,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: content,
        ),
      ),
    );
  }
}
