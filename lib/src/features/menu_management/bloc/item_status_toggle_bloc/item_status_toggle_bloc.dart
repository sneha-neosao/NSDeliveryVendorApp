import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/item_status_toggle_usecase.dart';
import '../../../../remote/models/items_model/item_status_toggle_response.dart';

part 'item_status_toggle_event.dart';
part 'item_status_toggle_state.dart';

/// Handles state management for **Toggle Item Status**.
class ItemStatusToggleBloc
    extends Bloc<ItemStatusToggleEvent, ItemStatusToggleState> {
  final ItemStatusToggleUseCase _itemStatusToggleUseCase;

  ItemStatusToggleBloc(this._itemStatusToggleUseCase)
      : super(ItemStatusToggleInitialState()) {
    on<ToggleItemStatusEvent>(_toggleItemStatus);
  }

  Future<void> _toggleItemStatus(
    ToggleItemStatusEvent event,
    Emitter<ItemStatusToggleState> emit,
  ) async {
    emit(ItemStatusToggleLoadingState(uuId: event.uuId));

    final result = await _itemStatusToggleUseCase.call(
      ItemStatusToggleParams(
        uuId: event.uuId,
        itemStatus: event.itemStatus,
      ),
    );

    result.fold(
      (l) => emit(ItemStatusToggleFailureState(
        message: l.message,
        uuId: event.uuId,
      )),
      (r) => emit(ItemStatusToggleSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ItemStatusToggleBloc =====");
    return super.close();
  }
}
