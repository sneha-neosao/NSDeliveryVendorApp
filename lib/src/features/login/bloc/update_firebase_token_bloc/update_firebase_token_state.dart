part of 'update_firebase_token_bloc.dart';

sealed class UpdateFirebaseTokenState extends Equatable {
  const UpdateFirebaseTokenState();

  @override
  List<Object?> get props => [];
}

class UpdateFirebaseTokenInitialState extends UpdateFirebaseTokenState {}

class UpdateFirebaseTokenLoadingState extends UpdateFirebaseTokenState {}

class UpdateFirebaseTokenSuccessState extends UpdateFirebaseTokenState {
  final UpdateFirebaseTokenResponse data;

  const UpdateFirebaseTokenSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateFirebaseTokenFailureState extends UpdateFirebaseTokenState {
  final String message;

  const UpdateFirebaseTokenFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
