import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/widgets/skm_card.dart';
import '../../../../core/widgets/shimmer.dart';

/// Branded loading skeleton shown while the dashboard's first data load is
/// in flight. Mirrors the real layout (header, KPI grid, quick entry,
/// overview, trend chart) so the page doesn't "jump" once data arrives.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = AppBreakpoints.isTablet(MediaQuery.sizeOf(context).width);
    final kpiColumns = isTablet ? 4 : 2;
    final actionColumns = isTablet ? 6 : 3;

    return Shimmer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          const _HeaderSkeleton(),
          const SizedBox(height: AppSpacing.lg),
          _Grid(
            columns: kpiColumns,
            itemCount: 9,
            aspectRatio: isTablet ? 1.7 : 1.5,
            itemBuilder: (context) => const _KpiCardSkeleton(),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SkeletonBox(width: 110, height: 18),
          const SizedBox(height: AppSpacing.md),
          _Grid(
            columns: actionColumns,
            itemCount: 6,
            aspectRatio: isTablet ? 1.0 : 0.8,
            itemBuilder: (context) => const _QuickActionSkeleton(),
          ),
          const SizedBox(height: AppSpacing.xl),
          const _TodaysOverviewSkeleton(),
          const SizedBox(height: AppSpacing.xl),
          const _TrendCardSkeleton(),
        ],
      ),
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonBox(width: 200, height: 24),
                  SizedBox(height: AppSpacing.xs),
                  SkeletonBox(width: 150, height: 14),
                ],
              ),
            ),
            const SkeletonBox(width: 64, height: 36, borderRadius: AppRadius.pill),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: const [
            Expanded(child: SkeletonBox(height: 56, borderRadius: 12)),
            SizedBox(width: AppSpacing.sm),
            SkeletonBox(width: 96, height: 36, borderRadius: 12),
          ],
        ),
      ],
    );
  }
}

class _KpiCardSkeleton extends StatelessWidget {
  const _KpiCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              SkeletonBox(width: 32, height: 32, borderRadius: AppRadius.sm),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: SkeletonBox(height: 12)),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          SkeletonBox(width: 70, height: 22),
        ],
      ),
    );
  }
}

class _QuickActionSkeleton extends StatelessWidget {
  const _QuickActionSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkmCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SkeletonBox.circle(size: 40),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(width: 56, height: 11),
        ],
      ),
    );
  }
}

class _TodaysOverviewSkeleton extends StatelessWidget {
  const _TodaysOverviewSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 140, height: 16),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: List.generate(3, (i) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 2 ? AppSpacing.md : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonBox.circle(size: 20),
                      SizedBox(height: AppSpacing.sm),
                      SkeletonBox(height: 16),
                      SizedBox(height: AppSpacing.xs),
                      SkeletonBox(width: 40, height: 11),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TrendCardSkeleton extends StatelessWidget {
  const _TrendCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 160, height: 16),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final heights = [40.0, 65.0, 50.0, 90.0, 70.0, 110.0, 85.0];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i < 6 ? AppSpacing.sm : 0),
                    child: SkeletonBox(
                      height: heights[i],
                      borderRadius: AppRadius.sm,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared fixed-aspect grid layout used by both the KPI and Quick Entry
/// skeleton sections, mirroring the real screens' `GridView.builder`.
class _Grid extends StatelessWidget {
  const _Grid({
    required this.columns,
    required this.itemCount,
    required this.aspectRatio,
    required this.itemBuilder,
  });

  final int columns;
  final int itemCount;
  final double aspectRatio;
  final WidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, index) => itemBuilder(context),
    );
  }
}
