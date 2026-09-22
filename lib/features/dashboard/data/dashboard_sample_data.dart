/// ============================================================
/// TEMPORARY PHASE 1 SAMPLE DATA — DASHBOARD
/// ============================================================
/// UI-only placeholder values so the dashboard can be visualized before
/// real repositories/APIs exist. Isolated in this file for easy removal.
/// These are NOT business defaults.
library;

class DashboardSampleData {
  const DashboardSampleData({
    required this.birdCount,
    required this.mortality,
    required this.mortalityPercent,
    required this.production,
    required this.productionPercent,
    required this.feedConsumedKg,
    required this.eggSalesCount,
    required this.averageSalePrice,
    required this.eggStock,
    required this.sevenDayProduction,
    required this.recentActivity,
  });

  final int birdCount;
  final int mortality;
  final double mortalityPercent;
  final int production;
  final double productionPercent;
  final double feedConsumedKg;
  final int eggSalesCount;
  final double averageSalePrice;
  final int eggStock;
  final List<double> sevenDayProduction;
  final List<RecentActivityItem> recentActivity;
}

class RecentActivityItem {
  const RecentActivityItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.timeAgo,
  });

  final String title;
  final String subtitle;
  final String icon; // Material icon name key, mapped in the widget layer.
  final String timeAgo;
}

const DashboardSampleData sampleDashboardData = DashboardSampleData(
  birdCount: 42850,
  mortality: 18,
  mortalityPercent: 0.04,
  production: 38920,
  productionPercent: 90.8,
  feedConsumedKg: 4280,
  eggSalesCount: 36500,
  averageSalePrice: 5.85,
  eggStock: 72450,
  sevenDayProduction: [88.2, 89.0, 90.1, 89.6, 91.0, 90.3, 90.8],
  recentActivity: _todayActivity,
);

/// Sample data for the previously selectable day, so the dashboard's
/// calendar pill has something distinct to switch to. Same isolation
/// caveat as [sampleDashboardData] — placeholder only.
const DashboardSampleData sampleDashboardDataYesterday = DashboardSampleData(
  birdCount: 42868,
  mortality: 12,
  mortalityPercent: 0.03,
  production: 37640,
  productionPercent: 89.1,
  feedConsumedKg: 4195,
  eggSalesCount: 34200,
  averageSalePrice: 5.7,
  eggStock: 70120,
  sevenDayProduction: [87.5, 88.2, 89.0, 90.1, 89.6, 91.0, 89.1],
  recentActivity: _yesterdayActivity,
);

const List<RecentActivityItem> _todayActivity = [
  RecentActivityItem(
    title: 'Daily production submitted',
    subtitle: 'Shed A1 — Batch 24 • 38,920 eggs',
    icon: 'production',
    timeAgo: '12m ago',
  ),
  RecentActivityItem(
    title: 'Mortality entry saved',
    subtitle: 'Shed A1 — Batch 24 • 18 birds',
    icon: 'mortality',
    timeAgo: '1h ago',
  ),
  RecentActivityItem(
    title: 'Egg sale recorded',
    subtitle: 'Invoice #10245 • ₹2,13,525',
    icon: 'sales',
    timeAgo: '3h ago',
  ),
  RecentActivityItem(
    title: 'Feed consumption logged',
    subtitle: 'Shed A2 — Batch 25 • 2,140 kg',
    icon: 'feed',
    timeAgo: 'Yesterday',
  ),
];

const List<RecentActivityItem> _yesterdayActivity = [
  RecentActivityItem(
    title: 'Daily production submitted',
    subtitle: 'Shed A1 — Batch 24 • 37,640 eggs',
    icon: 'production',
    timeAgo: 'Yesterday, 6:40 PM',
  ),
  RecentActivityItem(
    title: 'Mortality entry saved',
    subtitle: 'Shed A1 — Batch 24 • 12 birds',
    icon: 'mortality',
    timeAgo: 'Yesterday, 5:10 PM',
  ),
  RecentActivityItem(
    title: 'Egg sale recorded',
    subtitle: 'Invoice #10238 • ₹1,94,940',
    icon: 'sales',
    timeAgo: 'Yesterday, 2:20 PM',
  ),
  RecentActivityItem(
    title: 'Feed consumption logged',
    subtitle: 'Shed A2 — Batch 25 • 2,095 kg',
    icon: 'feed',
    timeAgo: 'Yesterday, 9:05 AM',
  ),
];
