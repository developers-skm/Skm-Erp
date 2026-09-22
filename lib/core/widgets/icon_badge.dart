import 'package:flutter/material.dart';

/// Small icon with an optional numeric badge, suitable for AppBar actions
/// (sync status, notifications). Shared so every icon+count indicator in
/// the app looks and behaves the same way.
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.badgeColor,
    this.count = 0,
    this.semanticLabel,
    this.iconSize = 24,
  });

  final IconData icon;
  final Color color;

  /// Background color of the numeric badge. Defaults to [color] — pass a
  /// distinct accent (e.g. amber) when [color] is something low-contrast
  /// against its own badge, such as white on an AppBar.
  final Color? badgeColor;
  final int count;
  final String? semanticLabel;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final resolvedBadgeColor = badgeColor ?? color;
    return Semantics(
      label: semanticLabel,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: color, size: iconSize),
            if (count > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  constraints: const BoxConstraints(minWidth: 16),
                  decoration: BoxDecoration(
                    color: resolvedBadgeColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
