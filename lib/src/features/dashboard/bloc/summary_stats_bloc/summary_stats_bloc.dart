import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/summary_stats_usecase.dart';
import '../../../../remote/models/dashboard_model/summary_stats_response.dart';

part 'summary_stats_event.dart';
part 'summary_stats_state.dart';

/// Handles state management for **Dashboard Summary Stats** operations.
class SummaryStatsBloc extends Bloc<SummaryStatsEvent, SummaryStatsState> {
  final SummaryStatsUseCase _summaryStatsUseCase;

  SummaryStatsBloc(this._summaryStatsUseCase)
      : super(SummaryStatsInitialState()) {
    on<FetchSummaryStatsEvent>(_fetchSummaryStats);
  }

  Future<void> _fetchSummaryStats(
    FetchSummaryStatsEvent event,
    Emitter<SummaryStatsState> emit,
  ) async {
    emit(SummaryStatsLoadingState());

    final result = await _summaryStatsUseCase.call(NoParams());

    result.fold(
      (l) => emit(SummaryStatsFailureState(l.message)),
      (r) => emit(SummaryStatsSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE SummaryStatsBloc =====");
    return super.close();
  }
}
