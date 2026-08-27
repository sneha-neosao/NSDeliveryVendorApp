part of 'slot_create_bloc.dart';

sealed class SlotCreateEvent extends Equatable {
  const SlotCreateEvent();

  @override
  List<Object?> get props => [];
}

/// Event to create a new time slot
class CreateSlotEvent extends SlotCreateEvent {
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isActive;

  const CreateSlotEvent({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [dayOfWeek, startTime, endTime, isActive];
}
