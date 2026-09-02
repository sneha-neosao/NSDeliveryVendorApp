part of 'offer_status_toggle_bloc.dart';

sealed class OfferStatusToggleState extends Equatable {
  const OfferStatusToggleState();

  @override
  List<Object?> get props => [];
}

class OfferStatusToggleInitialState extends OfferStatusToggleState {}

class OfferStatusToggleLoadingState extends OfferStatusToggleState {
  final String uuId;

  const OfferStatusToggleLoadingState({required this.uuId});

  @override
  List<Object?> get props => [uuId];
}

class OfferStatusToggleSuccessState extends OfferStatusToggleState {
  final OfferStatusToggleResponse data;

  const OfferStatusToggleSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class OfferStatusToggleFailureState extends OfferStatusToggleState {
  final String message;
  final String uuId;

  const OfferStatusToggleFailureState({
    required this.message,
    required this.uuId,
  });

  @override
  List<Object?> get props => [message, uuId];
}
