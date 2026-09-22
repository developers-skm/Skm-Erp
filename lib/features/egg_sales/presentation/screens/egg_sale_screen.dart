import 'package:flutter/material.dart';

import '../../../../core/widgets/service_list_scaffold.dart';
import 'add_egg_sale_screen.dart';

/// Egg Sale service — record list + entry point for Add Egg Sale.
class EggSaleScreen extends StatelessWidget {
  const EggSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ServiceListScaffold(
      emptyTitle: 'No egg sales recorded yet',
      emptyMessage:
          'Sales you record will appear here once local storage is connected.',
      emptyIcon: Icons.point_of_sale_outlined,
      addLabel: 'Add Egg Sale',
      onAdd: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddEggSaleScreen()),
        );
      },
    );
  }
}
