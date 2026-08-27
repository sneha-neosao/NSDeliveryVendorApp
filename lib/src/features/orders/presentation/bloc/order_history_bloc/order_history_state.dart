part of 'order_history_bloc.dart';

sealed class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object?> get props => [];
}

class OrderHistoryInitialState extends OrderHistoryState {}

class OrderHistoryLoadingState extends OrderHistoryState {}

class OrderHistorySuccessState extends OrderHistoryState {
  final OrderHistoryResponse data;
  final List<OrderHistoryItem> items;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final int currentPage;

  const OrderHistorySuccessState({
    required this.data,
    required this.items,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.currentPage = 1,
  });

  OrderHistorySuccessState copyWith({
    OrderHistoryResponse? data,
    List<OrderHistoryItem>? items,
    bool? hasReachedMax,
    bool? isLoadingMore,
    int? currentPage,
  }) {
    return OrderHistorySuccessState(
      data: data ?? this.data,
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [data, items, hasReachedMax, isLoadingMore, currentPage];
}

class OrderHistoryFailureState extends OrderHistoryState {
  final String message;

  const OrderHistoryFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
