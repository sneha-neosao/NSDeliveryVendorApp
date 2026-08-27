import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/orders_list_usecase.dart';
import '../../../../remote/models/orders_list_model/orders_list_response.dart';

part 'orders_list_event.dart';
part 'orders_list_state.dart';

/// Handles state management for **Ongoing Orders List** and its related operations.
class OrdersListBloc extends Bloc<OrdersListEvent, OrdersListState> {
  final OrdersListUseCase _ordersListUseCase;

  OrdersListBloc(this._ordersListUseCase) : super(OrdersListInitialState()) {
    on<GetOrdersListEvent>(_getOrdersList);
    on<LoadMoreOrdersListEvent>(_loadMoreOrdersList);
  }

  Future<void> _getOrdersList(
    GetOrdersListEvent event,
    Emitter<OrdersListState> emit,
  ) async {
    emit(OrdersListLoadingState());

    final result = await _ordersListUseCase.call(
      OrdersListParams(
        page: event.page,
        limit: event.limit,
      ),
    );

    result.fold(
      (l) => emit(OrdersListFailureState(l.message)),
      (r) {
        final items = r.data ?? [];
        final totalPages = r.pagination?.totalPages ?? 1;
        final currentPage = r.pagination?.currentPage ?? event.page;
        final hasReachedMax =
            currentPage >= totalPages || items.length < event.limit;

        emit(
          OrdersListSuccessState(
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

  Future<void> _loadMoreOrdersList(
    LoadMoreOrdersListEvent event,
    Emitter<OrdersListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! OrdersListSuccessState) return;
    if (currentState.hasReachedMax || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;

    final result = await _ordersListUseCase.call(
      OrdersListParams(
        page: nextPage,
        limit: 10,
      ),
    );

    result.fold(
      (l) => emit(currentState.copyWith(isLoadingMore: false)),
      (r) {
        final newItems = r.data ?? [];
        final updatedItems = List<OrdersListItem>.from(currentState.items)
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
    logger.i("===== CLOSE OrdersListBloc =====");
    return super.close();
  }
}
