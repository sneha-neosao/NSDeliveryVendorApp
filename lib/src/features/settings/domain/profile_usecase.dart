import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/profile_model/profile_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for fetching the restaurant profile details.
class ProfileUseCase implements UseCase<ProfileResponse, NoParams> {
  final Repository _repository;

  const ProfileUseCase(this._repository);

  @override
  Future<Either<Failure, ProfileResponse>> call(NoParams params) async {
    return await _repository.profile_list(params);
  }
}
