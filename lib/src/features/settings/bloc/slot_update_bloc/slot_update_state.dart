part of 'slot_update_bloc.dart';

sealed class SlotUpdateState extends Equatable {
  const SlotUpdateState();

  @override
  List<Object?> get props => [];
}

class SlotUpdateInitialState extends SlotUpdateState {}

class SlotUpdateLoadingState extends SlotUpdateState {}

class SlotUpdateSuccessState extends SlotUpdateState {
  final SlotUpdateResponse data;

  const SlotUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class SlotUpdateFailureState extends SlotUpdateState {
  final String message;

  const SlotUpdateFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
