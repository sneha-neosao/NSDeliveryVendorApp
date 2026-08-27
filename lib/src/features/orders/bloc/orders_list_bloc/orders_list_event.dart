part of 'orders_list_bloc.dart';

sealed class OrdersListEvent extends Equatable {
  const OrdersListEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch first page of orders list
class GetOrdersListEvent extends OrdersListEvent {
  final int page;
  final int limit;

  const GetOrdersListEvent({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}

/// Load next page of orders list
class LoadMoreOrdersListEvent extends OrdersListEvent {}
