import 'package:dartz/dartz.dart';
import 'package:hesap/core/errror/failure.dart';

import '../entities/home_summary.dart';
import '../entities/weekly_consumption.dart';
import '../entities/stock_alert.dart';
import '../entities/production_forecast.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeSummary>> getHomeSummary();
  Future<Either<Failure, WeeklyConsumption>> getWeeklyConsumption();
  Future<Either<Failure, List<StockAlert>>> getAlerts();
  Future<Either<Failure, List<ProductionForecast>>> getForecasts();
}
