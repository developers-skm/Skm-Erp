import 'package:flutter/material.dart';

import '../../../../core/widgets/service_list_scaffold.dart';
import 'add_disease_screen.dart';

/// Disease service — record list + entry point for Add Disease.
class DiseaseScreen extends StatelessWidget {
  const DiseaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ServiceListScaffold(
      emptyTitle: 'No disease records yet',
      emptyMessage:
          'Entries you save will appear here once local storage is connected.',
      emptyIcon: Icons.coronavirus_outlined,
      addLabel: 'Add Disease',
      onAdd: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddDiseaseScreen()),
        );
      },
    );
  }
}
