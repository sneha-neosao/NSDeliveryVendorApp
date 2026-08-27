import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/auth_model/delete_account_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for permanently deleting the restaurant account.
class DeleteAccountUseCase implements UseCase<DeleteAccountResponse, NoParams> {
  final Repository _repository;

  const DeleteAccountUseCase(this._repository);

  @override
  Future<Either<Failure, DeleteAccountResponse>> call(NoParams params) async {
    return await _repository.delete_account(params);
  }
}
