import 'package:dartz/dartz.dart';
import 'package:hesap/core/errror/failure.dart';

import '../entities/home_summary.dart';
import '../repositories/home_repository.dart';

class GetHomeSummary {
  final HomeRepository repository;

  GetHomeSummary({required this.repository});

  Future<Either<Failure, HomeSummary>> call() {
    return repository.getHomeSummary();
  }
}
