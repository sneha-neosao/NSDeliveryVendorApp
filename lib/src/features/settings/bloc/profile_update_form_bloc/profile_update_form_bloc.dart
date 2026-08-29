import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/string_validator_extension.dart';
import '../../../../core/utils/logger.dart';

part 'profile_update_form_event.dart';
part 'profile_update_form_state.dart';

/// Handles validation logic for **Profile Update Form Inputs**.
class ProfileUpdateFormBloc
    extends Bloc<ProfileUpdateFormEvent, ProfileUpdateFormState> {
  ProfileUpdateFormBloc() : super(const ProfileUpdateFormInitialState()) {
    on<ProfileUpdateFirstNameChangedEvent>(_firstNameChanged);
    on<ProfileUpdateMiddleNameChangedEvent>(_middleNameChanged);
    on<ProfileUpdateLastNameChangedEvent>(_lastNameChanged);
    on<ProfileUpdateContactChangedEvent>(_contactChanged);
    on<ProfileUpdateInitFormDataEvent>(_initFormData);
  }

  Future _firstNameChanged(
      ProfileUpdateFirstNameChangedEvent event, Emitter emit) async {
    emit(
      ProfileUpdateFormDataState(
        inputFirstName: event.firstName,
        inputMiddleName: state.middleName,
        inputLastName: state.lastName,
        inputEntityContact: state.entityContact,
        inputIsValid: inputValidator(
          firstName: event.firstName,
          middleName: state.middleName,
          lastName: state.lastName,
          contact: state.entityContact,
        ),
      ),
    );
  }

  Future _middleNameChanged(
      ProfileUpdateMiddleNameChangedEvent event, Emitter emit) async {
    emit(
      ProfileUpdateFormDataState(
        inputFirstName: state.firstName,
        inputMiddleName: event.middleName,
        inputLastName: state.lastName,
        inputEntityContact: state.entityContact,
        inputIsValid: inputValidator(
          firstName: state.firstName,
          middleName: event.middleName,
          lastName: state.lastName,
          contact: state.entityContact,
        ),
      ),
    );
  }

  Future _lastNameChanged(
      ProfileUpdateLastNameChangedEvent event, Emitter emit) async {
    emit(
      ProfileUpdateFormDataState(
        inputFirstName: state.firstName,
        inputMiddleName: state.middleName,
        inputLastName: event.lastName,
        inputEntityContact: state.entityContact,
        inputIsValid: inputValidator(
          firstName: state.firstName,
          middleName: state.middleName,
          lastName: event.lastName,
          contact: state.entityContact,
        ),
      ),
    );
  }

  Future _contactChanged(
      ProfileUpdateContactChangedEvent event, Emitter emit) async {
    emit(
      ProfileUpdateFormDataState(
        inputFirstName: state.firstName,
        inputMiddleName: state.middleName,
        inputLastName: state.lastName,
        inputEntityContact: event.contact,
        inputIsValid: inputValidator(
          firstName: state.firstName,
          middleName: state.middleName,
          lastName: state.lastName,
          contact: event.contact,
        ),
      ),
    );
  }

  Future _initFormData(
      ProfileUpdateInitFormDataEvent event, Emitter emit) async {
    emit(
      ProfileUpdateFormDataState(
        inputFirstName: event.firstName,
        inputMiddleName: event.middleName,
        inputLastName: event.lastName,
        inputEntityContact: event.contact,
        inputIsValid: inputValidator(
          firstName: event.firstName,
          middleName: event.middleName,
          lastName: event.lastName,
          contact: event.contact,
        ),
      ),
    );
  }

  bool inputValidator({
    required String firstName,
    required String middleName,
    required String lastName,
    required String contact,
  }) {
    if (firstName.trim().isEmpty || lastName.trim().isEmpty) {
      return false;
    }
    if (firstName.trim().length < 2 || lastName.trim().length < 2) {
      return false;
    }
    if (contact.trim().isEmpty || !contact.trim().isMobileNumberValid) {
      return false;
    }
    return true;
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ProfileUpdateFormBloc =====");
    return super.close();
  }
}
