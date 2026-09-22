import 'package:flutter/material.dart';

/// Original SKM Egg mark — a simple abstract egg-in-shield motif rendered
/// purely in code (no external/copied assets).
class SkmEggLogo extends StatelessWidget {
  const SkmEggLogo({super.key, this.size = 88});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Center(
        child: Container(
          width: size * 0.46,
          height: size * 0.6,
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(size * 0.23),
              topRight: Radius.circular(size * 0.23),
              bottomLeft: Radius.circular(size * 0.3),
              bottomRight: Radius.circular(size * 0.3),
            ),
          ),
        ),
      ),
    );
  }
}
