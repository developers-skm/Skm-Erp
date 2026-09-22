import 'package:flutter/material.dart';

import '../../../../core/constants/sample_data.dart';
import '../../../../core/widgets/farm_flock_selector.dart';
import '../../../../core/widgets/service_list_scaffold.dart';
import 'add_mortality_screen.dart';

/// Mortality service — record list + entry point for Add Mortality.
///
/// No repository is wired yet, so this shows the empty state rather than
/// fabricated mortality records. Pushing [AddMortalityScreen] uses the
/// destination's own nested Navigator (see AppShell), so Android back
/// correctly returns here instead of leaving the service.
class MortalityScreen extends StatelessWidget {
  const MortalityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ServiceListScaffold(
      headerBuilder: (context) => Align(
        alignment: Alignment.centerLeft,
        child: FarmFlockSelector(
          farmName: sampleFarms.first.name,
          flockName: sampleFlocks.first.name,
          onTap: () {},
        ),
      ),
      emptyTitle: 'No mortality records yet',
      emptyMessage:
          'Entries you save will appear here once local storage is connected.',
      emptyIcon: Icons.monitor_heart_outlined,
      addLabel: 'Add Mortality',
      onAdd: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddMortalityScreen()),
        );
      },
    );
  }
}
