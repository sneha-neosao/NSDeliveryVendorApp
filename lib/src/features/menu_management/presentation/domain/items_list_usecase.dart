import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/items_model/items_list_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for fetching restaurant items list.
class ItemsListUseCase implements UseCase<ItemsListResponse, ItemsListParams> {
  final Repository _repository;

  const ItemsListUseCase(this._repository);

  @override
  Future<Either<Failure, ItemsListResponse>> call(ItemsListParams params) async {
    final result = await _repository.items_list(params);
    return result;
  }
}

class ItemsListParams extends Equatable {
  final int page;
  final int limit;
  final String? q;
  final String? status;

  const ItemsListParams({
    this.page = 1,
    this.limit = 10,
    this.q,
    this.status,
  });

  @override
  List<Object?> get props => [page, limit, q, status];
}
