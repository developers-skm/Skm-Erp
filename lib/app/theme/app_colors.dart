import 'package:flutter/material.dart';

/// Centralized SKM Egg color palette.
///
/// Do not hardcode colors inside feature widgets — reference these tokens
/// (or the derived [ColorScheme] / [AppStatusColors] theme extension) instead.
abstract final class AppColors {
  // Brand — red / white / grey per the reference app's visual style.
  static const Color primaryRed = Color(0xFFE0281E);
  static const Color primaryRedDark = Color(0xFFB01E16);
  static const Color primaryRedLight = Color(0xFFEB5750);

  static const Color secondaryGrey = Color(0xFF6E6E6E);
  static const Color secondaryGreyLight = Color(0xFFD9D9D9);

  // Neutral / background
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFEDEDED);
  static const Color outline = Color(0xFFDADADA);

  // Text
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF5C5C5C);
  static const Color textDisabled = Color(0xFFA6A6A6);

  // Status
  static const Color success = Color(0xFF2E7D4F);
  static const Color warning = Color(0xFFC97F0E);
  static const Color error = Color(0xFFB01E16);
  static const Color production = Color(0xFF1D6E8C);

  // Sync states
  static const Color synced = Color(0xFF2E7D4F);
  static const Color pending = Color(0xFFC97F0E);
  static const Color failed = Color(0xFFB01E16);
  static const Color offline = Color(0xFF6E6E6E);
}

/// Theme extension exposing semantic status colors so widgets can pull
/// `Theme.of(context).extension<AppStatusColors>()` instead of importing
/// [AppColors] directly.
@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  const AppStatusColors({
    required this.success,
    required this.warning,
    required this.error,
    required this.production,
    required this.synced,
    required this.pending,
    required this.failed,
    required this.offline,
  });

  final Color success;
  final Color warning;
  final Color error;
  final Color production;
  final Color synced;
  final Color pending;
  final Color failed;
  final Color offline;

  static const AppStatusColors standard = AppStatusColors(
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    production: AppColors.production,
    synced: AppColors.synced,
    pending: AppColors.pending,
    failed: AppColors.failed,
    offline: AppColors.offline,
  );

  @override
  AppStatusColors copyWith({
    Color? success,
    Color? warning,
    Color? error,
    Color? production,
    Color? synced,
    Color? pending,
    Color? failed,
    Color? offline,
  }) {
    return AppStatusColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      production: production ?? this.production,
      synced: synced ?? this.synced,
      pending: pending ?? this.pending,
      failed: failed ?? this.failed,
      offline: offline ?? this.offline,
    );
  }

  @override
  AppStatusColors lerp(ThemeExtension<AppStatusColors>? other, double t) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      production: Color.lerp(production, other.production, t)!,
      synced: Color.lerp(synced, other.synced, t)!,
      pending: Color.lerp(pending, other.pending, t)!,
      failed: Color.lerp(failed, other.failed, t)!,
      offline: Color.lerp(offline, other.offline, t)!,
    );
  }
}
