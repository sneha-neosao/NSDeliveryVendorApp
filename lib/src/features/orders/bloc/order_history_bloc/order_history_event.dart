part of 'order_history_bloc.dart';

sealed class OrderHistoryEvent extends Equatable {
  const OrderHistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch first page of order history
class GetOrderHistoryEvent extends OrderHistoryEvent {
  final int page;
  final int limit;

  const GetOrderHistoryEvent({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}

/// Load next page of order history
class LoadMoreOrderHistoryEvent extends OrderHistoryEvent {}
