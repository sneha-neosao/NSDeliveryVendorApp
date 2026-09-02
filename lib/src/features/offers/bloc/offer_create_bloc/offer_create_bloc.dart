import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/offer_create_usecase.dart';
import '../../../../remote/models/offers_model/offer_create_response.dart';

part 'offer_create_event.dart';
part 'offer_create_state.dart';

/// Handles state management for creating a promotional offer.
class OfferCreateBloc extends Bloc<OfferCreateEvent, OfferCreateState> {
  final OfferCreateUseCase _offerCreateUseCase;

  OfferCreateBloc(this._offerCreateUseCase) : super(OfferCreateInitialState()) {
    on<CreateOfferSubmitEvent>(_createOffer);
  }

  Future<void> _createOffer(
    CreateOfferSubmitEvent event,
    Emitter<OfferCreateState> emit,
  ) async {
    emit(OfferCreateLoadingState());

    final result = await _offerCreateUseCase.call(event.params);

    result.fold(
      (l) => emit(OfferCreateFailureState(l.message)),
      (r) => emit(OfferCreateSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE OfferCreateBloc =====");
    return super.close();
  }
}
