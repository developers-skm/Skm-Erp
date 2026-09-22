import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

/// Language selection — placeholder screen reachable from Settings.
/// No localization pipeline is wired yet; English is the only option.
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selected = 'English';

  static const _languages = ['English', 'Hindi', 'Tamil', 'Telugu'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: SafeArea(
        child: RadioGroup<String>(
          groupValue: _selected,
          onChanged: (value) {
            setState(() => _selected = value!);
            if (value != 'English') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$value support is coming soon')),
              );
            }
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            children: [
              for (final language in _languages)
                RadioListTile<String>(title: Text(language), value: language),
            ],
          ),
        ),
      ),
    );
  }
}
