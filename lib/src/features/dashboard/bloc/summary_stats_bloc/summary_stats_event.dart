part of 'summary_stats_bloc.dart';

sealed class SummaryStatsEvent extends Equatable {
  const SummaryStatsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch summary stats for dashboard
class FetchSummaryStatsEvent extends SummaryStatsEvent {}
