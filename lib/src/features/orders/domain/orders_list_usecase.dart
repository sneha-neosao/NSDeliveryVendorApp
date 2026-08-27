import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/orders_list_model/orders_list_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for fetching the ongoing orders list.
class OrdersListUseCase
    implements UseCase<OrdersListResponse, OrdersListParams> {
  final Repository _repository;

  const OrdersListUseCase(this._repository);

  @override
  Future<Either<Failure, OrdersListResponse>> call(
      OrdersListParams params) async {
    return await _repository.orders_list(params);
  }
}

class OrdersListParams extends Equatable {
  final int page;
  final int limit;

  const OrdersListParams({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}
