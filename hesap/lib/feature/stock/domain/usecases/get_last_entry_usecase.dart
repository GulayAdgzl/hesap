import 'package:dartz/dartz.dart';
import 'package:hesap/core/errror/failure.dart';
import '../entities/daily_stock_entry.dart';
import '../repositories/daily_entry_repository.dart';

class GetLastEntryForProductUseCase {
  final DailyEntryRepository repository;
  GetLastEntryForProductUseCase(this.repository);

  Future<Either<Failure, DailyStockEntry?>> call(String productId) {
    return repository.getLastEntryForProduct(productId);
  }
}
