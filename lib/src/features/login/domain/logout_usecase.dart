import 'package:fpdart/fpdart.dart';
import 'package:nsdelivery_vendor_app/src/configs/injector/injector.dart';
import 'package:nsdelivery_vendor_app/src/core/errors/failures.dart';
import 'package:nsdelivery_vendor_app/src/core/usecases/usecase.dart';
import 'package:nsdelivery_vendor_app/src/remote/models/common_response.dart';

/// Domain layer usecase for logging out the account.
class LogoutUseCase implements UseCase<CommonResponse, NoParams> {
  final Repository _authRepository;

  const LogoutUseCase(this._authRepository);

  @override
  Future<Either<Failure, CommonResponse>> call(NoParams params) async {
    final result = await _authRepository.logout(params);
    return result;
  }
}
