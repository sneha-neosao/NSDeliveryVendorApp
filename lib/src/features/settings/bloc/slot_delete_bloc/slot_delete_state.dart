part of 'slot_delete_bloc.dart';

sealed class SlotDeleteState extends Equatable {
  const SlotDeleteState();

  @override
  List<Object?> get props => [];
}

class SlotDeleteInitialState extends SlotDeleteState {}

class SlotDeleteLoadingState extends SlotDeleteState {}

class SlotDeleteSuccessState extends SlotDeleteState {
  final SlotDeleteResponse data;

  const SlotDeleteSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class SlotDeleteFailureState extends SlotDeleteState {
  final String message;

  const SlotDeleteFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
