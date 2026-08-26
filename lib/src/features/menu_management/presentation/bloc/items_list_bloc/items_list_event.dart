part of 'items_list_bloc.dart';

sealed class ItemsListEvent extends Equatable {
  const ItemsListEvent();

  @override
  List<Object?> get props => [];
}

class GetItemsListEvent extends ItemsListEvent {
  final int page;
  final int limit;
  final String? q;
  final String? status;

  const GetItemsListEvent({
    this.page = 1,
    this.limit = 10,
    this.q,
    this.status,
  });

  @override
  List<Object?> get props => [page, limit, q, status];
}

class LoadMoreItemsListEvent extends ItemsListEvent {}
