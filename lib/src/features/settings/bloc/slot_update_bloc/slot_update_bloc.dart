import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/slot_update_usecase.dart';
import '../../../../remote/models/slots_model/slot_update_response.dart';

part 'slot_update_event.dart';
part 'slot_update_state.dart';

/// Handles state management for **Restaurant Time Slot Update** and its related operations.
class SlotUpdateBloc extends Bloc<SlotUpdateEvent, SlotUpdateState> {
  final SlotUpdateUseCase _slotUpdateUseCase;

  SlotUpdateBloc(this._slotUpdateUseCase) : super(SlotUpdateInitialState()) {
    on<UpdateSlotEvent>(_updateSlot);
  }

  Future<void> _updateSlot(
    UpdateSlotEvent event,
    Emitter<SlotUpdateState> emit,
  ) async {
    emit(SlotUpdateLoadingState());

    final result = await _slotUpdateUseCase.call(
      SlotUpdateParams(
        uuId: event.uuId,
        dayOfWeek: event.dayOfWeek,
        startTime: event.startTime,
        endTime: event.endTime,
        isActive: event.isActive,
      ),
    );

    result.fold(
      (l) => emit(SlotUpdateFailureState(l.message)),
      (r) => emit(SlotUpdateSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE SlotUpdateBloc =====");
    return super.close();
  }
}
