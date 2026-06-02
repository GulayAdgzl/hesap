class DailyConsumption {
  final DateTime date;
  final double actual;
  final double forecast;

  const DailyConsumption({
    required this.date,
    required this.actual,
    required this.forecast,
  });

  bool get hasActual => actual > 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyConsumption &&
        other.date == date &&
        other.actual == actual &&
        other.forecast == forecast;
  }

  @override
  int get hashCode => Object.hash(date, actual, forecast);
}

class WeeklyConsumption {
  final List<DailyConsumption> days;

  const WeeklyConsumption({required this.days});

  double get totalActual => days.fold(0.0, (sum, d) => sum + d.actual);

  double get totalForecast => days.fold(0.0, (sum, d) => sum + d.forecast);

  double get averageDaily => days.isEmpty ? 0.0 : totalActual / days.length;

  double get maxValue {
    if (days.isEmpty) return 0.0;
    return days.fold(
      0.0,
      (max, d) => d.actual > max
          ? d.actual
          : d.forecast > max
              ? d.forecast
              : max,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeeklyConsumption && other.days == days;
  }

  @override
  int get hashCode => days.hashCode;
}
