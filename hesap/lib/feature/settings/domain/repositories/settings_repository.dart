import 'package:dartz/dartz.dart';
import 'package:hesap/core/errror/failure.dart';

import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, AppSettings>> getSettings();
  Future<Either<Failure, void>> saveSetting(String key, dynamic value);
  Future<Either<Failure, void>> clearSettings();
}
