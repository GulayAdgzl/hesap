import 'package:hesap/module/report_summary/entities/report_summary.dart';

class ReportSummaryModel {
  final int totalConsumption;
  final double totalCost;
  final double? consumptionChangePercent;
  final double dailyAverageCost;
  final Map<String, double>
      dailyCostSeries; // DateTime.toIso8601String() → maliyet

  const ReportSummaryModel({
    required this.totalConsumption,
    required this.totalCost,
    required this.consumptionChangePercent,
    required this.dailyAverageCost,
    required this.dailyCostSeries,
  });

  factory ReportSummaryModel.fromEntity(ReportSummary entity) =>
      ReportSummaryModel(
        totalConsumption: entity.totalConsumption,
        totalCost: entity.totalCost,
        consumptionChangePercent: entity.consumptionChangePercent,
        dailyAverageCost: entity.dailyAverageCost,
        dailyCostSeries: entity.dailyCostSeries.map(
          (date, cost) => MapEntry(date.toIso8601String(), cost),
        ),
      );

  ReportSummary toEntity() => ReportSummary(
        totalConsumption: totalConsumption,
        totalCost: totalCost,
        consumptionChangePercent: consumptionChangePercent,
        dailyAverageCost: dailyAverageCost,
        dailyCostSeries: dailyCostSeries.map(
          (iso, cost) => MapEntry(DateTime.parse(iso), cost),
        ),
      );

  factory ReportSummaryModel.fromJson(Map<String, dynamic> json) =>
      ReportSummaryModel(
        totalConsumption: json['totalConsumption'] as int,
        totalCost: (json['totalCost'] as num).toDouble(),
        consumptionChangePercent:
            (json['consumptionChangePercent'] as num?)?.toDouble(),
        dailyAverageCost: (json['dailyAverageCost'] as num).toDouble(),
        dailyCostSeries: (json['dailyCostSeries'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
      );

  Map<String, dynamic> toJson() => {
        'totalConsumption': totalConsumption,
        'totalCost': totalCost,
        'consumptionChangePercent': consumptionChangePercent,
        'dailyAverageCost': dailyAverageCost,
        'dailyCostSeries': dailyCostSeries,
      };
}
