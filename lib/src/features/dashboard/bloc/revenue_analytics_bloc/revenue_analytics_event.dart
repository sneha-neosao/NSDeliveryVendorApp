part of 'revenue_analytics_bloc.dart';

sealed class RevenueAnalyticsEvent extends Equatable {
  const RevenueAnalyticsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch revenue analytics for the dashboard
class FetchRevenueAnalyticsEvent extends RevenueAnalyticsEvent {}
