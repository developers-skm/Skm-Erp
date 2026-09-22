import 'package:flutter/material.dart';

import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/date_selector.dart';
import '../../../../core/widgets/numeric_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/searchable_selector.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/skm_card.dart';
import '../../application/egg_sale_totals.dart';

/// Add Egg Sale — modernized version of the reference app's sale entry,
/// organized into four clear sections: Sale Information, Customer &
/// Transport, Items, and Summary.
///
/// Calculations (tax/TCS, totals) are delegated to [EggSaleTotalsService]
/// so real business rules can be dropped in later without touching this
/// screen. No tax formula is invented here.
class AddEggSaleScreen extends StatefulWidget {
  const AddEggSaleScreen({super.key});

  @override
  State<AddEggSaleScreen> createState() => _AddEggSaleScreenState();
}

class _SaleItemRow {
  _SaleItemRow();
  String? eggType;
  final quantityController = TextEditingController();
  final rateController = TextEditingController();

  double get quantity => double.tryParse(quantityController.text) ?? 0;
  double get rate => double.tryParse(rateController.text) ?? 0;
}

class _AddEggSaleScreenState extends State<AddEggSaleScreen> {
  DateTime _date = DateTime.now();
  final _invoiceNoController = TextEditingController();
  String? _invoiceType;
  String? _creditTerm;
  final _vehicleController = TextEditingController();
  final _driverController = TextEditingController();
  String? _customer;
  final List<_SaleItemRow> _items = [_SaleItemRow()];

  static const _invoiceTypes = ['Cash', 'Credit', 'Advance'];
  static const _creditTerms = ['Immediate', '7 Days', '15 Days', '30 Days'];
  static const _customers = [
    'Sri Balaji Traders',
    'Anand Egg Distributors',
    'Kaveri Wholesale',
  ];
  static const _eggTypes = [
    'Table Egg',
    'Extra Large',
    'Medium',
    'Cracked / B-Grade',
  ];

  @override
  void dispose() {
    _invoiceNoController.dispose();
    _vehicleController.dispose();
    _driverController.dispose();
    for (final item in _items) {
      item.quantityController.dispose();
      item.rateController.dispose();
    }
    super.dispose();
  }

  void _save() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Egg sale saved (local demo only)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totals = EggSaleTotalsService.calculate(
      lineAmounts: [for (final item in _items) item.quantity * item.rate],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Add Egg Sale')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SectionHeader(
                    title: 'Sale Information',
                    padding: EdgeInsets.only(bottom: 8),
                  ),
                  SkmCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DateSelector(
                          label: 'Date',
                          value: _date,
                          onChanged: (value) => setState(() => _date = value),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Invoice Number',
                          controller: _invoiceNoController,
                          required: true,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: SearchableSelector<String>(
                                label: 'Invoice Type',
                                items: _invoiceTypes,
                                itemLabel: (item) => item,
                                selected: _invoiceType,
                                onSelected: (value) =>
                                    setState(() => _invoiceType = value),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SearchableSelector<String>(
                                label: 'Credit Term',
                                items: _creditTerms,
                                itemLabel: (item) => item,
                                selected: _creditTerm,
                                onSelected: (value) =>
                                    setState(() => _creditTerm = value),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const SectionHeader(
                    title: 'Customer & Transport',
                    padding: EdgeInsets.only(bottom: 8),
                  ),
                  SkmCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SearchableSelector<String>(
                          label: 'Customer',
                          items: _customers,
                          itemLabel: (item) => item,
                          selected: _customer,
                          required: true,
                          onSelected: (value) =>
                              setState(() => _customer = value),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                label: 'Vehicle No.',
                                controller: _vehicleController,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppTextField(
                                label: 'Driver',
                                controller: _driverController,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  SectionHeader(
                    title: 'Items',
                    padding: const EdgeInsets.only(bottom: 8),
                    trailing: TextButton.icon(
                      onPressed: () =>
                          setState(() => _items.add(_SaleItemRow())),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Add Item'),
                    ),
                  ),
                  for (var i = 0; i < _items.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SaleItemCard(
                        index: i,
                        item: _items[i],
                        eggTypes: _eggTypes,
                        canRemove: _items.length > 1,
                        onRemove: () => setState(() => _items.removeAt(i)),
                        onChanged: () => setState(() {}),
                      ),
                    ),
                  const SizedBox(height: 12),

                  const SectionHeader(
                    title: 'Summary',
                    padding: EdgeInsets.only(bottom: 8),
                  ),
                  SkmCard(
                    child: Column(
                      children: [
                        _SummaryRow(label: 'Subtotal', value: totals.subtotal),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: 'Tax / TCS',
                          value: totals.tax,
                          isPlaceholder: true,
                        ),
                        const Divider(height: 24),
                        _SummaryRow(
                          label: 'Grand Total',
                          value: totals.grandTotal,
                          emphasize: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: PrimaryButton(
                  label: 'Save Sale',
                  icon: Icons.check_rounded,
                  onPressed: _save,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaleItemCard extends StatelessWidget {
  const _SaleItemCard({
    required this.index,
    required this.item,
    required this.eggTypes,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
  });

  final int index;
  final _SaleItemRow item;
  final List<String> eggTypes;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return SkmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Item ${index + 1}',
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
            label: 'Egg Type',
            items: eggTypes,
            itemLabel: (item) => item,
            selected: item.eggType,
            required: true,
            onSelected: (value) {
              item.eggType = value;
              onChanged();
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: NumericField(
                  label: 'Quantity',
                  controller: item.quantityController,
                  unit: 'trays',
                  onChanged: (_) => onChanged(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NumericField(
                  label: 'Rate',
                  controller: item.rateController,
                  unit: '₹',
                  allowDecimal: true,
                  onChanged: (_) => onChanged(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
    this.isPlaceholder = false,
  });

  final String label;
  final double value;
  final bool emphasize;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasize
        ? theme.textTheme.titleMedium
        : theme.textTheme.bodyLarge;

    return Row(
      children: [
        Text(label, style: style),
        const Spacer(),
        Text(
          isPlaceholder ? '—' : '₹${value.toStringAsFixed(2)}',
          style: style?.copyWith(
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
