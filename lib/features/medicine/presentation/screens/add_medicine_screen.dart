import 'package:flutter/material.dart';

import '../../../../core/constants/sample_data.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/entry_context_header.dart';
import '../../../../core/widgets/entry_form_scaffold.dart';
import '../../../../core/widgets/numeric_field.dart';
import '../../../../core/widgets/searchable_selector.dart';

/// Add Medicine entry — supports multiple medicine line items, matching
/// the reference app's item-based medicine consumption workflow.
class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _MedicineLine {
  _MedicineLine();
  String? medicineName;
  final quantityController = TextEditingController();
  String unit = 'ml';
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  DateTime _date = DateTime.now();
  final _reasonController = TextEditingController();
  final List<_MedicineLine> _lines = [_MedicineLine()];

  static const _sampleMedicines = [
    'Amoxicillin',
    'Enrofloxacin',
    'Multivitamin Syrup',
    'Electrolyte Powder',
    'Doxycycline',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    for (final line in _lines) {
      line.quantityController.dispose();
    }
    super.dispose();
  }

  void _save() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Medicine entry saved (local demo only)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flock = sampleFlocks.first;
    final farm = sampleFarms.first;

    return EntryFormScaffold(
      title: 'Add Medicine',
      onSave: _save,
      children: [
        EntryContextHeader(
          farmName: farm.name,
          flockName: flock.name,
          date: _date,
          onDateChanged: (value) => setState(() => _date = value),
          ageInWeeks: flock.ageInWeeks,
        ),
        for (var i = 0; i < _lines.length; i++)
          _MedicineLineCard(
            line: _lines[i],
            index: i,
            canRemove: _lines.length > 1,
            medicines: _sampleMedicines,
            onRemove: () => setState(() => _lines.removeAt(i)),
            onChanged: () => setState(() {}),
          ),
        OutlinedButton.icon(
          onPressed: () => setState(() => _lines.add(_MedicineLine())),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Another Medicine'),
        ),
        AppTextField(
          label: 'Reason / Remarks',
          controller: _reasonController,
          hint: 'Optional notes',
          maxLines: 3,
        ),
      ],
    );
  }
}

class _MedicineLineCard extends StatelessWidget {
  const _MedicineLineCard({
    required this.line,
    required this.index,
    required this.canRemove,
    required this.medicines,
    required this.onRemove,
    required this.onChanged,
  });

  final _MedicineLine line;
  final int index;
  final bool canRemove;
  final List<String> medicines;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Medicine ${index + 1}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const Spacer(),
                if (canRemove)
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: onRemove,
                  ),
              ],
            ),
            SearchableSelector<String>(
              label: 'Medicine',
              items: medicines,
              itemLabel: (item) => item,
              selected: line.medicineName,
              required: true,
              onSelected: (value) {
                line.medicineName = value;
                onChanged();
              },
            ),
            const SizedBox(height: 12),
            NumericField(
              label: 'Quantity',
              controller: line.quantityController,
              unit: line.unit,
              allowDecimal: true,
            ),
          ],
        ),
      ),
    );
  }
}
