import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../features/auth/presentation/widgets/skm_egg_logo.dart';
import 'app_destination.dart';

/// Persistent tablet sidebar — the wide-screen equivalent of
/// [SkmNavDrawer], always visible (not opened/closed) and given a fixed
/// width panel rather than [NavigationRail]'s icon-only compact strip,
/// so the SERVICES/MANAGEMENT/ACCOUNT groups stay readable.
class SkmNavSidebar extends StatelessWidget {
  const SkmNavSidebar({
    super.key,
    required this.userName,
    required this.farmLabel,
    required this.selected,
    required this.onSelected,
    required this.onLogout,
  });

  final String userName;
  final String? farmLabel;
  final AppDestination selected;
  final ValueChanged<AppDestination> onSelected;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 260,
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  const SkmSidebarLogo(size: 40),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.appName,
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          farmLabel ?? AppStrings.tagline,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                children: [
                  const _GroupLabel('SERVICES'),
                  for (final destination in AppDestination.values.where(
                    (d) => d.group == AppDestinationGroup.services,
                  ))
                    _SidebarItem(
                      destination: destination,
                      isSelected: destination == selected,
                      onTap: () => onSelected(destination),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  const _GroupLabel('MANAGEMENT'),
                  for (final destination in AppDestination.values.where(
                    (d) => d.group == AppDestinationGroup.management,
                  ))
                    _SidebarItem(
                      destination: destination,
                      isSelected: destination == selected,
                      onTap: () => onSelected(destination),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  const _GroupLabel('ACCOUNT'),
                  for (final destination in AppDestination.values.where(
                    (d) => d.group == AppDestinationGroup.account,
                  ))
                    _SidebarItem(
                      destination: destination,
                      isSelected: destination == selected,
                      onTap: () => onSelected(destination),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                color: theme.colorScheme.error,
              ),
              title: Text(
                'Logout',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          letterSpacing: 0.8,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final AppDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedBg = theme.colorScheme.primary.withValues(alpha: 0.10);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      child: Material(
        color: isSelected ? selectedBg : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? destination.selectedIcon : destination.icon,
                  size: 22,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    destination.label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
