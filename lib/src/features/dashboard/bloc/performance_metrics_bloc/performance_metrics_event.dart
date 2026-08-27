part of 'performance_metrics_bloc.dart';

sealed class PerformanceMetricsEvent extends Equatable {
  const PerformanceMetricsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch performance metrics and top products for dashboard
class FetchPerformanceMetricsEvent extends PerformanceMetricsEvent {}
