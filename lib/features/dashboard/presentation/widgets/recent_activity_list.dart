import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/dashboard_sample_data.dart';

/// Renders the "Recent Activity" feed on the dashboard.
class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key, required this.items});

  final List<RecentActivityItem> items;

  static const Map<String, IconData> _iconMap = {
    'production': Icons.egg_outlined,
    'mortality': Icons.monitor_heart_outlined,
    'sales': Icons.point_of_sale_outlined,
    'feed': Icons.grass_outlined,
    'medicine': Icons.medication_outlined,
    'vaccine': Icons.vaccines_outlined,
  };

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyState(
        title: 'No recent activity',
        message: 'Entries you record today will show up here.',
        icon: Icons.history_rounded,
      );
    }

    final theme = Theme.of(context);
    final statusColors =
        theme.extension<AppStatusColors>() ?? AppStatusColors.standard;

    return SkmCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _ActivityTile(
              item: items[i],
              icon: _iconMap[items[i].icon] ?? Icons.circle_outlined,
              accentColor: statusColors.production,
            ),
            if (i != items.length - 1)
              const Divider(
                height: 1,
                indent: AppSpacing.lg,
                endIndent: AppSpacing.lg,
              ),
          ],
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.item,
    required this.icon,
    required this.accentColor,
  });

  final RecentActivityItem item;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: accentColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: theme.textTheme.bodyLarge),
                Text(
                  item.subtitle,
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(item.timeAgo, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
