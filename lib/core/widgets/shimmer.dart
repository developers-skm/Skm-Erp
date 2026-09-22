import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Drives one shared sweep animation for every [SkeletonBox] beneath it,
/// so all placeholders shimmer in sync rather than each pulsing on its
/// own clock. The sheen is painted per-box (not across the whole
/// subtree) so it stays cheap inside a scrolling list.
class Shimmer extends StatefulWidget {
  const Shimmer({super.key, required this.child});

  final Widget child;

  @override
  State<Shimmer> createState() => _ShimmerState();

  static _ShimmerState? _of(BuildContext context) =>
      context.findAncestorStateOfType<_ShimmerState>();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// A single shimmer placeholder rectangle/pill. Must be used inside a
/// [Shimmer] ancestor, which drives the shared sweep animation.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 14,
    this.borderRadius = AppRadius.sm,
  });

  const SkeletonBox.circle({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = AppRadius.pill;

  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.colorScheme.onSurface.withValues(alpha: 0.1);
    final highlight = theme.colorScheme.onSurface.withValues(alpha: 0.22);
    final animation = Shimmer._of(context)?.controller;

    final box = DecoratedBox(
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: SizedBox(width: width, height: height),
    );

    if (animation == null) return box;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            final dx = animation.value * 2 - 1;
            return LinearGradient(
              begin: Alignment(dx - 0.7, -0.3),
              end: Alignment(dx + 0.7, 0.3),
              colors: [base, highlight, base],
              stops: const [0.35, 0.5, 0.65],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: box,
    );
  }
}
