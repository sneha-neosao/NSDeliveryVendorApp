import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/slots_model/slot_create_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for creating a new restaurant time slot with business validations.
class SlotCreateUseCase
    implements UseCase<SlotCreateResponse, SlotCreateParams> {
  final Repository _repository;

  const SlotCreateUseCase(this._repository);

  @override
  Future<Either<Failure, SlotCreateResponse>> call(
      SlotCreateParams params) async {
    // 1. Validation: All values must be present and not empty
    if (params.dayOfWeek.trim().isEmpty) {
      return Left(EmptyFailure('Please select a day of the week'));
    }

    if (params.startTime.trim().isEmpty) {
      return Left(EmptyFailure('Please select a start time'));
    }

    if (params.endTime.trim().isEmpty) {
      return Left(EmptyFailure('Please select an end time'));
    }

    // 2. Validation: Start Time must be whole hour (00) or half hour (30)
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

    // 3. Validation: End Time must be whole hour (00) or half hour (30)
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

    // 4. Validation: End time must be greater than start time
    final startTotalMinutes = startHour * 60 + startMinute;
    final endTotalMinutes = endHour * 60 + endMinute;

    if (endTotalMinutes <= startTotalMinutes) {
      return Left(
          EmptyFailure('End time must be greater than start time'));
    }

    return await _repository.slot_create(params);
  }
}

class SlotCreateParams extends Equatable {
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isActive;

  const SlotCreateParams({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.isActive = true,
  });

  Map<String, dynamic> toFormData() => {
        'day_of_week': dayOfWeek,
        'start_time': startTime,
        'end_time': endTime,
        'is_active': isActive.toString(),
      };

  @override
  List<Object?> get props => [dayOfWeek, startTime, endTime, isActive];
}
