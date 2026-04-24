enum ReportPeriod { thisWeek, thisMonth, custom }

class ReportFilter {
  final ReportPeriod period;
  final DateTime? customStart;
  final DateTime? customEnd;

  const ReportFilter({
    this.period = ReportPeriod.thisWeek,
    this.customStart,
    this.customEnd,
  });

  ReportFilter copyWith({
    ReportPeriod? period,
    DateTime? customStart,
    DateTime? customEnd,
  }) =>
      ReportFilter(
        period: period ?? this.period,
        customStart: customStart ?? this.customStart,
        customEnd: customEnd ?? this.customEnd,
      );

  /// Filtreye göre başlangıç tarihini döndürür.
  DateTime get startDate {
    final now = DateTime.now();
    switch (period) {
      case ReportPeriod.thisWeek:
        return now.subtract(Duration(days: now.weekday - 1));
      case ReportPeriod.thisMonth:
        return DateTime(now.year, now.month, 1);
      case ReportPeriod.custom:
        return customStart ?? now.subtract(const Duration(days: 7));
    }
  }

  /// Filtreye göre bitiş tarihini döndürür.
  DateTime get endDate {
    final now = DateTime.now();
    switch (period) {
      case ReportPeriod.thisWeek:
      case ReportPeriod.thisMonth:
        return now;
      case ReportPeriod.custom:
        return customEnd ?? now;
    }
  }
}
