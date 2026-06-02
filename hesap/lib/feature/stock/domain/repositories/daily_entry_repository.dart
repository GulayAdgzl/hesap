import 'package:dartz/dartz.dart';
import 'package:hesap/core/errror/failure.dart';
import '../entities/daily_stock_entry.dart';

abstract class DailyEntryRepository {
  Future<Either<Failure, Unit>> saveDailyEntries(List<DailyStockEntry> entries);
  Future<Either<Failure, List<DailyStockEntry>>> getEntriesByDate(
      DateTime date);
  Future<Either<Failure, DailyStockEntry?>> getLastEntryForProduct(
      String productId);
}
