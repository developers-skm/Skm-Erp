import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';

/// Lightweight 7-day production trend visualization drawn with
/// [CustomPaint] — no charting dependency needed for a simple sparkline.
class ProductionTrendCard extends StatelessWidget {
  const ProductionTrendCard({super.key, required this.values});

  /// Production % values, oldest first, ending with today.
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SkmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: '7-Day Production Trend',
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 90,
            width: double.infinity,
            child: CustomPaint(
              painter: _TrendPainter(
                values: values,
                lineColor: theme.colorScheme.primary,
                fillColor: theme.colorScheme.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('7 days ago', style: theme.textTheme.bodySmall),
              Text(
                'Today: ${values.last.toStringAsFixed(1)}%',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({
    required this.values,
    required this.lineColor,
    required this.fillColor,
  });

  final List<double> values;
  final Color lineColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV).abs() < 0.01 ? 1 : (maxV - minV);

    final stepX = values.length > 1 ? size.width / (values.length - 1) : 0.0;
    double yFor(double v) => size.height - ((v - minV) / range) * size.height;

    final linePath = Path();
    final fillPath = Path();

    for (var i = 0; i < values.length; i++) {
      final x = stepX * i;
      final y = yFor(values[i]);
      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(stepX * (values.length - 1), size.height);
    fillPath.close();

    canvas.drawPath(fillPath, Paint()..color = fillColor);
    canvas.drawPath(
      linePath,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final dotPaint = Paint()..color = lineColor;
    for (var i = 0; i < values.length; i++) {
      final x = stepX * i;
      final y = yFor(values[i]);
      canvas.drawCircle(
        Offset(x, y),
        i == values.length - 1 ? 4 : 2.5,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.values != values;
}
