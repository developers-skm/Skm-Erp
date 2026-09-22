/// ============================================================
/// TEMPORARY SAMPLE DATA — NOTIFICATIONS
/// ============================================================
/// UI-only placeholder values so the Notifications screen can be
/// visualized before a real push/local-notification pipeline exists.
/// Isolated here for easy removal. Not business defaults.
library;

enum NotificationCategory { mortality, production, sync, system }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.timeAgo,
    this.read = false,
  });

  final String id;
  final NotificationCategory category;
  final String title;
  final String body;
  final String timeAgo;
  final bool read;

  AppNotification copyWith({bool? read}) {
    return AppNotification(
      id: id,
      category: category,
      title: title,
      body: body,
      timeAgo: timeAgo,
      read: read ?? this.read,
    );
  }
}

final List<AppNotification> sampleNotifications = [
  const AppNotification(
    id: 'n1',
    category: NotificationCategory.mortality,
    title: 'High mortality alert',
    body: 'Shed A1 — Batch 24 reported 18 mortality today, above the usual range.',
    timeAgo: '12m ago',
  ),
  const AppNotification(
    id: 'n2',
    category: NotificationCategory.sync,
    title: 'Sync pending',
    body: '3 records are waiting to sync once you\'re back online.',
    timeAgo: '1h ago',
  ),
  const AppNotification(
    id: 'n3',
    category: NotificationCategory.production,
    title: 'Daily production submitted',
    body: 'Shed A1 — Batch 24 production of 38,920 eggs was recorded.',
    timeAgo: '3h ago',
    read: true,
  ),
  const AppNotification(
    id: 'n4',
    category: NotificationCategory.system,
    title: 'Welcome to SKM Egg',
    body: 'Your account is set up. Explore Dashboard, Mortality and Reports from the menu.',
    timeAgo: 'Yesterday',
    read: true,
  ),
];
