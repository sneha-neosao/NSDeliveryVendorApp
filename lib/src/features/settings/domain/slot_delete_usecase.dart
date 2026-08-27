import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/slots_model/slot_delete_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for deleting an existing restaurant time slot.
class SlotDeleteUseCase
    implements UseCase<SlotDeleteResponse, SlotDeleteParams> {
  final Repository _repository;

  const SlotDeleteUseCase(this._repository);

  @override
  Future<Either<Failure, SlotDeleteResponse>> call(
      SlotDeleteParams params) async {
    if (params.uuId.trim().isEmpty) {
      return Left(EmptyFailure('Slot identifier is missing'));
    }

    return await _repository.slot_delete(params);
  }
}

class SlotDeleteParams extends Equatable {
  final String uuId;

  const SlotDeleteParams({
    required this.uuId,
  });

  @override
  List<Object?> get props => [uuId];
}
