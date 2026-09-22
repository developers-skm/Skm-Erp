/// Centralized responsive breakpoints (logical pixels) shared by every
/// screen that needs to branch between phone / tablet layouts.
abstract final class AppBreakpoints {
  /// Below this width: compact phone layout (bottom navigation).
  static const double tablet = 720;

  /// At/above [tablet]: use NavigationRail / side navigation.
  static const double desktop = 1200;

  static bool isTablet(double width) => width >= tablet;

  static bool isDesktop(double width) => width >= desktop;
}
