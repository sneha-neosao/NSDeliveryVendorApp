part of 'profile_update_image_bloc.dart';

sealed class ProfileUpdateImageEvent extends Equatable {
  const ProfileUpdateImageEvent();

  @override
  List<Object?> get props => [];
}

/// Event to update restaurant profile image
class UpdateProfileImageEvent extends ProfileUpdateImageEvent {
  final File imageFile;

  const UpdateProfileImageEvent(this.imageFile);

  @override
  List<Object?> get props => [imageFile.path];
}
