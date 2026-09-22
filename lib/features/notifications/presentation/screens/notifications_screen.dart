import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/skm_card.dart';
import '../../data/notification_sample_data.dart';

/// Notifications module — lists app/farm notifications (alerts, sync
/// state, production/mortality events) and lets the user mark them read.
///
/// Renders isolated sample data (see `notification_sample_data.dart`) —
/// no push-notification/local-notification pipeline is wired yet. This
/// establishes the UI and interaction model a future notification
/// service can plug into.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<AppNotification> _notifications = List.of(sampleNotifications);

  int get _unreadCount => _notifications.where((n) => !n.read).length;

  void _markAllRead() {
    setState(() {
      _notifications = [for (final n in _notifications) n.copyWith(read: true)];
    });
  }

  void _markRead(String id) {
    setState(() {
      _notifications = [
        for (final n in _notifications)
          if (n.id == id) n.copyWith(read: true) else n,
      ];
    });
  }

  void _dismiss(String id) {
    setState(() {
      _notifications = _notifications.where((n) => n.id != id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: _notifications.isEmpty
            ? const EmptyState(
                title: 'No notifications',
                message: 'You\'re all caught up. New alerts will appear here.',
                icon: Icons.notifications_none_rounded,
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: _notifications.length,
                separatorBuilder: (context, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return Dismissible(
                    key: ValueKey(notification.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _dismiss(notification.id),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                      ),
                    ),
                    child: _NotificationTile(
                      notification: notification,
                      onTap: () => _markRead(notification.id),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColors =
        theme.extension<AppStatusColors>() ?? AppStatusColors.standard;

    final (icon, color) = switch (notification.category) {
      NotificationCategory.mortality => (
        Icons.monitor_heart_outlined,
        statusColors.error,
      ),
      NotificationCategory.production => (
        Icons.egg_outlined,
        statusColors.production,
      ),
      NotificationCategory.sync => (
        Icons.cloud_sync_outlined,
        statusColors.pending,
      ),
      NotificationCategory.system => (
        Icons.info_outline_rounded,
        theme.colorScheme.primary,
      ),
    };

    return SkmCard(
      onTap: notification.read ? null : onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: notification.read
                              ? FontWeight.w600
                              : FontWeight.w800,
                        ),
                      ),
                    ),
                    if (!notification.read)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(notification.body, style: theme.textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(notification.timeAgo, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
