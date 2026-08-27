import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/slot_create_usecase.dart';
import '../../../../remote/models/slots_model/slot_create_response.dart';

part 'slot_create_event.dart';
part 'slot_create_state.dart';

/// Handles state management for **Restaurant Time Slot Creation** and its related operations.
class SlotCreateBloc extends Bloc<SlotCreateEvent, SlotCreateState> {
  final SlotCreateUseCase _slotCreateUseCase;

  SlotCreateBloc(this._slotCreateUseCase) : super(SlotCreateInitialState()) {
    on<CreateSlotEvent>(_createSlot);
  }

  Future<void> _createSlot(
    CreateSlotEvent event,
    Emitter<SlotCreateState> emit,
  ) async {
    emit(SlotCreateLoadingState());

    final result = await _slotCreateUseCase.call(
      SlotCreateParams(
        dayOfWeek: event.dayOfWeek,
        startTime: event.startTime,
        endTime: event.endTime,
        isActive: event.isActive,
      ),
    );

    result.fold(
      (l) => emit(SlotCreateFailureState(l.message)),
      (r) => emit(SlotCreateSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE SlotCreateBloc =====");
    return super.close();
  }
}
