import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/slot_delete_usecase.dart';
import '../../../../remote/models/slots_model/slot_delete_response.dart';

part 'slot_delete_event.dart';
part 'slot_delete_state.dart';

/// Handles state management for **Restaurant Time Slot Deletion** and its related operations.
class SlotDeleteBloc extends Bloc<SlotDeleteEvent, SlotDeleteState> {
  final SlotDeleteUseCase _slotDeleteUseCase;

  SlotDeleteBloc(this._slotDeleteUseCase) : super(SlotDeleteInitialState()) {
    on<DeleteSlotEvent>(_deleteSlot);
  }

  Future<void> _deleteSlot(
    DeleteSlotEvent event,
    Emitter<SlotDeleteState> emit,
  ) async {
    emit(SlotDeleteLoadingState());

    final result = await _slotDeleteUseCase.call(
      SlotDeleteParams(
        uuId: event.uuId,
      ),
    );

    result.fold(
      (l) => emit(SlotDeleteFailureState(l.message)),
      (r) => emit(SlotDeleteSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE SlotDeleteBloc =====");
    return super.close();
  }
}
