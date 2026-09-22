import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Reusable navigation shell for reserved services awaiting full module mapping.
class ServicePlaceholderScreen extends StatelessWidget {
  const ServicePlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
    this.description,
  });

  final String title;
  final IconData icon;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 48,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(title, style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description ??
                    'This service is reserved and reachable from navigation.\n'
                    'Its fields and workflow are awaiting business/API details '
                    'before the form is built.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
