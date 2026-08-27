import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/offers_model/offers_list_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for fetching promotional offers list.
class OffersListUseCase
    implements UseCase<OffersListResponse, OffersListParams> {
  final Repository _repository;

  const OffersListUseCase(this._repository);

  @override
  Future<Either<Failure, OffersListResponse>> call(
      OffersListParams params) async {
    return await _repository.offers_list(params);
  }
}

class OffersListParams extends Equatable {
  final int page;
  final int limit;

  const OffersListParams({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}
