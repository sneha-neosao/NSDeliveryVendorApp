import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/orders_list_model/order_status_update_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for updating the status of an order.
class OrderUpdateStatusUseCase
    implements UseCase<OrderStatusUpdateResponse, OrderUpdateStatusParams> {
  final Repository _repository;

  const OrderUpdateStatusUseCase(this._repository);

  @override
  Future<Either<Failure, OrderStatusUpdateResponse>> call(
      OrderUpdateStatusParams params) async {
    if (params.uuId.trim().isEmpty) {
      return Left(EmptyFailure('Order ID cannot be empty'));
    }

    if (params.orderStatus.trim().isEmpty) {
      return Left(EmptyFailure('Order status cannot be empty'));
    }

    return await _repository.order_update_status(params);
  }
}

class OrderUpdateStatusParams extends Equatable {
  final String uuId;
  final String orderStatus;
  final String? note;

  const OrderUpdateStatusParams({
    required this.uuId,
    required this.orderStatus,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'order_status': orderStatus,
        if (note != null && note!.isNotEmpty) 'note': note,
      };

  @override
  List<Object?> get props => [uuId, orderStatus, note];
}
