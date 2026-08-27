part of 'slot_create_bloc.dart';

sealed class SlotCreateState extends Equatable {
  const SlotCreateState();

  @override
  List<Object?> get props => [];
}

class SlotCreateInitialState extends SlotCreateState {}

class SlotCreateLoadingState extends SlotCreateState {}

class SlotCreateSuccessState extends SlotCreateState {
  final SlotCreateResponse data;

  const SlotCreateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class SlotCreateFailureState extends SlotCreateState {
  final String message;

  const SlotCreateFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
