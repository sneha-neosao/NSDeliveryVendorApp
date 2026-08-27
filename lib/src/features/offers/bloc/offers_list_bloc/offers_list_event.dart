part of 'offers_list_bloc.dart';

sealed class OffersListEvent extends Equatable {
  const OffersListEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch promotional offers list (page 1 / initial)
class GetOffersListEvent extends OffersListEvent {
  final int page;
  final int limit;

  const GetOffersListEvent({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}

/// Event to load the next page of promotional offers
class LoadMoreOffersListEvent extends OffersListEvent {}
