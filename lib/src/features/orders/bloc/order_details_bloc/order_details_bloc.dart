import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/order_details_usecase.dart';
import '../../../../remote/models/order_details_model/order_details_response.dart';

part 'order_details_event.dart';
part 'order_details_state.dart';

/// Handles state management for **Order Details** and its related operations.
class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final OrderDetailsUseCase _orderDetailsUseCase;

  OrderDetailsBloc(this._orderDetailsUseCase)
      : super(OrderDetailsInitialState()) {
    on<GetOrderDetailsEvent>(_getOrderDetails);
  }

  Future<void> _getOrderDetails(
    GetOrderDetailsEvent event,
    Emitter<OrderDetailsState> emit,
  ) async {
    emit(OrderDetailsLoadingState());

    final result = await _orderDetailsUseCase.call(
      OrderDetailsParams(uuId: event.uuId),
    );

    result.fold(
      (l) => emit(OrderDetailsFailureState(l.message)),
      (r) => emit(OrderDetailsSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE OrderDetailsBloc =====");
    return super.close();
  }
}
