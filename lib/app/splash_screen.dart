import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../features/auth/presentation/widgets/skm_egg_logo.dart';
import 'theme/app_spacing.dart';

/// Brief branded startup screen shown while the app initializes
/// (session/local-db bootstrap will hook in here in a later phase).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1100), widget.onFinished);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SkmEggLogo(size: 96),
            const SizedBox(height: AppSpacing.lg),
            Text(AppStrings.appName, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(AppStrings.tagline, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
