import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_destination.dart';

/// Holds the single currently-selected top-level [AppDestination].
///
/// Every navigation trigger (Drawer item, NavigationRail item, Dashboard
/// Quick Entry card) reads/writes this same provider — there is exactly
/// one place that decides "what top-level screen is showing".
class AppDestinationController extends Notifier<AppDestination> {
  @override
  AppDestination build() => AppDestination.dashboard;

  void go(AppDestination destination) => state = destination;
}

final appDestinationProvider =
    NotifierProvider<AppDestinationController, AppDestination>(
      AppDestinationController.new,
    );
