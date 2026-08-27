import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/order_update_status_usecase.dart';
import '../../../../remote/models/orders_list_model/order_status_update_response.dart';

part 'order_update_status_event.dart';
part 'order_update_status_state.dart';

/// Handles state management for **Order Update Status** operations.
class OrderUpdateStatusBloc
    extends Bloc<OrderUpdateStatusEvent, OrderUpdateStatusState> {
  final OrderUpdateStatusUseCase _orderUpdateStatusUseCase;

  OrderUpdateStatusBloc(this._orderUpdateStatusUseCase)
      : super(OrderUpdateStatusInitialState()) {
    on<UpdateOrderStatusEvent>(_updateOrderStatus);
  }

  Future<void> _updateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<OrderUpdateStatusState> emit,
  ) async {
    emit(OrderUpdateStatusLoadingState());

    final result = await _orderUpdateStatusUseCase.call(
      OrderUpdateStatusParams(
        uuId: event.uuId,
        orderStatus: event.orderStatus,
        note: event.note,
      ),
    );

    result.fold(
      (l) => emit(OrderUpdateStatusFailureState(l.message)),
      (r) => emit(OrderUpdateStatusSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE OrderUpdateStatusBloc =====");
    return super.close();
  }
}
