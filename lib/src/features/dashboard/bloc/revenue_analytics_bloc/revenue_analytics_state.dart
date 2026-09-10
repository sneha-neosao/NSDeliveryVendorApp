part of 'revenue_analytics_bloc.dart';

sealed class RevenueAnalyticsState extends Equatable {
  const RevenueAnalyticsState();

  @override
  List<Object?> get props => [];
}

class RevenueAnalyticsInitialState extends RevenueAnalyticsState {}

class RevenueAnalyticsLoadingState extends RevenueAnalyticsState {}

class RevenueAnalyticsSuccessState extends RevenueAnalyticsState {
  final RevenueAnalyticsResponse data;

  const RevenueAnalyticsSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class RevenueAnalyticsFailureState extends RevenueAnalyticsState {
  final String message;

  const RevenueAnalyticsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
