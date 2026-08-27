part of 'slots_list_bloc.dart';

sealed class SlotsListState extends Equatable {
  const SlotsListState();

  @override
  List<Object?> get props => [];
}

class SlotsListInitialState extends SlotsListState {}

class SlotsListLoadingState extends SlotsListState {}

class SlotsListSuccessState extends SlotsListState {
  final SlotsListResponse data;
  final List<SlotItem> items;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final int currentPage;

  const SlotsListSuccessState({
    required this.data,
    required this.items,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.currentPage = 1,
  });

  SlotsListSuccessState copyWith({
    SlotsListResponse? data,
    List<SlotItem>? items,
    bool? hasReachedMax,
    bool? isLoadingMore,
    int? currentPage,
  }) {
    return SlotsListSuccessState(
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

class SlotsListFailureState extends SlotsListState {
  final String message;

  const SlotsListFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
