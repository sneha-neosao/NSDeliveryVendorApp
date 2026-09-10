import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/dashboard_model/revenue_analytics_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for fetching dashboard revenue analytics.
class RevenueAnalyticsUseCase
    implements UseCase<RevenueAnalyticsResponse, NoParams> {
  final Repository _repository;

  const RevenueAnalyticsUseCase(this._repository);

  @override
  Future<Either<Failure, RevenueAnalyticsResponse>> call(
      NoParams params) async {
    return await _repository.dashboard_revenue_analytics(params);
  }
}
