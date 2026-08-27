part of 'slot_update_bloc.dart';

sealed class SlotUpdateEvent extends Equatable {
  const SlotUpdateEvent();

  @override
  List<Object?> get props => [];
}

/// Event to update an existing time slot
class UpdateSlotEvent extends SlotUpdateEvent {
  final String uuId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isActive;

  const UpdateSlotEvent({
    required this.uuId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isActive,
  });

  @override
  List<Object?> get props => [uuId, dayOfWeek, startTime, endTime, isActive];
}
