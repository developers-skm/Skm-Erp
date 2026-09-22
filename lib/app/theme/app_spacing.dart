/// Centralized spacing scale. Use these instead of magic numbers in widgets.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Centralized corner-radius scale.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;
}

/// Minimum recommended touch target size for farm/field use
/// (larger than Material's 48dp minimum for easier gloved/quick taps).
abstract final class AppTouchTarget {
  static const double minHeight = 52;
  static const double comfortableHeight = 56;
}
