import 'package:equatable/equatable.dart';

import '../../domain/entities/home_summary.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final HomeSummary summary;
  final bool isRefreshing;

  const HomeLoaded({
    required this.summary,
    this.isRefreshing = false,
  });

  HomeLoaded copyWith({
    HomeSummary? summary,
    bool? isRefreshing,
  }) {
    return HomeLoaded(
      summary: summary ?? this.summary,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [summary, isRefreshing];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
