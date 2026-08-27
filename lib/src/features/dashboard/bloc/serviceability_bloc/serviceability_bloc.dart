import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/serviceability_update_usecase.dart';
import '../../../../remote/models/serviceability_model/serviceability_response.dart';

part 'serviceability_event.dart';
part 'serviceability_state.dart';

/// Handles state management for **Restaurant Serviceability** and its related operations.
class ServiceabilityBloc
    extends Bloc<ServiceabilityEvent, ServiceabilityState> {
  final ServiceabilityUpdateUseCase _serviceabilityUpdateUseCase;

  ServiceabilityBloc(this._serviceabilityUpdateUseCase)
      : super(ServiceabilityInitialState()) {
    on<UpdateServiceabilityEvent>(_updateServiceability);
  }

  Future<void> _updateServiceability(
    UpdateServiceabilityEvent event,
    Emitter<ServiceabilityState> emit,
  ) async {
    emit(ServiceabilityUpdateLoadingState());

    final result = await _serviceabilityUpdateUseCase.call(
      ServiceabilityUpdateParams(
        adminIsServiceable: event.adminIsServiceable,
      ),
    );

    result.fold(
      (l) => emit(ServiceabilityUpdateFailureState(l.message)),
      (r) => emit(ServiceabilityUpdateSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ServiceabilityBloc =====");
    return super.close();
  }
}
