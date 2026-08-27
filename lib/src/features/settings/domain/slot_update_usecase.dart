import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/slots_model/slot_update_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for updating an existing restaurant time slot.
class SlotUpdateUseCase
    implements UseCase<SlotUpdateResponse, SlotUpdateParams> {
  final Repository _repository;

  const SlotUpdateUseCase(this._repository);

  @override
  Future<Either<Failure, SlotUpdateResponse>> call(
      SlotUpdateParams params) async {
    // 1. Validation: UUID must be provided
    if (params.uuId.trim().isEmpty) {
      return Left(EmptyFailure('Slot identifier is missing'));
    }

    // 2. Validation: All values must be present and not empty
    if (params.dayOfWeek.trim().isEmpty) {
      return Left(EmptyFailure('Please select a day of the week'));
    }

    if (params.startTime.trim().isEmpty) {
      return Left(EmptyFailure('Please select a start time'));
    }

    if (params.endTime.trim().isEmpty) {
      return Left(EmptyFailure('Please select an end time'));
    }

    // 3. Validation: Start Time must be whole hour (00) or half hour (30)
    final startParts = params.startTime.trim().split(':');
    if (startParts.length < 2) {
      return Left(EmptyFailure('Invalid start time format'));
    }
    final startHour = int.tryParse(startParts[0]);
    final startMinute = int.tryParse(startParts[1]);

    if (startHour == null ||
        startMinute == null ||
        startHour < 0 ||
        startHour > 23 ||
        (startMinute != 0 && startMinute != 30)) {
      return Left(EmptyFailure(
          'Start time must be a whole hour (e.g. 1:00) or half hour (e.g. 1:30)'));
    }

    // 4. Validation: End Time must be whole hour (00) or half hour (30)
    final endParts = params.endTime.trim().split(':');
    if (endParts.length < 2) {
      return Left(EmptyFailure('Invalid end time format'));
    }
    final endHour = int.tryParse(endParts[0]);
    final endMinute = int.tryParse(endParts[1]);

    if (endHour == null ||
        endMinute == null ||
        endHour < 0 ||
        endHour > 23 ||
        (endMinute != 0 && endMinute != 30)) {
      return Left(EmptyFailure(
          'End time must be a whole hour (e.g. 2:00) or half hour (e.g. 2:30)'));
    }

    // 5. Validation: End time must be greater than start time
    final startTotalMinutes = startHour * 60 + startMinute;
    final endTotalMinutes = endHour * 60 + endMinute;

    if (endTotalMinutes <= startTotalMinutes) {
      return Left(
          EmptyFailure('End time must be greater than start time'));
    }

    return await _repository.slot_update(params);
  }
}

class SlotUpdateParams extends Equatable {
  final String uuId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isActive;

  const SlotUpdateParams({
    required this.uuId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isActive,
  });

  Map<String, dynamic> toFormData() => {
        'day_of_week': dayOfWeek,
        'start_time': startTime,
        'end_time': endTime,
        'is_active': isActive.toString(),
      };

  @override
  List<Object?> get props => [uuId, dayOfWeek, startTime, endTime, isActive];
}
