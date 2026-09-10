import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/revenue_analytics_usecase.dart';
import '../../../../remote/models/dashboard_model/revenue_analytics_response.dart';

part 'revenue_analytics_event.dart';
part 'revenue_analytics_state.dart';

/// Handles state management for **Dashboard Revenue Analytics** operations.
class RevenueAnalyticsBloc
    extends Bloc<RevenueAnalyticsEvent, RevenueAnalyticsState> {
  final RevenueAnalyticsUseCase _revenueAnalyticsUseCase;

  RevenueAnalyticsBloc(this._revenueAnalyticsUseCase)
      : super(RevenueAnalyticsInitialState()) {
    on<FetchRevenueAnalyticsEvent>(_fetchRevenueAnalytics);
  }

  Future<void> _fetchRevenueAnalytics(
    FetchRevenueAnalyticsEvent event,
    Emitter<RevenueAnalyticsState> emit,
  ) async {
    emit(RevenueAnalyticsLoadingState());

    final result = await _revenueAnalyticsUseCase.call(NoParams());

    result.fold(
      (l) => emit(RevenueAnalyticsFailureState(l.message)),
      (r) => emit(RevenueAnalyticsSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE RevenueAnalyticsBloc =====");
    return super.close();
  }
}
