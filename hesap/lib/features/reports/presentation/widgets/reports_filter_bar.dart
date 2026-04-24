import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_text_styles.dart';
import 'package:hesap/features/reports/domain/entities/report_filter.dart';

class ReportsFilterBar extends StatelessWidget {
  final ReportFilter filter;
  final ValueChanged<ReportFilter> onChanged;

  const ReportsFilterBar({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        children: [
          _FilterChip(
            label: 'Bu Hafta',
            selected: filter.period == ReportPeriod.thisWeek,
            onTap: () => onChanged(
              filter.copyWith(period: ReportPeriod.thisWeek),
            ),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Bu Ay',
            selected: filter.period == ReportPeriod.thisMonth,
            onTap: () => onChanged(
              filter.copyWith(period: ReportPeriod.thisMonth),
            ),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Ozel',
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
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      onChanged(
        ReportFilter(
          period: ReportPeriod.custom,
          customStart: picked.start,
          customEnd: picked.end,
        ),
      );
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: selected ? Colors.white : AppColors.muted,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}