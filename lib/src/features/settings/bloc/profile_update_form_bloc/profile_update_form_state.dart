part of 'profile_update_form_bloc.dart';

/// Base state for Profile Update Form Validation BLoC.
///
/// Holds the current form inputs and a validation flag [isValid].
sealed class ProfileUpdateFormState extends Equatable {
  final String firstName;
  final String middleName;
  final String lastName;
  final String entityContact;
  final bool isValid;

  const ProfileUpdateFormState({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.entityContact,
    required this.isValid,
  });

  @override
  List<Object?> get props => [
        firstName,
        middleName,
        lastName,
        entityContact,
        isValid,
      ];
}

/// Provides a default empty form state with [isValid] set to false.
class ProfileUpdateFormInitialState extends ProfileUpdateFormState {
  const ProfileUpdateFormInitialState()
      : super(
          firstName: "",
          middleName: "",
          lastName: "",
          entityContact: "",
          isValid: false,
        );
}

/// State representing the current validated data after an input change or initialization.
class ProfileUpdateFormDataState extends ProfileUpdateFormState {
  final String inputFirstName;
  final String inputMiddleName;
  final String inputLastName;
  final String inputEntityContact;
  final bool inputIsValid;

  const ProfileUpdateFormDataState({
    required this.inputFirstName,
    required this.inputMiddleName,
    required this.inputLastName,
    required this.inputEntityContact,
    required this.inputIsValid,
  }) : super(
          firstName: inputFirstName,
          middleName: inputMiddleName,
          lastName: inputLastName,
          entityContact: inputEntityContact,
          isValid: inputIsValid,
        );

  @override
  List<Object?> get props => [
        inputFirstName,
        inputMiddleName,
        inputLastName,
        inputEntityContact,
        inputIsValid,
      ];
}
