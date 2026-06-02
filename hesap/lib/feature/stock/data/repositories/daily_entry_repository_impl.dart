import 'package:dartz/dartz.dart';
import 'package:hesap/core/errror/failure.dart';
import '../../domain/entities/daily_stock_entry.dart';
import '../../domain/repositories/daily_entry_repository.dart';
import '../datasources/daily_entry_datasource.dart';

class DailyEntryRepositoryImpl implements DailyEntryRepository {
  final DailyEntryLocalDatasource localDatasource;

  DailyEntryRepositoryImpl(this.localDatasource);

  @override
  Future<Either<Failure, Unit>> saveDailyEntries(
      List<DailyStockEntry> entries) async {
    try {
      await localDatasource.saveDailyEntries(entries);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DailyStockEntry>>> getEntriesByDate(
      DateTime date) async {
    try {
      final entries = await localDatasource.getEntriesByDate(date);
      return Right(entries);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DailyStockEntry?>> getLastEntryForProduct(
      String productId) async {
    try {
      final entry = await localDatasource.getLastEntryForProduct(productId);
      return Right(entry);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
