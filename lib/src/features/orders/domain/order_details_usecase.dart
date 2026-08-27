import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/order_details_model/order_details_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for fetching order details.
class OrderDetailsUseCase
    implements UseCase<OrderDetailsResponse, OrderDetailsParams> {
  final Repository _repository;

  const OrderDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, OrderDetailsResponse>> call(
      OrderDetailsParams params) async {
    return await _repository.order_details(params);
  }
}

class OrderDetailsParams extends Equatable {
  final String uuId;

  const OrderDetailsParams({
    required this.uuId,
  });

  @override
  List<Object?> get props => [uuId];
}
