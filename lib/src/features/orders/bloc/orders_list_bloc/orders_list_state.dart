part of 'orders_list_bloc.dart';

sealed class OrdersListState extends Equatable {
  const OrdersListState();

  @override
  List<Object?> get props => [];
}

class OrdersListInitialState extends OrdersListState {}

class OrdersListLoadingState extends OrdersListState {}

class OrdersListSuccessState extends OrdersListState {
  final OrdersListResponse data;
  final List<OrdersListItem> items;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final int currentPage;

  const OrdersListSuccessState({
    required this.data,
    required this.items,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.currentPage = 1,
  });

  OrdersListSuccessState copyWith({
    OrdersListResponse? data,
    List<OrdersListItem>? items,
    bool? hasReachedMax,
    bool? isLoadingMore,
    int? currentPage,
  }) {
    return OrdersListSuccessState(
      data: data ?? this.data,
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props =>
      [data, items, hasReachedMax, isLoadingMore, currentPage];
}

class OrdersListFailureState extends OrdersListState {
  final String message;

  const OrdersListFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
