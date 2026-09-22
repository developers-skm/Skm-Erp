import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/sample_data.dart';
import '../../core/sync/sync_status.dart';
import '../../core/widgets/icon_badge.dart';
import '../../core/widgets/sync_status_chip.dart';
import '../../features/disease/presentation/screens/disease_screen.dart';
import '../../features/egg_sales/presentation/screens/egg_sale_screen.dart';
import '../../features/egg_stock/presentation/screens/eggs_transfer_screen.dart';
import '../../features/feed/presentation/screens/feeds_eggs_screen.dart';
import '../../features/medicine/presentation/screens/medicine_vaccine_screen.dart';
import '../../features/mortality/presentation/screens/mortality_screen.dart';
import '../../features/notifications/data/notification_sample_data.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/sync/presentation/screens/sync_status_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import 'app_destination.dart';
import 'app_destination_provider.dart';
import 'skm_nav_drawer.dart';
import 'skm_nav_sidebar.dart';

/// The ONE application shell. Owns:
///  - contextual AppBar (title changes with destination; hamburger vs back)
///  - phone Drawer / tablet persistent sidebar (same [AppDestination] state)
///  - a per-destination [Navigator] so pushing a sub-form (e.g. Add
///    Mortality) and pressing Android back returns to the destination's
///    own list screen instead of leaving the shell or the app.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.userName, required this.onLogout});

  final String userName;
  final VoidCallback onLogout;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  /// One nested Navigator key per destination so each service keeps its
  /// own back-stack (list screen <-> its own sub-forms) independent of
  /// the others, without introducing a second competing router.
  final Map<AppDestination, GlobalKey<NavigatorState>> _navigatorKeys = {
    for (final destination in AppDestination.values)
      destination: GlobalKey<NavigatorState>(),
  };

  /// Tracks whether each destination's nested Navigator is showing a
  /// pushed sub-route (e.g. Add Mortality) rather than its own root list
  /// screen. When true, the outer shell AppBar (hamburger + title + sync)
  /// is hidden so it never appears stacked on top of the sub-form's own
  /// `<- Title` AppBar.
  final Map<AppDestination, bool> _showingSubRoute = {
    for (final destination in AppDestination.values) destination: false,
  };

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> _handleBack(AppDestination current) async {
    final navigator = _navigatorKeys[current]!.currentState!;
    if (navigator.canPop()) {
      navigator.pop();
      return false;
    }
    return true;
  }

  /// Opens Notifications on top of whichever destination is currently
  /// visible, using that destination's own nested Navigator so Android
  /// back returns to it correctly (same pattern as Add Mortality, etc.).
  void _openNotifications(AppDestination current) {
    _navigatorKeys[current]!.currentState!.push(
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
  }

  Widget _buildDestinationNavigator(AppDestination destination) {
    return Navigator(
      key: _navigatorKeys[destination],
      observers: [
        _SubRouteObserver(
          onDepthChanged: (isSubRoute) {
            if (_showingSubRoute[destination] == isSubRoute) return;
            // Defer to next frame: observers fire during navigation,
            // before it's safe to call setState.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() => _showingSubRoute[destination] = isSubRoute);
            });
          },
        ),
      ],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => _screenFor(destination),
        );
      },
    );
  }

  Widget _screenFor(AppDestination destination) {
    switch (destination) {
      case AppDestination.dashboard:
        return DashboardScreen(userName: widget.userName);
      case AppDestination.mortality:
        return const MortalityScreen();
      case AppDestination.feedsEggs:
        return const FeedsEggsScreen();
      case AppDestination.medicineVaccine:
        return const MedicineVaccineScreen();
      case AppDestination.eggsTransfer:
        return const EggsTransferScreen();
      case AppDestination.eggSale:
        return const EggSaleScreen();
      case AppDestination.disease:
        return const DiseaseScreen();
      case AppDestination.reports:
        return const ReportsScreen();
      case AppDestination.sync:
        return const SyncStatusScreen();
      case AppDestination.profile:
        return ProfileScreen(
          userName: widget.userName,
          onLogout: widget.onLogout,
        );
      case AppDestination.settings:
        return const SettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(appDestinationProvider);
    final isTablet = AppBreakpoints.isTablet(MediaQuery.sizeOf(context).width);
    final farmLabel = '${sampleFarms.first.name} • ${sampleFlocks.first.name}';

    void select(AppDestination destination) {
      if (destination == selected) return;
      ref.read(appDestinationProvider.notifier).go(destination);
    }

    final body = IndexedStack(
      index: AppDestination.values.indexOf(selected),
      children: [
        for (final destination in AppDestination.values)
          _buildDestinationNavigator(destination),
      ],
    );

    final onSubRoute = _showingSubRoute[selected] ?? false;
    final unreadNotifications = sampleNotifications
        .where((n) => !n.read)
        .length;

    if (!isTablet) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          final shouldPopApp = await _handleBack(selected);
          if (shouldPopApp && context.mounted) {
            // At the root of a destination's stack: allow the system to
            // handle the back press natively (e.g. exit app on Dashboard).
            Navigator.of(context).maybePop();
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          // Hidden once a sub-form is pushed — that screen supplies its
          // own `<- Title` AppBar, so only one AppBar is ever visible.
          appBar: onSubRoute
              ? null
              : AppBar(
                  leading: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu_rounded),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  title: Text(selected.label),
                  actions: [
                    InkWell(
                      onTap: () => _openNotifications(selected),
                      borderRadius: BorderRadius.circular(999),
                      child: IconBadge(
                        icon: Icons.notifications_outlined,
                        color: Colors.white,
                        badgeColor: AppColors.warning,
                        count: unreadNotifications,
                        semanticLabel: 'Notifications',
                      ),
                    ),
                    SyncStatusChip(
                      status: SyncStatus.pending,
                      pendingCount: 3,
                      compact: true,
                      onTap: () => select(AppDestination.sync),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
          drawer: SkmNavDrawer(
            userName: widget.userName,
            farmLabel: farmLabel,
            selected: selected,
            onSelected: select,
            onLogout: widget.onLogout,
          ),
          body: body,
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          SkmNavSidebar(
            userName: widget.userName,
            farmLabel: farmLabel,
            selected: selected,
            onSelected: select,
            onLogout: widget.onLogout,
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, _) async {
                if (didPop) return;
                await _handleBack(selected);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!onSubRoute)
                    AppBar(
                      automaticallyImplyLeading: false,
                      title: Text(selected.label),
                      actions: [
                        InkWell(
                          onTap: () => _openNotifications(selected),
                          borderRadius: BorderRadius.circular(999),
                          child: IconBadge(
                            icon: Icons.notifications_outlined,
                            color: Colors.white,
                            badgeColor: AppColors.warning,
                            count: unreadNotifications,
                            semanticLabel: 'Notifications',
                          ),
                        ),
                        SyncStatusChip(
                          status: SyncStatus.pending,
                          pendingCount: 3,
                          compact: true,
                          onTap: () => select(AppDestination.sync),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  Expanded(child: body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reports whether a destination's nested [Navigator] is showing more
/// than its root route (i.e. a sub-form like Add Mortality is pushed).
class _SubRouteObserver extends NavigatorObserver {
  _SubRouteObserver({required this.onDepthChanged});

  final ValueChanged<bool> onDepthChanged;
  int _depth = 0;

  void _report() => onDepthChanged(_depth > 1);

  @override
  void didPush(Route route, Route? previousRoute) {
    _depth++;
    _report();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _depth = _depth > 0 ? _depth - 1 : 0;
    _report();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _depth = _depth > 0 ? _depth - 1 : 0;
    _report();
  }
}
