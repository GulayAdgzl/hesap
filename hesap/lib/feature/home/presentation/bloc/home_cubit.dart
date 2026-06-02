import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_home_summary.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeSummary getHomeSummary;

  HomeCubit({required this.getHomeSummary}) : super(const HomeInitial());

  Future<void> loadHome() async {
    emit(const HomeLoading());
    final result = await getHomeSummary();
    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (summary) => emit(HomeLoaded(summary: summary)),
    );
  }

  Future<void> refresh() async {
    // Mevcut veriyi göstermeye devam et, arka planda yenile
    final current = state;
    if (current is HomeLoaded) {
      emit(current.copyWith(isRefreshing: true));
    } else {
      emit(const HomeLoading());
    }

    final result = await getHomeSummary();
    result.fold(
      (failure) {
        if (current is HomeLoaded) {
          // Hata olsa bile eski veriyi koru, refresh flag'ini kaldır
          emit(current.copyWith(isRefreshing: false));
        } else {
          emit(HomeError(message: failure.message));
        }
      },
      (summary) => emit(HomeLoaded(summary: summary)),
    );
  }
}
