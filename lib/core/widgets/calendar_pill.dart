import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Compact date-picker pill for dashboard-style headers, styled to match
/// [FarmFlockSelector]. Lets the user jump to a prior day (e.g. Yesterday)
/// to view that day's data instead of today's.
class CalendarPill extends StatelessWidget {
  const CalendarPill({
    super.key,
    required this.date,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
  });

  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  bool get _isToday {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool get _isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  String get _label {
    if (_isToday) return 'Today';
    if (_isYesterday) return 'Yesterday';
    return '${date.day} ${_month(date.month)}';
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: firstDate ?? DateTime.now().subtract(const Duration(days: 365)),
      lastDate: lastDate ?? DateTime.now(),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _pickDate(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(_label, style: theme.textTheme.labelLarge?.copyWith(fontSize: 13)),
          ],
        ),
      ),
    );
  }

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
