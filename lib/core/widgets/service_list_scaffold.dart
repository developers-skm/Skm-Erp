import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import 'app_state_views.dart';

/// Shared layout for a "service" screen that lists existing records and
/// offers an "Add" action leading to that service's entry form.
///
/// Mortality, Disease, Medicine & Vaccine and Egg Sale all follow this
/// same shape in the reference app: a record list plus a prominent add
/// action. Phase 2 shows [EmptyState] since no repository/API is wired
/// yet — the list itself is not fabricated data.
class ServiceListScaffold extends StatelessWidget {
  const ServiceListScaffold({
    super.key,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.addLabel,
    required this.onAdd,
    this.headerBuilder,
  });

  final String emptyTitle;
  final String emptyMessage;
  final IconData emptyIcon;
  final String addLabel;
  final VoidCallback onAdd;

  /// Optional widget shown above the list (e.g. farm/flock context or
  /// date filter) — kept generic so each service can supply what it needs.
  final WidgetBuilder? headerBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (headerBuilder != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  0,
                ),
                child: headerBuilder!(context),
              ),
            Expanded(
              child: EmptyState(
                title: emptyTitle,
                message: emptyMessage,
                icon: emptyIcon,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded),
        label: Text(addLabel),
      ),
    );
  }
}
