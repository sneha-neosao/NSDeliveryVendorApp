import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/slots_model/slots_list_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for fetching restaurant time slots list.
class SlotsListUseCase
    implements UseCase<SlotsListResponse, SlotsListParams> {
  final Repository _repository;

  const SlotsListUseCase(this._repository);

  @override
  Future<Either<Failure, SlotsListResponse>> call(
      SlotsListParams params) async {
    return await _repository.slots_list(params);
  }
}

class SlotsListParams extends Equatable {
  final int page;
  final int limit;

  const SlotsListParams({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}
