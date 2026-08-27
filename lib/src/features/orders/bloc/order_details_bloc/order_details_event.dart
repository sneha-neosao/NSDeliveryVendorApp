part of 'order_details_bloc.dart';

sealed class OrderDetailsEvent extends Equatable {
  const OrderDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch order details by uu_id
class GetOrderDetailsEvent extends OrderDetailsEvent {
  final String uuId;

  const GetOrderDetailsEvent(this.uuId);

  @override
  List<Object?> get props => [uuId];
}
