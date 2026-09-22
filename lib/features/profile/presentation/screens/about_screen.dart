import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/widgets/skm_egg_logo.dart';

/// About — app identity/version info, reachable from Settings.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Center(child: SkmEggLogo(size: 72)),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Text(
                AppStrings.appName,
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: Text(
                AppStrings.tagline,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const _InfoRow(label: 'Version', value: '1.0.0'),
            const _InfoRow(
              label: 'Build mode',
              value: kReleaseMode ? 'Release' : 'Debug',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Text(label, style: theme.textTheme.bodyLarge),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
