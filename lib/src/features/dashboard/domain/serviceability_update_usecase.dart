import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/serviceability_model/serviceability_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for updating restaurant serviceability.
class ServiceabilityUpdateUseCase
    implements UseCase<ServiceabilityResponse, ServiceabilityUpdateParams> {
  final Repository _repository;

  const ServiceabilityUpdateUseCase(this._repository);

  @override
  Future<Either<Failure, ServiceabilityResponse>> call(
      ServiceabilityUpdateParams params) async {
    return await _repository.serviceability_update(params);
  }
}

class ServiceabilityUpdateParams extends Equatable {
  final bool adminIsServiceable;

  const ServiceabilityUpdateParams({
    required this.adminIsServiceable,
  });

  Map<String, dynamic> toFormData() => {
        'admin_is_serviceable': adminIsServiceable.toString(),
      };

  @override
  List<Object?> get props => [adminIsServiceable];
}
