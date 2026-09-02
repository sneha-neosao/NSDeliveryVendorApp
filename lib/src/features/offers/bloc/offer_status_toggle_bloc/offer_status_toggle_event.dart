part of 'offer_status_toggle_bloc.dart';

sealed class OfferStatusToggleEvent extends Equatable {
  const OfferStatusToggleEvent();

  @override
  List<Object?> get props => [];
}

class ToggleOfferStatusEvent extends OfferStatusToggleEvent {
  final String uuId;
  final bool isActive;

  const ToggleOfferStatusEvent({
    required this.uuId,
    required this.isActive,
  });

  @override
  List<Object?> get props => [uuId, isActive];
}
