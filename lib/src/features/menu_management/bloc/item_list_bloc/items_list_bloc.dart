import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/items_list_usecase.dart';
import '../../../../remote/models/items_model/items_list_response.dart';

part 'items_list_event.dart';
part 'items_list_state.dart';

/// Handles state management for **Restaurant Items List** and its related operations.
class ItemsListBloc extends Bloc<ItemsListEvent, ItemsListState> {
  final ItemsListUseCase _itemsListUseCase;

  ItemsListBloc(this._itemsListUseCase) : super(ItemsListInitialState()) {
    on<GetItemsListEvent>(_getItemsList);
    on<LoadMoreItemsListEvent>(_loadMoreItemsList);
  }

  Future<void> _getItemsList(
    GetItemsListEvent event,
    Emitter<ItemsListState> emit,
  ) async {
    emit(ItemsListLoadingState());

    final result = await _itemsListUseCase.call(
      ItemsListParams(
        page: event.page,
        limit: event.limit,
        q: event.q,
        status: event.status,
      ),
    );

    result.fold(
      (l) => emit(ItemsListFailureState(l.message)),
      (r) {
        final items = r.data ?? [];
        final totalPages = r.pagination?.totalPages ?? 1;
        final currentPage = r.pagination?.currentPage ?? event.page;
        final hasReachedMax =
            currentPage >= totalPages || items.length < event.limit;

        emit(
          ItemsListSuccessState(
            data: r,
            items: items,
            hasReachedMax: hasReachedMax,
            currentPage: currentPage,
            currentQuery: event.q,
            currentStatus: event.status,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> _loadMoreItemsList(
    LoadMoreItemsListEvent event,
    Emitter<ItemsListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ItemsListSuccessState) return;
    if (currentState.hasReachedMax || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;

    final result = await _itemsListUseCase.call(
      ItemsListParams(
        page: nextPage,
        limit: 10,
        q: currentState.currentQuery,
        status: currentState.currentStatus,
      ),
    );

    result.fold(
      (l) => emit(currentState.copyWith(isLoadingMore: false)),
      (r) {
        final newItems = r.data ?? [];
        final updatedItems = List<RestaurantItem>.from(currentState.items)
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
    logger.i("===== CLOSE ItemsListBloc =====");
    return super.close();
  }
}
