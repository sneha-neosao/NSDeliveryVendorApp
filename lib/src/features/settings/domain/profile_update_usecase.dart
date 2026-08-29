import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/extensions/string_validator_extension.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/profile_model/profile_update_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for updating the restaurant profile details with validations.
class ProfileUpdateUseCase
    implements UseCase<ProfileUpdateResponse, ProfileUpdateParams> {
  final Repository _repository;

  const ProfileUpdateUseCase(this._repository);

  @override
  Future<Either<Failure, ProfileUpdateResponse>> call(
      ProfileUpdateParams params) async {
    // 1. Validation: First Name must not be empty
    if (params.firstName.trim().isEmpty) {
      return Left(EmptyFailure('Please enter first name'));
    }

    // 2. Validation: First Name minimum length check
    if (params.firstName.trim().length < 2) {
      return Left(EmptyFailure('First name must be at least 2 characters'));
    }

    // 3. Validation: Last Name must not be empty
    if (params.lastName.trim().isEmpty) {
      return Left(EmptyFailure('Please enter last name'));
    }

    // 4. Validation: Last Name minimum length check
    if (params.lastName.trim().length < 2) {
      return Left(EmptyFailure('Last name must be at least 2 characters'));
    }

    // 5. Validation: Contact number must not be empty
    if (params.entityContact.trim().isEmpty) {
      return Left(EmptyFailure('Please enter contact number'));
    }

    // 6. Validation: Contact number valid 10-digit mobile number format
    if (!params.entityContact.trim().isMobileNumberValid) {
      return Left(
          InvalidMobileNumberFailure('Please enter a valid 10-digit mobile number'));
    }

    return await _repository.profile_update(params);
  }
}

class ProfileUpdateParams extends Equatable {
  final String firstName;
  final String? middleName;
  final String lastName;
  final String entityContact;

  const ProfileUpdateParams({
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.entityContact,
  });

  Map<String, dynamic> toFormData() => {
        'first_name': firstName.trim(),
        if (middleName != null && middleName!.trim().isNotEmpty)
          'middle_name': middleName!.trim(),
        'last_name': lastName.trim(),
        'entity_contact': entityContact.trim(),
      };

  @override
  List<Object?> get props => [firstName, middleName, lastName, entityContact];
}
