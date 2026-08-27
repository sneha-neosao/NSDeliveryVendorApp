part of 'order_update_status_bloc.dart';

sealed class OrderUpdateStatusEvent extends Equatable {
  const OrderUpdateStatusEvent();

  @override
  List<Object?> get props => [];
}

/// Event to update the status of an order
class UpdateOrderStatusEvent extends OrderUpdateStatusEvent {
  final String uuId;
  final String orderStatus;
  final String? note;

  const UpdateOrderStatusEvent({
    required this.uuId,
    required this.orderStatus,
    this.note,
  });

  @override
  List<Object?> get props => [uuId, orderStatus, note];
}
