part of 'slot_delete_bloc.dart';

sealed class SlotDeleteEvent extends Equatable {
  const SlotDeleteEvent();

  @override
  List<Object?> get props => [];
}

/// Event to delete an existing time slot
class DeleteSlotEvent extends SlotDeleteEvent {
  final String uuId;

  const DeleteSlotEvent({
    required this.uuId,
  });

  @override
  List<Object?> get props => [uuId];
}
