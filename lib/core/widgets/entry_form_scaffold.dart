import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import 'primary_button.dart';

/// Shared layout for a data-entry form screen: scrollable content plus a
/// save button that stays reachable without awkward scrolling, and a
/// standard `<- Title` app bar (back navigation, not hamburger — per the
/// contextual-AppBar rule for sub-forms).
class EntryFormScaffold extends StatelessWidget {
  const EntryFormScaffold({
    super.key,
    required this.title,
    required this.children,
    required this.onSave,
    this.isSaving = false,
    this.saveLabel = 'Save',
  });

  final String title;
  final List<Widget> children;
  final VoidCallback onSave;
  final bool isSaving;
  final String saveLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final child in children) ...[
                      child,
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: PrimaryButton(
                  label: saveLabel,
                  isLoading: isSaving,
                  onPressed: isSaving ? null : onSave,
                  icon: Icons.check_rounded,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
