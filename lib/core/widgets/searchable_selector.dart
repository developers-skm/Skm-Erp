import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// A tappable field that opens a searchable bottom sheet list — used for
/// long lists (farms, flocks, medicines, customers) instead of a
/// standard [DropdownButton] which gets unusable once a list grows.
class SearchableSelector<T> extends StatelessWidget {
  const SearchableSelector({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    required this.onSelected,
    this.selected,
    this.hint = 'Select',
    this.required = false,
  });

  final String label;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T> onSelected;
  final T? selected;
  final String hint;
  final bool required;

  Future<void> _openPicker(BuildContext context) async {
    final result = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) =>
          _SelectorSheet<T>(title: label, items: items, itemLabel: itemLabel),
    );
    if (result != null) onSelected(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        InkWell(
          onTap: () => _openPicker(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.4,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selected != null ? itemLabel(selected as T) : hint,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: selected != null
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(
                  Icons.unfold_more_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectorSheet<T> extends StatefulWidget {
  const _SelectorSheet({
    required this.title,
    required this.items,
    required this.itemLabel,
  });

  final String title;
  final List<T> items;
  final String Function(T item) itemLabel;

  @override
  State<_SelectorSheet<T>> createState() => _SelectorSheetState<T>();
}

class _SelectorSheetState<T> extends State<_SelectorSheet<T>> {
  late List<T> _filtered = widget.items;
  final _searchController = TextEditingController();

  void _filter(String query) {
    setState(() {
      _filtered = widget.items
          .where(
            (item) => widget
                .itemLabel(item)
                .toLowerCase()
                .contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _searchController,
              onChanged: _filter,
              decoration: const InputDecoration(
                hintText: 'Search…',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: _filtered.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Text('No matches found'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final item = _filtered[index];
                        return ListTile(
                          title: Text(widget.itemLabel(item)),
                          onTap: () => Navigator.of(context).pop(item),
                        );
                      },
                    ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
