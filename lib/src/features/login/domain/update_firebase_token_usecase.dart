import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/auth_model/update_firebase_token_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for updating the Firebase push notification token.
class UpdateFirebaseTokenUseCase
    implements UseCase<UpdateFirebaseTokenResponse, UpdateFirebaseTokenParams> {
  final Repository _repository;

  const UpdateFirebaseTokenUseCase(this._repository);

  @override
  Future<Either<Failure, UpdateFirebaseTokenResponse>> call(
      UpdateFirebaseTokenParams params) async {
    return await _repository.update_firebase_token(params);
  }
}

class UpdateFirebaseTokenParams extends Equatable {
  final String firebaseToken;

  const UpdateFirebaseTokenParams({
    required this.firebaseToken,
  });

  Map<String, dynamic> toJson() => {
        'firebase_token': firebaseToken,
      };

  @override
  List<Object?> get props => [firebaseToken];
}
