part of 'performance_metrics_bloc.dart';

sealed class PerformanceMetricsState extends Equatable {
  const PerformanceMetricsState();

  @override
  List<Object?> get props => [];
}

class PerformanceMetricsInitialState extends PerformanceMetricsState {}

class PerformanceMetricsLoadingState extends PerformanceMetricsState {}

class PerformanceMetricsSuccessState extends PerformanceMetricsState {
  final PerformanceMetricsResponse data;

  const PerformanceMetricsSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class PerformanceMetricsFailureState extends PerformanceMetricsState {
  final String message;

  const PerformanceMetricsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
