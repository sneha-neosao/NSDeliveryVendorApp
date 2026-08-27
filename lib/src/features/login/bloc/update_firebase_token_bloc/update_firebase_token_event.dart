part of 'update_firebase_token_bloc.dart';

sealed class UpdateFirebaseTokenEvent extends Equatable {
  const UpdateFirebaseTokenEvent();

  @override
  List<Object?> get props => [];
}

/// Event to update Firebase push notification token
class UpdateFirebaseTokenSubmitEvent extends UpdateFirebaseTokenEvent {
  final String firebaseToken;

  const UpdateFirebaseTokenSubmitEvent(this.firebaseToken);

  @override
  List<Object?> get props => [firebaseToken];
}
