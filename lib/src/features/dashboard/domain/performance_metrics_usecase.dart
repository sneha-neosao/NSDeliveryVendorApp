import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/dashboard_model/performance_metrics_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for fetching dashboard performance metrics and top products.
class PerformanceMetricsUseCase
    implements UseCase<PerformanceMetricsResponse, NoParams> {
  final Repository _repository;

  const PerformanceMetricsUseCase(this._repository);

  @override
  Future<Either<Failure, PerformanceMetricsResponse>> call(
      NoParams params) async {
    return await _repository.dashboard_performance_metrics(params);
  }
}
