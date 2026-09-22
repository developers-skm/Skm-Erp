import 'package:flutter/material.dart';

/// Centralized typography hierarchy for SKM Egg.
///
/// Built on top of [Typography.material2021] via [TextTheme] in
/// `app_theme.dart`. These helpers exist for the few places that need a
/// style not covered by the standard Material text theme (e.g. large KPI
/// numerals for field readability).
abstract final class AppTextStyles {
  /// Extra-large numeral style for KPI cards / dashboard values —
  /// intentionally larger than headlineLarge for readability in bright
  /// outdoor/farm conditions.
  static const TextStyle kpiValue = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle kpiLabel = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.2,
  );

  static const TextStyle numericInput = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
}
