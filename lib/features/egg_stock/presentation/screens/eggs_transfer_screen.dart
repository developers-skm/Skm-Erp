import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

/// Eggs Transfer — a visible service in the reference application.
///
/// Its detailed business fields (source/destination farm, tray/egg unit
/// conversion, transfer approval flow, etc.) are not yet known, so this
/// is intentionally a navigation-only shell: it establishes the
/// destination and route, but invents no fields or API contract.
/// AWAITING BUSINESS/API MAPPING — do not treat this as final.
class EggsTransferScreen extends StatelessWidget {
  const EggsTransferScreen({super.key});

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
                Icons.swap_horiz_rounded,
                size: 48,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Eggs Transfer', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
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
