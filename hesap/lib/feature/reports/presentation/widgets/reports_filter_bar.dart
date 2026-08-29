import 'package:flutter/material.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/module/report_summary/entities/report_filter.dart';

final class ReportsFilterBar extends StatelessWidget {
  const ReportsFilterBar({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  final ReportFilter filter;
  final ValueChanged<ReportFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.sm,
        AppSizes.lg,
        AppSizes.xs,
      ),
      child: Row(
        children: [
          _FilterChip(
            label: 'Bu Hafta',
            selected: filter.period == ReportPeriod.thisWeek,
            onTap: () =>
                onChanged(filter.copyWith(period: ReportPeriod.thisWeek)),
          ),
          const SizedBox(width: AppSizes.sm),
          _FilterChip(
            label: 'Bu Ay',
            selected: filter.period == ReportPeriod.thisMonth,
            onTap: () =>
                onChanged(filter.copyWith(period: ReportPeriod.thisMonth)),
          ),
          const SizedBox(width: AppSizes.sm),
          _FilterChip(
            label: 'Özel',
            selected: filter.period == ReportPeriod.custom,
            onTap: () => _pickCustomRange(context),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCustomRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      initialDateRange: filter.period == ReportPeriod.custom
          ? DateTimeRange(start: filter.startDate, end: filter.endDate)
          : DateTimeRange(
              start: now.subtract(const Duration(days: 6)),
              end: now,
            ),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: context.colors.primary,
            onPrimary: Colors.white,
            surface: context.appTheme.cardBackground,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      onChanged(ReportFilter(
        period: ReportPeriod.custom,
        customStart: picked.start,
        customEnd: picked.end,
      ));
    }
  }
}

final class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.base,
          vertical: AppSizes.sm - 1,
        ),
        decoration: BoxDecoration(
          color: selected
              ? context.colors.primary
              : context.appTheme.cardBackground,
          borderRadius: AppRadius.fullBorderRadius,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: context.colors.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: selected ? Colors.white : context.appTheme.muted,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
