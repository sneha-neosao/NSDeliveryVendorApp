part of 'profile_update_image_bloc.dart';

sealed class ProfileUpdateImageState extends Equatable {
  const ProfileUpdateImageState();

  @override
  List<Object?> get props => [];
}

class ProfileUpdateImageInitialState extends ProfileUpdateImageState {}

class ProfileUpdateImageLoadingState extends ProfileUpdateImageState {}

class ProfileUpdateImageSuccessState extends ProfileUpdateImageState {
  final ProfileUpdateImageResponse data;

  const ProfileUpdateImageSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ProfileUpdateImageFailureState extends ProfileUpdateImageState {
  final String message;

  const ProfileUpdateImageFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
