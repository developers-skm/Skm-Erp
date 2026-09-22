/// Result of totaling an egg sale's line items.
class EggSaleTotals {
  const EggSaleTotals({
    required this.subtotal,
    required this.tax,
    required this.grandTotal,
  });

  final double subtotal;
  final double tax;
  final double grandTotal;
}

/// Centralizes egg-sale total calculations so the UI never computes
/// business numbers directly.
///
/// IMPORTANT: Tax/TCS rules have not been provided. [calculate] currently
/// treats tax as 0 (grandTotal == subtotal) rather than inventing a
/// formula. Replace the body of this method with the real tax/TCS rule
/// once it is specified — no screen should need to change as a result.
abstract final class EggSaleTotalsService {
  static EggSaleTotals calculate({required List<double> lineAmounts}) {
    final subtotal = lineAmounts.fold<double>(0, (sum, amount) => sum + amount);
    const tax = 0.0; // Placeholder — real TCS/tax rule not yet defined.
    return EggSaleTotals(
      subtotal: subtotal,
      tax: tax,
      grandTotal: subtotal + tax,
    );
  }
}
