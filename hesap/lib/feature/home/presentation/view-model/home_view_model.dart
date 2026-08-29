import 'package:flutter/foundation.dart';

import '../../domain/usecases/get_home_summary.dart';
import '../state/home_view_state.dart';

/// Home sayfasının business logic'i.
/// BuildContext / widget bilmez, tek bağımlılığı domain usecase'dir.
/// Bu sayede unit test edilirken Flutter widget ağacına ihtiyaç duymaz.
final class HomeViewModel {
  HomeViewModel({required GetHomeSummary getHomeSummary})
      : _getHomeSummary = getHomeSummary;

  final GetHomeSummary _getHomeSummary;

  final ValueNotifier<HomeViewState> state = ValueNotifier(
    const HomeViewState(),
  );

  Future<void> loadHome() async {
    state.value = state.value.copyWith(status: HomeViewStatus.loading);

    final result = await _getHomeSummary();

    result.fold(
      (failure) => state.value = HomeViewState(
        status: HomeViewStatus.error,
        errorMessage: failure.message,
      ),
      (summary) => state.value = HomeViewState(
        status: HomeViewStatus.loaded,
        summary: summary,
      ),
    );
  }

  /// Pull-to-refresh: mevcut veriyi ekranda tutar, sadece [isRefreshing]
  /// bayrağını günceller; hata olursa eski veri korunur.
  Future<void> refresh() async {
    final current = state.value;

    state.value = current.isLoaded
        ? current.copyWith(isRefreshing: true)
        : const HomeViewState(status: HomeViewStatus.loading);

    final result = await _getHomeSummary();

    result.fold(
      (failure) {
        state.value = current.isLoaded
            ? current.copyWith(isRefreshing: false)
            : HomeViewState(
                status: HomeViewStatus.error,
                errorMessage: failure.message,
              );
      },
      (summary) => state.value = HomeViewState(
        status: HomeViewStatus.loaded,
        summary: summary,
      ),
    );
  }

  void dispose() {
    state.dispose();
  }
}
