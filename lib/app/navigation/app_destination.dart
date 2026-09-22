import 'package:flutter/material.dart';

/// Top-level SKM Egg service destinations.
///
/// This enum is the SINGLE source of truth for "what screen is currently
/// showing" at the app-shell level. Both the Drawer/NavigationRail and the
/// Dashboard's Quick Entry cards must navigate by setting this value via
/// [AppDestinationController] — never by maintaining a second, separate
/// index or route mechanism.
enum AppDestination {
  dashboard(
    label: 'Dashboard',
    icon: Icons.space_dashboard_outlined,
    selectedIcon: Icons.space_dashboard_rounded,
    group: AppDestinationGroup.services,
  ),
  mortality(
    label: 'Mortality',
    icon: Icons.monitor_heart_outlined,
    selectedIcon: Icons.monitor_heart_rounded,
    group: AppDestinationGroup.services,
  ),
  feedsEggs(
    label: 'Feeds & Eggs',
    icon: Icons.egg_outlined,
    selectedIcon: Icons.egg_rounded,
    group: AppDestinationGroup.services,
  ),
  medicineVaccine(
    label: 'Medicine & Vaccine',
    icon: Icons.medication_outlined,
    selectedIcon: Icons.medication_rounded,
    group: AppDestinationGroup.services,
  ),
  eggsTransfer(
    label: 'Eggs Transfer',
    icon: Icons.swap_horiz_rounded,
    selectedIcon: Icons.swap_horiz_rounded,
    group: AppDestinationGroup.services,
  ),
  eggSale(
    label: 'Egg Sale',
    icon: Icons.point_of_sale_outlined,
    selectedIcon: Icons.point_of_sale_rounded,
    group: AppDestinationGroup.services,
  ),
  disease(
    label: 'Disease',
    icon: Icons.coronavirus_outlined,
    selectedIcon: Icons.coronavirus_rounded,
    group: AppDestinationGroup.services,
  ),
  reports(
    label: 'Reports',
    icon: Icons.insert_chart_outlined_rounded,
    selectedIcon: Icons.insert_chart_rounded,
    group: AppDestinationGroup.management,
  ),
  sync(
    label: 'Sync Status',
    icon: Icons.cloud_sync_outlined,
    selectedIcon: Icons.cloud_sync_rounded,
    group: AppDestinationGroup.management,
  ),
  profile(
    label: 'Profile',
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
    group: AppDestinationGroup.account,
  ),
  settings(
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings_rounded,
    group: AppDestinationGroup.account,
  );

  const AppDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.group,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final AppDestinationGroup group;
}

/// Section grouping used to render the Drawer/Rail with headings
/// (SERVICES / MANAGEMENT / ACCOUNT).
enum AppDestinationGroup { services, management, account }
