import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/dashboard_model/summary_stats_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for fetching dashboard summary statistics.
class SummaryStatsUseCase implements UseCase<SummaryStatsResponse, NoParams> {
  final Repository _repository;

  const SummaryStatsUseCase(this._repository);

  @override
  Future<Either<Failure, SummaryStatsResponse>> call(NoParams params) async {
    return await _repository.dashboard_summary_stats(params);
  }
}
