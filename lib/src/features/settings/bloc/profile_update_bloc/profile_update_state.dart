part of 'profile_update_bloc.dart';

sealed class ProfileUpdateState extends Equatable {
  const ProfileUpdateState();

  @override
  List<Object?> get props => [];
}

class ProfileUpdateInitialState extends ProfileUpdateState {}

class ProfileUpdateLoadingState extends ProfileUpdateState {}

class ProfileUpdateSuccessState extends ProfileUpdateState {
  final ProfileUpdateResponse data;

  const ProfileUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ProfileUpdateFailureState extends ProfileUpdateState {
  final String message;

  const ProfileUpdateFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
