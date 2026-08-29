import 'package:dartz/dartz.dart';
import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/feature/home/domain/entities/product_stock.dart';

import '../../domain/entities/home_summary.dart';
import '../../domain/entities/production_forecast.dart';
import '../../domain/entities/stock_alert.dart';
import '../../domain/entities/weekly_consumption.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;
  final int forecastPeriod;

  HomeRepositoryImpl({
    required this.localDataSource,
    this.forecastPeriod = 7,
  });

  @override
  Future<Either<Failure, HomeSummary>> getHomeSummary() async {
    try {
      final summaryData = await localDataSource.getHomeSummaryData();
      final weeklyData = await localDataSource.getWeeklyConsumptionData();
      final alertsData = await localDataSource.getAlertsData();
      final forecastsData =
          await localDataSource.getForecastsData(forecastPeriod);

      return Right(HomeSummary(
        totalConsumption: (summaryData['totalConsumption'] as num).toDouble(),
        dailyCost: (summaryData['dailyCost'] as num).toDouble(),
        criticalProductCount: summaryData['criticalProductCount'] as int,
        topConsumedProductName:
            summaryData['topConsumedProductName'] as String?,
        topConsumedAmount:
            (summaryData['topConsumedAmount'] as num?)?.toDouble(),
        topConsumedUnit: summaryData['topConsumedUnit'] as String?,
        alerts: _mapAlerts(alertsData),
        weeklyConsumption: _mapWeeklyConsumption(weeklyData),
        productionForecasts: _mapForecasts(forecastsData),
        productStocks: _mapProductStocks(
          (summaryData['productStocks'] as List).cast<Map<String, dynamic>>(),
        ),
      ));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WeeklyConsumption>> getWeeklyConsumption() async {
    try {
      final data = await localDataSource.getWeeklyConsumptionData();
      return Right(_mapWeeklyConsumption(data));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StockAlert>>> getAlerts() async {
    try {
      final data = await localDataSource.getAlertsData();
      return Right(_mapAlerts(data));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductionForecast>>> getForecasts() async {
    try {
      final data = await localDataSource.getForecastsData(forecastPeriod);
      return Right(_mapForecasts(data));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  // ── Private mappers ───────────────────────────────────────────────

  WeeklyConsumption _mapWeeklyConsumption(Map<String, dynamic> data) {
    return WeeklyConsumption(
      days: _mapDailyList(
        (data['days'] as List).cast<Map<String, dynamic>>(),
      ),
      previousWeekTotal: (data['previousWeekTotal'] as num).toDouble(),
    );
  }

  List<DailyConsumption> _mapDailyList(List<Map<String, dynamic>> data) {
    return data
        .map((d) => DailyConsumption(
              date: DateTime.fromMillisecondsSinceEpoch(d['date'] as int),
              actual: (d['actual'] as num).toDouble(),
              forecast: (d['forecast'] as num).toDouble(),
            ))
        .toList();
  }

  List<StockAlert> _mapAlerts(List<Map<String, dynamic>> data) {
    return data
        .map((d) => StockAlert(
              productId: d['productId'] as String,
              productName: d['productName'] as String,
              remainingAmount: (d['remainingAmount'] as num).toDouble(),
              unit: d['unit'] as String,
              estimatedDaysLeft: (d['estimatedDaysLeft'] as num).toDouble(),
              criticalThreshold: (d['criticalThreshold'] as num).toDouble(),
              severity: d['severity'] == 'critical'
                  ? AlertSeverity.critical
                  : AlertSeverity.warning,
            ))
        .toList();
  }

  List<ProductionForecast> _mapForecasts(List<Map<String, dynamic>> data) {
    return data.map((d) {
      final trendStr = d['trend'] as String;
      return ProductionForecast(
        productId: d['productId'] as String,
        productName: d['productName'] as String,
        unit: d['unit'] as String,
        forecastAmount: (d['forecastAmount'] as num).toDouble(),
        previousAmount: (d['previousAmount'] as num).toDouble(),
        trend: trendStr == 'increasing'
            ? ForecastTrend.increasing
            : trendStr == 'decreasing'
                ? ForecastTrend.decreasing
                : ForecastTrend.stable,
      );
    }).toList();
  }

  List<ProductStock> _mapProductStocks(List<Map<String, dynamic>> data) {
    return data
        .map((d) => ProductStock(
              productId: d['productId'] as String,
              productName: d['productName'] as String,
              unit: d['unit'] as String,
              remainingAmount: (d['remainingAmount'] as num).toDouble(),
              consumedToday: (d['consumedToday'] as num).toDouble(),
            ))
        .toList();
  }
}
