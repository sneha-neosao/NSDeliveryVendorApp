part of 'slots_list_bloc.dart';

sealed class SlotsListEvent extends Equatable {
  const SlotsListEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch initial or refreshed slots list
class GetSlotsListEvent extends SlotsListEvent {
  final int page;
  final int limit;

  const GetSlotsListEvent({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}

/// Event to load more paginated slots
class LoadMoreSlotsListEvent extends SlotsListEvent {
  const LoadMoreSlotsListEvent();
}
