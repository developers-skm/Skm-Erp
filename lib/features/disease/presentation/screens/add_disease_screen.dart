import 'package:flutter/material.dart';

import '../../../../core/constants/sample_data.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/entry_context_header.dart';
import '../../../../core/widgets/entry_form_scaffold.dart';
import '../../../../core/widgets/numeric_field.dart';
import '../../../../core/widgets/photo_attachment_field.dart';
import '../../../../core/widgets/searchable_selector.dart';

/// Add Disease entry — farm/shed/flock/date/age context, affected birds,
/// mortality, disease/symptoms, remarks and photo attachments, matching
/// the reference app's disease-reporting workflow.
class AddDiseaseScreen extends StatefulWidget {
  const AddDiseaseScreen({super.key});

  @override
  State<AddDiseaseScreen> createState() => _AddDiseaseScreenState();
}

class _AddDiseaseScreenState extends State<AddDiseaseScreen> {
  DateTime _date = DateTime.now();
  String? _disease;
  final _affectedBirdsController = TextEditingController();
  final _mortalityController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _remarksController = TextEditingController();
  int _photoCount = 0;

  static const _diseases = [
    'Newcastle Disease',
    'Infectious Bronchitis',
    'Coccidiosis',
    'Fowl Typhoid',
    'Other',
  ];

  @override
  void dispose() {
    _affectedBirdsController.dispose();
    _mortalityController.dispose();
    _symptomsController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Disease entry saved (local demo only)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flock = sampleFlocks.first;
    final farm = sampleFarms.first;

    return EntryFormScaffold(
      title: 'Add Disease',
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
          label: 'Disease / Condition',
          items: _diseases,
          itemLabel: (item) => item,
          selected: _disease,
          required: true,
          onSelected: (value) => setState(() => _disease = value),
        ),
        Row(
          children: [
            Expanded(
              child: NumericField(
                label: 'Affected Birds',
                controller: _affectedBirdsController,
                unit: 'birds',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NumericField(
                label: 'Mortality',
                controller: _mortalityController,
                unit: 'birds',
              ),
            ),
          ],
        ),
        AppTextField(
          label: 'Symptoms',
          controller: _symptomsController,
          hint: 'Describe observed symptoms',
          maxLines: 3,
        ),
        AppTextField(
          label: 'Remarks',
          controller: _remarksController,
          hint: 'Optional notes',
          maxLines: 3,
        ),
        PhotoAttachmentField(
          count: _photoCount,
          onAdd: () => setState(() => _photoCount++),
          onRemove: (_) => setState(() => _photoCount--),
        ),
      ],
    );
  }
}
