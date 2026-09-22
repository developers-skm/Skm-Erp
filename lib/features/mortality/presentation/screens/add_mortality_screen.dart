import 'package:flutter/material.dart';

import '../../../../core/constants/sample_data.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/entry_context_header.dart';
import '../../../../core/widgets/entry_form_scaffold.dart';
import '../../../../core/widgets/numeric_field.dart';
import '../../../../core/widgets/photo_attachment_field.dart';

/// Add Mortality entry form. Fields mirror the reference app's workflow:
/// farm/flock/date/age context, mortality + culls counts, optional room
/// temperature and remarks, and photo attachments.
///
/// No backend/local persistence is wired yet — Save currently just pops
/// back to the Mortality list as a UI-flow placeholder.
class AddMortalityScreen extends StatefulWidget {
  const AddMortalityScreen({super.key});

  @override
  State<AddMortalityScreen> createState() => _AddMortalityScreenState();
}

class _AddMortalityScreenState extends State<AddMortalityScreen> {
  DateTime _date = DateTime.now();
  final _mortalityController = TextEditingController();
  final _cullsController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _remarksController = TextEditingController();
  int _photoCount = 0;

  @override
  void dispose() {
    _mortalityController.dispose();
    _cullsController.dispose();
    _temperatureController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mortality entry saved (local demo only)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flock = sampleFlocks.first;
    final farm = sampleFarms.first;

    return EntryFormScaffold(
      title: 'Add Mortality',
      onSave: _save,
      children: [
        EntryContextHeader(
          farmName: farm.name,
          flockName: flock.name,
          date: _date,
          onDateChanged: (value) => setState(() => _date = value),
          ageInWeeks: flock.ageInWeeks,
        ),
        Row(
          children: [
            Expanded(
              child: NumericField(
                label: 'Mortality',
                controller: _mortalityController,
                unit: 'birds',
                required: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NumericField(
                label: 'Culls',
                controller: _cullsController,
                unit: 'birds',
              ),
            ),
          ],
        ),
        NumericField(
          label: 'Room Temperature',
          controller: _temperatureController,
          unit: '°C',
          allowDecimal: true,
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
