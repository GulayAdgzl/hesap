import 'package:dartz/dartz.dart';

import '../../../../core/errror/failure.dart';
import '../repositories/settings_repository.dart';

class SaveSetting {
  final SettingsRepository repository;

  SaveSetting({required this.repository});

  Future<Either<Failure, void>> call({
    required String key,
    required dynamic value,
  }) {
    return repository.saveSetting(key, value);
  }
}
