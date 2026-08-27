import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/order_history_model/order_history_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for fetching order history.
class OrderHistoryUseCase
    implements UseCase<OrderHistoryResponse, OrderHistoryParams> {
  final Repository _repository;

  const OrderHistoryUseCase(this._repository);

  @override
  Future<Either<Failure, OrderHistoryResponse>> call(
      OrderHistoryParams params) async {
    return await _repository.order_history(params);
  }
}

class OrderHistoryParams extends Equatable {
  final int page;
  final int limit;

  const OrderHistoryParams({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}
