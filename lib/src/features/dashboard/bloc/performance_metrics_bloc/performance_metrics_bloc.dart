import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/performance_metrics_usecase.dart';
import '../../../../remote/models/dashboard_model/performance_metrics_response.dart';

part 'performance_metrics_event.dart';
part 'performance_metrics_state.dart';

/// Handles state management for **Dashboard Performance Metrics & Top Products**.
class PerformanceMetricsBloc
    extends Bloc<PerformanceMetricsEvent, PerformanceMetricsState> {
  final PerformanceMetricsUseCase _performanceMetricsUseCase;

  PerformanceMetricsBloc(this._performanceMetricsUseCase)
      : super(PerformanceMetricsInitialState()) {
    on<FetchPerformanceMetricsEvent>(_fetchPerformanceMetrics);
  }

  Future<void> _fetchPerformanceMetrics(
    FetchPerformanceMetricsEvent event,
    Emitter<PerformanceMetricsState> emit,
  ) async {
    emit(PerformanceMetricsLoadingState());

    final result = await _performanceMetricsUseCase.call(NoParams());

    result.fold(
      (l) => emit(PerformanceMetricsFailureState(l.message)),
      (r) => emit(PerformanceMetricsSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE PerformanceMetricsBloc =====");
    return super.close();
  }
}
