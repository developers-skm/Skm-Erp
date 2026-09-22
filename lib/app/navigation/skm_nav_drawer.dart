import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../features/auth/presentation/widgets/skm_egg_logo.dart';
import 'app_destination.dart';

/// Premium, minimal side navigation drawer (phone) / sidebar content
/// (tablet rail header). Renders the SERVICES / MANAGEMENT / ACCOUNT
/// groups from [AppDestination] and highlights the active one.
///
/// Used both as the phone [Drawer] body and, in compact form, atop the
/// tablet [NavigationRail] — see [SkmNavSidebar].
class SkmNavDrawer extends StatelessWidget {
  const SkmNavDrawer({
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
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DrawerHeader(userName: userName, farmLabel: farmLabel),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                children: [
                  const _GroupLabel('SERVICES'),
                  for (final destination in AppDestination.values.where(
                    (d) => d.group == AppDestinationGroup.services,
                  ))
                    _DrawerItem(
                      destination: destination,
                      isSelected: destination == selected,
                      onTap: () {
                        Navigator.of(context).pop();
                        onSelected(destination);
                      },
                    ),
                  const Divider(
                    height: AppSpacing.xl,
                    indent: AppSpacing.lg,
                    endIndent: AppSpacing.lg,
                  ),
                  const _GroupLabel('MANAGEMENT'),
                  for (final destination in AppDestination.values.where(
                    (d) => d.group == AppDestinationGroup.management,
                  ))
                    _DrawerItem(
                      destination: destination,
                      isSelected: destination == selected,
                      onTap: () {
                        Navigator.of(context).pop();
                        onSelected(destination);
                      },
                    ),
                  const Divider(
                    height: AppSpacing.xl,
                    indent: AppSpacing.lg,
                    endIndent: AppSpacing.lg,
                  ),
                  const _GroupLabel('ACCOUNT'),
                  for (final destination in AppDestination.values.where(
                    (d) => d.group == AppDestinationGroup.account,
                  ))
                    _DrawerItem(
                      destination: destination,
                      isSelected: destination == selected,
                      onTap: () {
                        Navigator.of(context).pop();
                        onSelected(destination);
                      },
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            _LogoutTile(onTap: onLogout),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.userName, required this.farmLabel});

  final String userName;
  final String? farmLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SkmSidebarLogo(size: 44),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.appName, style: theme.textTheme.titleLarge),
                  Text(AppStrings.tagline, style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.12,
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName, style: theme.textTheme.labelLarge),
                    if (farmLabel != null)
                      Text(
                        farmLabel!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
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

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
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

class _LogoutTile extends StatelessWidget {
  const _LogoutTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(Icons.logout_rounded, color: theme.colorScheme.error),
      title: Text('Logout', style: TextStyle(color: theme.colorScheme.error)),
      onTap: onTap,
    );
  }
}
