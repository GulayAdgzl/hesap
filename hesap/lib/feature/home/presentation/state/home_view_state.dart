import 'package:flutter/foundation.dart';

import '../../domain/entities/home_summary.dart';

enum HomeViewStatus { initial, loading, loaded, error }

@immutable
final class HomeViewState {
  const HomeViewState({
    this.status = HomeViewStatus.initial,
    this.summary,
    this.errorMessage,
    this.isRefreshing = false,
  });

  final HomeViewStatus status;
  final HomeSummary? summary;
  final String? errorMessage;
  final bool isRefreshing;

  bool get isInitialOrLoading =>
      status == HomeViewStatus.initial || status == HomeViewStatus.loading;

  bool get isError => status == HomeViewStatus.error;

  bool get isLoaded => status == HomeViewStatus.loaded && summary != null;

  HomeViewState copyWith({
    HomeViewStatus? status,
    HomeSummary? summary,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return HomeViewState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeViewState &&
        other.status == status &&
        other.summary == summary &&
        other.errorMessage == errorMessage &&
        other.isRefreshing == isRefreshing;
  }

  @override
  int get hashCode => Object.hash(status, summary, errorMessage, isRefreshing);
}
