import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/profile_model/profile_update_image_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for updating the restaurant profile image.
class ProfileUpdateImageUseCase
    implements UseCase<ProfileUpdateImageResponse, ProfileUpdateImageParams> {
  final Repository _repository;

  const ProfileUpdateImageUseCase(this._repository);

  @override
  Future<Either<Failure, ProfileUpdateImageResponse>> call(
      ProfileUpdateImageParams params) async {
    if (!params.imageFile.existsSync()) {
      return Left(EmptyFailure('Selected image file does not exist'));
    }

    return await _repository.profile_update_image(params);
  }
}

class ProfileUpdateImageParams extends Equatable {
  final File imageFile;

  const ProfileUpdateImageParams({
    required this.imageFile,
  });

  @override
  List<Object?> get props => [imageFile.path];
}
