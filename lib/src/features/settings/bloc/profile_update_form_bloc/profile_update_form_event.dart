part of 'profile_update_form_bloc.dart';

/// Base class for all Profile Update form input events
sealed class ProfileUpdateFormEvent extends Equatable {
  const ProfileUpdateFormEvent();

  @override
  List<Object?> get props => [];
}

/// Listens for changes in first name input
class ProfileUpdateFirstNameChangedEvent extends ProfileUpdateFormEvent {
  final String firstName;

  const ProfileUpdateFirstNameChangedEvent(this.firstName);

  @override
  List<Object?> get props => [firstName];
}

/// Listens for changes in middle name input
class ProfileUpdateMiddleNameChangedEvent extends ProfileUpdateFormEvent {
  final String middleName;

  const ProfileUpdateMiddleNameChangedEvent(this.middleName);

  @override
  List<Object?> get props => [middleName];
}

/// Listens for changes in last name input
class ProfileUpdateLastNameChangedEvent extends ProfileUpdateFormEvent {
  final String lastName;

  const ProfileUpdateLastNameChangedEvent(this.lastName);

  @override
  List<Object?> get props => [lastName];
}

/// Listens for changes in contact number input
class ProfileUpdateContactChangedEvent extends ProfileUpdateFormEvent {
  final String contact;

  const ProfileUpdateContactChangedEvent(this.contact);

  @override
  List<Object?> get props => [contact];
}

/// Event to populate initial form values
class ProfileUpdateInitFormDataEvent extends ProfileUpdateFormEvent {
  final String firstName;
  final String middleName;
  final String lastName;
  final String contact;

  const ProfileUpdateInitFormDataEvent({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.contact,
  });

  @override
  List<Object?> get props => [firstName, middleName, lastName, contact];
}
