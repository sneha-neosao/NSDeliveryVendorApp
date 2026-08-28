part of 'item_status_toggle_bloc.dart';

sealed class ItemStatusToggleState extends Equatable {
  const ItemStatusToggleState();

  @override
  List<Object?> get props => [];
}

class ItemStatusToggleInitialState extends ItemStatusToggleState {}

class ItemStatusToggleLoadingState extends ItemStatusToggleState {
  final String uuId;

  const ItemStatusToggleLoadingState({required this.uuId});

  @override
  List<Object?> get props => [uuId];
}

class ItemStatusToggleSuccessState extends ItemStatusToggleState {
  final ItemStatusToggleResponse data;

  const ItemStatusToggleSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ItemStatusToggleFailureState extends ItemStatusToggleState {
  final String message;
  final String uuId;

  const ItemStatusToggleFailureState({
    required this.message,
    required this.uuId,
  });

  @override
  List<Object?> get props => [message, uuId];
}
