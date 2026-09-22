import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/skm_card.dart';
import '../../../../core/widgets/status_chip.dart';

/// Sync Status screen — shows the aggregate sync state and a "Sync Now"
/// action. No real sync engine is wired yet; this establishes the UI
/// that a future [SyncService] will drive.
class SyncStatusScreen extends StatelessWidget {
  const SyncStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).extension<AppStatusColors>() ??
        AppStatusColors.standard;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SkmCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.cloud_sync_rounded,
                          color: colors.pending,
                          size: 28,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '3 records waiting',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const StatusChip(
                                label: 'Pending',
                                color: AppColors.pending,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PrimaryButton(
                      label: 'Sync Now',
                      icon: Icons.sync_rounded,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Sync will run once connected to a backend',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Expanded(
                child: EmptyState(
                  title: 'No pending record details yet',
                  message: 'Per-record sync status will be listed here once local storage is connected.',
                  icon: Icons.receipt_long_outlined,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
