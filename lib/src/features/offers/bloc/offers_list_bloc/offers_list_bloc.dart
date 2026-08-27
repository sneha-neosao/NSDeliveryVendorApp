import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/offers_list_usecase.dart';
import '../../../../remote/models/offers_model/offers_list_response.dart';

part 'offers_list_event.dart';
part 'offers_list_state.dart';

/// Handles state management and pagination for **Offers List**.
class OffersListBloc extends Bloc<OffersListEvent, OffersListState> {
  final OffersListUseCase _offersListUseCase;

  OffersListBloc(this._offersListUseCase) : super(OffersListInitialState()) {
    on<GetOffersListEvent>(_getOffersList);
    on<LoadMoreOffersListEvent>(_loadMoreOffersList);
  }

  Future<void> _getOffersList(
    GetOffersListEvent event,
    Emitter<OffersListState> emit,
  ) async {
    emit(OffersListLoadingState());

    final result = await _offersListUseCase.call(
      OffersListParams(
        page: event.page,
        limit: event.limit,
      ),
    );

    result.fold(
      (l) => emit(OffersListFailureState(l.message)),
      (r) {
        final items = r.data;
        final pagination = r.pagination;
        final hasReachedMax = pagination?.hasNext == false || items.isEmpty;

        emit(
          OffersListSuccessState(
            items: items,
            pagination: pagination,
            hasReachedMax: hasReachedMax,
            isLoadingMore: false,
            page: event.page,
          ),
        );
      },
    );
  }

  Future<void> _loadMoreOffersList(
    LoadMoreOffersListEvent event,
    Emitter<OffersListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! OffersListSuccessState ||
        currentState.hasReachedMax ||
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.page + 1;
    final result = await _offersListUseCase.call(
      OffersListParams(
        page: nextPage,
        limit: currentState.pagination?.limit ?? 10,
      ),
    );

    result.fold(
      (l) => emit(currentState.copyWith(isLoadingMore: false)),
      (r) {
        final newItems = r.data;
        final pagination = r.pagination;
        final hasReachedMax = pagination?.hasNext == false || newItems.isEmpty;

        emit(
          currentState.copyWith(
            items: [...currentState.items, ...newItems],
            pagination: pagination,
            hasReachedMax: hasReachedMax,
            isLoadingMore: false,
            page: nextPage,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE OffersListBloc =====");
    return super.close();
  }
}
