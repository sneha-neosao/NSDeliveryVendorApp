import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/auth_model/app_version_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for fetching vendor app version details.
class AppVersionUseCase implements UseCase<AppVersionResponse, NoParams> {
  final Repository _repository;

  const AppVersionUseCase(this._repository);

  @override
  Future<Either<Failure, AppVersionResponse>> call(NoParams params) async {
    return await _repository.app_version(params);
  }
}
