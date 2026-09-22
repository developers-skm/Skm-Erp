import 'package:flutter/material.dart';

import '../../../../core/widgets/app_state_views.dart';
import '../../../vaccination/presentation/screens/add_vaccine_screen.dart';
import 'add_medicine_screen.dart';

/// Medicine and Vaccine — ONE visible service in the reference app,
/// internally split into Medicine / Vaccine tabs per the correction
/// (not two separate top-level nav items).
class MedicineVaccineScreen extends StatefulWidget {
  const MedicineVaccineScreen({super.key});

  @override
  State<MedicineVaccineScreen> createState() => _MedicineVaccineScreenState();
}

class _MedicineVaccineScreenState extends State<MedicineVaccineScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'MEDICINE'),
                Tab(text: 'VACCINE'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _MedicineTab(
                    onAdd: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddMedicineScreen(),
                      ),
                    ),
                  ),
                  _VaccineTab(
                    onAdd: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddVaccineScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicineTab extends StatelessWidget {
  const _MedicineTab({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const EmptyState(
        title: 'No medicine records yet',
        message: 'Entries you save will appear here once local storage is connected.',
        icon: Icons.medication_outlined,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Medicine'),
      ),
    );
  }
}

class _VaccineTab extends StatelessWidget {
  const _VaccineTab({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const EmptyState(
        title: 'No vaccination records yet',
        message: 'Entries you save will appear here once local storage is connected.',
        icon: Icons.vaccines_outlined,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Vaccine'),
      ),
    );
  }
}
