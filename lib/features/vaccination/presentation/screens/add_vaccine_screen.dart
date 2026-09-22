import 'package:flutter/material.dart';

import '../../../../core/constants/sample_data.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/entry_context_header.dart';
import '../../../../core/widgets/entry_form_scaffold.dart';
import '../../../../core/widgets/numeric_field.dart';
import '../../../../core/widgets/searchable_selector.dart';

/// Add Vaccine entry — vaccine, quantity, method, remarks per the
/// reference app's vaccination workflow.
class AddVaccineScreen extends StatefulWidget {
  const AddVaccineScreen({super.key});

  @override
  State<AddVaccineScreen> createState() => _AddVaccineScreenState();
}

class _AddVaccineScreenState extends State<AddVaccineScreen> {
  DateTime _date = DateTime.now();
  String? _vaccineName;
  String? _method;
  final _quantityController = TextEditingController();
  final _remarksController = TextEditingController();

  static const _sampleVaccines = [
    'Newcastle Disease (ND)',
    'Infectious Bursal Disease (IBD)',
    'Fowl Pox',
    'Infectious Bronchitis (IB)',
  ];

  static const _methods = ['Drinking Water', 'Eye Drop', 'Injection', 'Spray'];

  @override
  void dispose() {
    _quantityController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vaccine entry saved (local demo only)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flock = sampleFlocks.first;
    final farm = sampleFarms.first;

    return EntryFormScaffold(
      title: 'Add Vaccine',
      onSave: _save,
      children: [
        EntryContextHeader(
          farmName: farm.name,
          flockName: flock.name,
          date: _date,
          onDateChanged: (value) => setState(() => _date = value),
          ageInWeeks: flock.ageInWeeks,
        ),
        SearchableSelector<String>(
          label: 'Vaccine',
          items: _sampleVaccines,
          itemLabel: (item) => item,
          selected: _vaccineName,
          required: true,
          onSelected: (value) => setState(() => _vaccineName = value),
        ),
        NumericField(
          label: 'Quantity',
          controller: _quantityController,
          unit: 'doses',
          allowDecimal: true,
        ),
        SearchableSelector<String>(
          label: 'Method',
          items: _methods,
          itemLabel: (item) => item,
          selected: _method,
          onSelected: (value) => setState(() => _method = value),
        ),
        AppTextField(
          label: 'Remarks',
          controller: _remarksController,
          hint: 'Optional notes',
          maxLines: 3,
        ),
      ],
    );
  }
}
