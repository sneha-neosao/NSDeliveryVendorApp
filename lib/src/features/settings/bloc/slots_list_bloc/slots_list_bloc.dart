import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/slots_list_usecase.dart';
import '../../../../remote/models/slots_model/slots_list_response.dart';

part 'slots_list_event.dart';
part 'slots_list_state.dart';

/// Handles state management for **Restaurant Time Slots List** and its related operations.
class SlotsListBloc extends Bloc<SlotsListEvent, SlotsListState> {
  final SlotsListUseCase _slotsListUseCase;

  SlotsListBloc(this._slotsListUseCase) : super(SlotsListInitialState()) {
    on<GetSlotsListEvent>(_getSlotsList);
    on<LoadMoreSlotsListEvent>(_loadMoreSlotsList);
  }

  Future<void> _getSlotsList(
    GetSlotsListEvent event,
    Emitter<SlotsListState> emit,
  ) async {
    emit(SlotsListLoadingState());

    final result = await _slotsListUseCase.call(
      SlotsListParams(
        page: event.page,
        limit: event.limit,
      ),
    );

    result.fold(
      (l) => emit(SlotsListFailureState(l.message)),
      (r) {
        final items = r.data ?? [];
        final totalPages = r.pagination?.totalPages ?? 1;
        final currentPage = r.pagination?.currentPage ?? event.page;
        final hasReachedMax =
            currentPage >= totalPages || items.length < event.limit;

        emit(
          SlotsListSuccessState(
            data: r,
            items: items,
            hasReachedMax: hasReachedMax,
            currentPage: currentPage,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> _loadMoreSlotsList(
    LoadMoreSlotsListEvent event,
    Emitter<SlotsListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SlotsListSuccessState) return;
    if (currentState.hasReachedMax || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;

    final result = await _slotsListUseCase.call(
      SlotsListParams(
        page: nextPage,
        limit: 10,
      ),
    );

    result.fold(
      (l) => emit(currentState.copyWith(isLoadingMore: false)),
      (r) {
        final newItems = r.data ?? [];
        final updatedItems = List<SlotItem>.from(currentState.items)
          ..addAll(newItems);
        final totalPages = r.pagination?.totalPages ?? nextPage;
        final currentPage = r.pagination?.currentPage ?? nextPage;
        final hasReachedMax = currentPage >= totalPages ||
            newItems.isEmpty ||
            newItems.length < 10;

        emit(
          currentState.copyWith(
            data: r,
            items: updatedItems,
            hasReachedMax: hasReachedMax,
            currentPage: currentPage,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE SlotsListBloc =====");
    return super.close();
  }
}
