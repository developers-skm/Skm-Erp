import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/sync/sync_status.dart';
import '../../../../core/widgets/widgets.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.userName,
    required this.farmName,
    required this.flockName,
    required this.date,
    required this.syncStatus,
    required this.pendingSyncCount,
    required this.onFarmFlockTap,
    required this.onSyncTap,
    required this.selectedDate,
    required this.onDateChanged,
  });

  final String userName;
  final String farmName;
  final String flockName;
  final DateTime date;
  final SyncStatus syncStatus;
  final int pendingSyncCount;
  final VoidCallback onFarmFlockTap;
  final VoidCallback onSyncTap;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  String get _greeting {
    final hour = date.hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_greeting, $userName',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${_weekday(date.weekday)}, ${date.day} ${_month(date.month)} ${date.year}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SyncStatusChip(
              status: syncStatus,
              pendingCount: pendingSyncCount,
              onTap: onSyncTap,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: FarmFlockSelector(
                farmName: farmName,
                flockName: flockName,
                onTap: onFarmFlockTap,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            CalendarPill(date: selectedDate, onChanged: onDateChanged),
          ],
        ),
      ],
    );
  }

  static String _weekday(int weekday) => const [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ][weekday - 1];

  static String _month(int month) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][month - 1];
}
