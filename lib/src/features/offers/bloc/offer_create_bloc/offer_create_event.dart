part of 'offer_create_bloc.dart';

sealed class OfferCreateEvent extends Equatable {
  const OfferCreateEvent();

  @override
  List<Object?> get props => [];
}

class CreateOfferSubmitEvent extends OfferCreateEvent {
  final OfferCreateParams params;

  const CreateOfferSubmitEvent(this.params);

  @override
  List<Object?> get props => [params];
}
