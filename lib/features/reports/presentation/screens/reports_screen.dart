import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/date_selector.dart';
import '../../../../core/widgets/searchable_selector.dart';
import '../../../../core/widgets/skm_card.dart';

/// Reports — an application utility reachable from navigation, not a
/// primary top-level tab. Establishes the filter UI (date range,
/// farm/flock, category) and the phone-list / tablet-table layout split;
/// no report data or backend API is fabricated.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _from = DateTime.now().subtract(const Duration(days: 7));
  DateTime _to = DateTime.now();
  String? _category;

  static const _categories = [
    'Production',
    'Mortality',
    'Feed',
    'Medicine',
    'Vaccination',
    'Disease',
    'Egg Sales',
    'Egg Stock',
  ];

  @override
  Widget build(BuildContext context) {
    final isTablet = AppBreakpoints.isTablet(MediaQuery.sizeOf(context).width);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SkmCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SearchableSelector<String>(
                      label: 'Report Category',
                      items: _categories,
                      itemLabel: (item) => item,
                      selected: _category,
                      onSelected: (value) => setState(() => _category = value),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: DateSelector(
                            label: 'From',
                            value: _from,
                            onChanged: (value) => setState(() => _from = value),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: DateSelector(
                            label: 'To',
                            value: _to,
                            onChanged: (value) => setState(() => _to = value),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: EmptyState(
                title: 'No report data yet',
                message: isTablet
                    ? 'Results will appear as a data table once reporting APIs are connected.'
                    : 'Results will appear as a list once reporting APIs are connected.',
                icon: Icons.insert_chart_outlined_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
