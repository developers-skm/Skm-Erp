import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../sync/sync_status.dart';
import 'icon_badge.dart';
import 'status_chip.dart';

/// Global sync-state indicator shown on the dashboard header and anywhere
/// else the app needs to communicate offline/pending/synced state.
///
/// Never relies on color alone — always paired with an icon + text label.
class SyncStatusChip extends StatelessWidget {
  const SyncStatusChip({
    super.key,
    required this.status,
    this.pendingCount = 0,
    this.onTap,
    this.compact = false,
  });

  final SyncStatus status;
  final int pendingCount;
  final VoidCallback? onTap;

  /// When true, renders as a small icon-only badge suitable for an AppBar
  /// action — full text label ("3 records waiting") is reserved for the
  /// dashboard body so it never dominates the header.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).extension<AppStatusColors>() ??
        AppStatusColors.standard;

    final (label, color, icon) = switch (status) {
      SyncStatus.synced => (
        'All data synced',
        colors.synced,
        Icons.cloud_done_rounded,
      ),
      SyncStatus.pending => (
        pendingCount > 0
            ? '$pendingCount record${pendingCount == 1 ? '' : 's'} waiting'
            : 'Sync pending',
        colors.pending,
        Icons.cloud_sync_rounded,
      ),
      SyncStatus.failed => (
        'Sync failed',
        colors.failed,
        Icons.cloud_off_rounded,
      ),
      SyncStatus.offline => ('Offline', colors.offline, Icons.wifi_off_rounded),
    };

    final child = compact
        ? IconBadge(
            icon: icon,
            color: color,
            count: status == SyncStatus.pending ? pendingCount : 0,
            semanticLabel: label,
          )
        : StatusChip(label: label, color: color, icon: icon);

    if (onTap == null) return child;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: child,
    );
  }
}
