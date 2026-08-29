part of 'profile_update_bloc.dart';

sealed class ProfileUpdateEvent extends Equatable {
  const ProfileUpdateEvent();

  @override
  List<Object?> get props => [];
}

/// Event to update restaurant profile details
class UpdateProfileEvent extends ProfileUpdateEvent {
  final String firstName;
  final String? middleName;
  final String lastName;
  final String entityContact;

  const UpdateProfileEvent({
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.entityContact,
  });

  @override
  List<Object?> get props => [firstName, middleName, lastName, entityContact];
}
