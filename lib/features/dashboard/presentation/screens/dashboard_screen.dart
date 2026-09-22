import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/navigation/app_destination.dart';
import '../../../../app/navigation/app_destination_provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/sample_data.dart';
import '../../../../core/sync/sync_status.dart';
import '../../../../core/utils/number_format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/dashboard_sample_data.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_skeleton.dart';
import '../widgets/production_trend_card.dart';
import '../widgets/recent_activity_list.dart';
import '../widgets/todays_summary_card.dart';

/// Main farm overview screen. Renders isolated sample data (see
/// `dashboard_sample_data.dart`) — no repository/API is wired yet.
///
/// Quick Entry cards route through [appDestinationProvider], the SAME
/// navigation state the Drawer/Sidebar use — there is only one mechanism
/// for switching the active service.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key, this.userName = 'Admin'});

  final String userName;

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  SampleFarm _selectedFarm = sampleFarms.first;
  SampleFlock _selectedFlock = sampleFlocks.first;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulated first-load latency — stands in for the real repository
    // fetch once the API is wired up, so the skeleton has something to
    // show. Remove this delay once dashboardDataProvider does real I/O.
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  bool get _isYesterdaySelected {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _selectedDate.year == yesterday.year &&
        _selectedDate.month == yesterday.month &&
        _selectedDate.day == yesterday.day;
  }

  void _openFarmFlockPicker() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => _FarmFlockPickerSheet(
        selectedFarm: _selectedFarm,
        selectedFlock: _selectedFlock,
        onSelected: (farm, flock) {
          setState(() {
            _selectedFarm = farm;
            _selectedFlock = flock;
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: _isLoading ? const DashboardSkeleton() : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final data = _isYesterdaySelected
        ? sampleDashboardDataYesterday
        : sampleDashboardData;
    final isTablet = AppBreakpoints.isTablet(MediaQuery.sizeOf(context).width);
    final statusColors =
        Theme.of(context).extension<AppStatusColors>() ??
        AppStatusColors.standard;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          sliver: SliverToBoxAdapter(
            child: DashboardHeader(
              userName: widget.userName,
              farmName: _selectedFarm.name,
              flockName:
                  '${_selectedFlock.name} • ${_selectedFlock.ageInWeeks}w',
              date: DateTime.now(),
              syncStatus: SyncStatus.pending,
              pendingSyncCount: 3,
              onFarmFlockTap: _openFarmFlockPicker,
              onSyncTap: () => ref
                  .read(appDestinationProvider.notifier)
                  .go(AppDestination.sync),
              selectedDate: _selectedDate,
              onDateChanged: (date) => setState(() => _selectedDate = date),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverToBoxAdapter(
            child: _KpiGrid(
              data: data,
              statusColors: statusColors,
              isTablet: isTablet,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            0,
          ),
          sliver: const SliverToBoxAdapter(
            child: SectionHeader(title: 'Quick Entry'),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverToBoxAdapter(
            child: _QuickActionsGrid(isTablet: isTablet),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
            0,
          ),
          sliver: SliverToBoxAdapter(
            child: TodaysSummaryCard(
              metrics: [
                SummaryMetric(
                  label: 'Birds',
                  value: formatThousands(data.birdCount),
                  icon: Icons.egg_alt_outlined,
                ),
                SummaryMetric(
                  label: 'Feed',
                  value: '${formatThousands(data.feedConsumedKg.round())} kg',
                  icon: Icons.grass_outlined,
                ),
                SummaryMetric(
                  label: 'Production',
                  value: formatThousands(data.production),
                  icon: Icons.egg_outlined,
                ),
                SummaryMetric(
                  label: 'Mortality',
                  value: '${data.mortality}',
                  icon: Icons.monitor_heart_outlined,
                ),
                SummaryMetric(
                  label: 'Sales',
                  value: formatThousands(data.eggSalesCount),
                  icon: Icons.point_of_sale_outlined,
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
            0,
          ),
          sliver: SliverToBoxAdapter(
            child: ProductionTrendCard(values: data.sevenDayProduction),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
            0,
          ),
          sliver: const SliverToBoxAdapter(
            child: SectionHeader(title: 'Recent Activity'),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          sliver: SliverToBoxAdapter(
            child: RecentActivityList(items: data.recentActivity),
          ),
        ),
      ],
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({
    required this.data,
    required this.statusColors,
    required this.isTablet,
  });

  final DashboardSampleData data;
  final AppStatusColors statusColors;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = isTablet ? 4 : 2;

    final cards = [
      KpiCard(
        label: 'Bird Count',
        value: formatThousands(data.birdCount),
        icon: Icons.egg_alt_outlined,
      ),
      KpiCard(
        label: 'Production',
        value: formatThousands(data.production),
        unit: 'eggs',
        icon: Icons.egg_outlined,
        accentColor: statusColors.production,
      ),
      KpiCard(
        label: 'Production %',
        value: data.productionPercent.toStringAsFixed(1),
        unit: '%',
        icon: Icons.trending_up_rounded,
        accentColor: statusColors.production,
      ),
      KpiCard(
        label: 'Mortality',
        value: '${data.mortality}',
        unit: 'birds',
        icon: Icons.monitor_heart_outlined,
        accentColor: statusColors.error,
      ),
      KpiCard(
        label: 'Feed Consumption',
        value: formatThousands(data.feedConsumedKg.round()),
        unit: 'kg',
        icon: Icons.grass_outlined,
        accentColor: statusColors.warning,
      ),
      KpiCard(
        label: 'Egg Stock',
        value: formatThousands(data.eggStock),
        icon: Icons.inventory_2_outlined,
      ),
      FeedEggsSummaryCard(
        feedLabel: 'Feed',
        feedValue: formatThousands(data.feedConsumedKg.round()),
        feedUnit: 'kg',
        eggsLabel: 'Eggs',
        eggsValue: formatThousands(data.production),
      ),
      KpiCard(
        label: 'Egg Sales',
        value: formatThousands(data.eggSalesCount),
        icon: Icons.point_of_sale_outlined,
        accentColor: statusColors.production,
      ),
      KpiCard(
        label: 'Avg. Sale Price',
        value: data.averageSalePrice.toStringAsFixed(2),
        unit: '₹/egg',
        icon: Icons.currency_rupee_rounded,
        accentColor: statusColors.warning,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: AppSpacing.md),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: isTablet ? 1.7 : 1.5,
      ),
      itemBuilder: (context, index) => cards[index],
    );
  }
}

class _QuickActionsGrid extends ConsumerWidget {
  const _QuickActionsGrid({required this.isTablet});

  final bool isTablet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = <(String, IconData, AppDestination)>[
      ('Mortality', Icons.monitor_heart_outlined, AppDestination.mortality),
      ('Feeds & Eggs', Icons.egg_outlined, AppDestination.feedsEggs),
      (
        'Medicine\n& Vaccine',
        Icons.medication_outlined,
        AppDestination.medicineVaccine,
      ),
      ('Shed Transfer', Icons.swap_horiz_rounded, AppDestination.shedTransfer),
      (
        'Egg Dispatch',
        Icons.local_shipping_outlined,
        AppDestination.eggDispatch,
      ),
      (
        'Antibiotic',
        Icons.health_and_safety_outlined,
        AppDestination.antibiotic,
      ),
      ('Birds Sales', Icons.sell_outlined, AppDestination.birdsSales),
      ('Egg Sale', Icons.point_of_sale_outlined, AppDestination.eggSale),
      ('Disease', Icons.coronavirus_outlined, AppDestination.disease),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: AppSpacing.md),
      itemCount: actions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 6 : 3,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: isTablet ? 1.0 : 0.8,
      ),
      itemBuilder: (context, index) {
        final (label, icon, destination) = actions[index];
        return QuickActionCard(
          label: label,
          icon: icon,
          onTap: () =>
              ref.read(appDestinationProvider.notifier).go(destination),
        );
      },
    );
  }
}

class _FarmFlockPickerSheet extends StatelessWidget {
  const _FarmFlockPickerSheet({
    required this.selectedFarm,
    required this.selectedFlock,
    required this.onSelected,
  });

  final SampleFarm selectedFarm;
  final SampleFlock selectedFlock;
  final void Function(SampleFarm farm, SampleFlock flock) onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Farm & Flock',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            for (final flock in sampleFlocks)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  flock.id == selectedFlock.id
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: flock.id == selectedFlock.id
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                title: Text(flock.name),
                subtitle: Text(
                  '${sampleFarms.firstWhere((f) => f.id == flock.farmId).name} • ${flock.ageInWeeks}w • ${flock.birdCount} birds',
                ),
                onTap: () => onSelected(
                  sampleFarms.firstWhere((f) => f.id == flock.farmId),
                  flock,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
