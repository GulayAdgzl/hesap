// weekly_consumption.dart
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
  final double
      previousWeekTotal; // "+%28 geçen haftaya göre" karşılaştırması için

  const WeeklyConsumption({
    required this.days,
    this.previousWeekTotal = 0,
  });

  double get totalActual => days.fold(0.0, (sum, d) => sum + d.actual);
  double get totalForecast => days.fold(0.0, (sum, d) => sum + d.forecast);
  double get averageDaily => days.isEmpty ? 0.0 : totalActual / days.length;

  /// Örn. 0.28 → "+%28"
  double? get percentChangeFromLastWeek {
    if (previousWeekTotal <= 0) return null;
    return (totalActual - previousWeekTotal) / previousWeekTotal;
  }

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
    return other is WeeklyConsumption &&
        other.days == days &&
        other.previousWeekTotal == previousWeekTotal;
  }

  @override
  int get hashCode => Object.hash(days, previousWeekTotal);
}
