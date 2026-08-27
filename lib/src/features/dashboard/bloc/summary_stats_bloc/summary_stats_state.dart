part of 'summary_stats_bloc.dart';

sealed class SummaryStatsState extends Equatable {
  const SummaryStatsState();

  @override
  List<Object?> get props => [];
}

class SummaryStatsInitialState extends SummaryStatsState {}

class SummaryStatsLoadingState extends SummaryStatsState {}

class SummaryStatsSuccessState extends SummaryStatsState {
  final SummaryStatsResponse data;

  const SummaryStatsSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class SummaryStatsFailureState extends SummaryStatsState {
  final String message;

  const SummaryStatsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
