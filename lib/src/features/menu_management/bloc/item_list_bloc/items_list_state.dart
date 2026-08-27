part of 'items_list_bloc.dart';

sealed class ItemsListState extends Equatable {
  const ItemsListState();

  @override
  List<Object?> get props => [];
}

class ItemsListInitialState extends ItemsListState {}

class ItemsListLoadingState extends ItemsListState {}

class ItemsListSuccessState extends ItemsListState {
  final ItemsListResponse data;
  final List<RestaurantItem> items;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final int currentPage;
  final String? currentQuery;
  final String? currentStatus;

  const ItemsListSuccessState({
    required this.data,
    required this.items,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.currentPage = 1,
    this.currentQuery,
    this.currentStatus,
  });

  ItemsListSuccessState copyWith({
    ItemsListResponse? data,
    List<RestaurantItem>? items,
    bool? hasReachedMax,
    bool? isLoadingMore,
    int? currentPage,
    String? currentQuery,
    String? currentStatus,
  }) {
    return ItemsListSuccessState(
      data: data ?? this.data,
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      currentQuery: currentQuery ?? this.currentQuery,
      currentStatus: currentStatus ?? this.currentStatus,
    );
  }

  @override
  List<Object?> get props => [
        data,
        items,
        hasReachedMax,
        isLoadingMore,
        currentPage,
        currentQuery,
        currentStatus,
      ];
}

class ItemsListFailureState extends ItemsListState {
  final String message;

  const ItemsListFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
