import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';

/// Large, farm-friendly numeric input with a visible unit suffix
/// (e.g. "kg", "birds", "eggs"). Uses the numeric/decimal keyboard and
/// large text so values are easy to enter and verify at a glance.
class NumericField extends StatelessWidget {
  const NumericField({
    super.key,
    required this.label,
    this.controller,
    this.unit,
    this.allowDecimal = false,
    this.required = false,
    this.hint = '0',
    this.errorText,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController? controller;
  final String? unit;
  final bool allowDecimal;
  final bool required;
  final String hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pattern = allowDecimal ? r'^\d*\.?\d{0,2}$' : r'^\d*$';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: theme.textTheme.labelLarge,
            children: [
              TextSpan(text: label),
              if (required)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
          textInputAction: textInputAction ?? TextInputAction.next,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(pattern))],
          style: AppTextStyles.numericInput.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            suffixText: unit,
            suffixStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
