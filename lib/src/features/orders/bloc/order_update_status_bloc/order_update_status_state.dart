part of 'order_update_status_bloc.dart';

sealed class OrderUpdateStatusState extends Equatable {
  const OrderUpdateStatusState();

  @override
  List<Object?> get props => [];
}

class OrderUpdateStatusInitialState extends OrderUpdateStatusState {}

class OrderUpdateStatusLoadingState extends OrderUpdateStatusState {}

class OrderUpdateStatusSuccessState extends OrderUpdateStatusState {
  final OrderStatusUpdateResponse data;

  const OrderUpdateStatusSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class OrderUpdateStatusFailureState extends OrderUpdateStatusState {
  final String message;

  const OrderUpdateStatusFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
