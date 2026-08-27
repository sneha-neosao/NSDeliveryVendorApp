part of 'offers_list_bloc.dart';

sealed class OffersListState extends Equatable {
  const OffersListState();

  @override
  List<Object?> get props => [];
}

class OffersListInitialState extends OffersListState {}

class OffersListLoadingState extends OffersListState {}

class OffersListSuccessState extends OffersListState {
  final List<OfferItem> items;
  final OffersPagination? pagination;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final int page;

  const OffersListSuccessState({
    required this.items,
    this.pagination,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.page = 1,
  });

  OffersListSuccessState copyWith({
    List<OfferItem>? items,
    OffersPagination? pagination,
    bool? hasReachedMax,
    bool? isLoadingMore,
    int? page,
  }) {
    return OffersListSuccessState(
      items: items ?? this.items,
      pagination: pagination ?? this.pagination,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [
        items,
        pagination,
        hasReachedMax,
        isLoadingMore,
        page,
      ];
}

class OffersListFailureState extends OffersListState {
  final String message;

  const OffersListFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
