import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';

/// Main SKM brand logo used on login, splash, and about screens.
/// Displays the new logo from [AppAssets.skmLogoNew].
class SkmEggLogo extends StatelessWidget {
  const SkmEggLogo({
    super.key,
    this.size = 110,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  final double size;
  final double? height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? size;
    return Image.asset(
      AppAssets.skmLogoNew,
      height: effectiveHeight,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        height: effectiveHeight,
        width: width ?? effectiveHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.egg_rounded,
          size: effectiveHeight * 0.5,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

/// Compact SKM favicon logo used in the sidebar navigation header and drawer.
/// Displays [AppAssets.favicon].
class SkmSidebarLogo extends StatelessWidget {
  const SkmSidebarLogo({
    super.key,
    this.size = 40,
    this.borderRadius = 8.0,
  });

  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        AppAssets.favicon,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => CircleAvatar(
          radius: size / 2,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            'SKM',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: size * 0.35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
