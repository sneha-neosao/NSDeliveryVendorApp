import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/extensions/string_validator_extension.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/auth_model/forgot_password_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for requesting password reset instructions via email.
class ForgotPasswordUseCase
    implements UseCase<ForgotPasswordResponse, ForgotPasswordParams> {
  final Repository _repository;

  const ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, ForgotPasswordResponse>> call(
      ForgotPasswordParams params) async {
    if (params.email.trim().isEmpty) {
      return Left(EmptyFailure('Please enter your email address'));
    }

    if (!params.email.trim().isEmailValid) {
      return Left(InvalidEmailFailure('Please enter a valid email address'));
    }

    return await _repository.forgot_password(params);
  }
}

class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams({
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
      };

  @override
  List<Object?> get props => [email];
}
