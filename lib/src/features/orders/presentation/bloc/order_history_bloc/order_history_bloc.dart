import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/logger.dart';
import '../../../domain/order_history_usecase.dart';
import '../../../../../remote/models/order_history_model/order_history_response.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

/// Handles state management for **Order History** and its related operations.
class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderHistoryUseCase _orderHistoryUseCase;

  OrderHistoryBloc(this._orderHistoryUseCase)
      : super(OrderHistoryInitialState()) {
    on<GetOrderHistoryEvent>(_getOrderHistory);
    on<LoadMoreOrderHistoryEvent>(_loadMoreOrderHistory);
  }

  Future<void> _getOrderHistory(
    GetOrderHistoryEvent event,
    Emitter<OrderHistoryState> emit,
  ) async {
    emit(OrderHistoryLoadingState());

    final result = await _orderHistoryUseCase.call(
      OrderHistoryParams(
        page: event.page,
        limit: event.limit,
      ),
    );

    result.fold(
      (l) => emit(OrderHistoryFailureState(l.message)),
      (r) {
        final items = r.data ?? [];
        final totalPages = r.pagination?.totalPages ?? 1;
        final currentPage = r.pagination?.currentPage ?? event.page;
        final hasReachedMax =
            currentPage >= totalPages || items.length < event.limit;

        emit(
          OrderHistorySuccessState(
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

  Future<void> _loadMoreOrderHistory(
    LoadMoreOrderHistoryEvent event,
    Emitter<OrderHistoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is! OrderHistorySuccessState) return;
    if (currentState.hasReachedMax || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;

    final result = await _orderHistoryUseCase.call(
      OrderHistoryParams(
        page: nextPage,
        limit: 10,
      ),
    );

    result.fold(
      (l) => emit(currentState.copyWith(isLoadingMore: false)),
      (r) {
        final newItems = r.data ?? [];
        final updatedItems = List<OrderHistoryItem>.from(currentState.items)
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
    logger.i("===== CLOSE OrderHistoryBloc =====");
    return super.close();
  }
}
