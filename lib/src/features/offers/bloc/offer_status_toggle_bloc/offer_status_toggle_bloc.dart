import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/offer_status_toggle_usecase.dart';
import '../../../../remote/models/offers_model/offer_status_toggle_response.dart';

part 'offer_status_toggle_event.dart';
part 'offer_status_toggle_state.dart';

/// Handles state management for **Toggle Offer Status**.
class OfferStatusToggleBloc
    extends Bloc<OfferStatusToggleEvent, OfferStatusToggleState> {
  final OfferStatusToggleUseCase _offerStatusToggleUseCase;

  OfferStatusToggleBloc(this._offerStatusToggleUseCase)
      : super(OfferStatusToggleInitialState()) {
    on<ToggleOfferStatusEvent>(_toggleOfferStatus);
  }

  Future<void> _toggleOfferStatus(
    ToggleOfferStatusEvent event,
    Emitter<OfferStatusToggleState> emit,
  ) async {
    emit(OfferStatusToggleLoadingState(uuId: event.uuId));

    final result = await _offerStatusToggleUseCase.call(
      OfferStatusToggleParams(
        uuId: event.uuId,
        isActive: event.isActive,
      ),
    );

    result.fold(
      (l) => emit(OfferStatusToggleFailureState(
        message: l.message,
        uuId: event.uuId,
      )),
      (r) => emit(OfferStatusToggleSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE OfferStatusToggleBloc =====");
    return super.close();
  }
}
