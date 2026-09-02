part of 'offer_create_bloc.dart';

sealed class OfferCreateState extends Equatable {
  const OfferCreateState();

  @override
  List<Object?> get props => [];
}

class OfferCreateInitialState extends OfferCreateState {}

class OfferCreateLoadingState extends OfferCreateState {}

class OfferCreateSuccessState extends OfferCreateState {
  final OfferCreateResponse data;

  const OfferCreateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class OfferCreateFailureState extends OfferCreateState {
  final String message;

  const OfferCreateFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
