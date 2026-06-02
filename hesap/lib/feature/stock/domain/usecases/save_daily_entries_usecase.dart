import 'package:dartz/dartz.dart';
import 'package:hesap/core/errror/failure.dart';
import '../entities/daily_stock_entry.dart';
import '../repositories/daily_entry_repository.dart';

class SaveDailyEntriesUseCase {
  final DailyEntryRepository repository;
  SaveDailyEntriesUseCase(this.repository);

  Future<Either<Failure, Unit>> call(List<DailyStockEntry> entries) {
    return repository.saveDailyEntries(entries);
  }
}
