import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/offers_model/offer_status_toggle_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for toggling the active status of a promotional offer.
class OfferStatusToggleUseCase
    implements UseCase<OfferStatusToggleResponse, OfferStatusToggleParams> {
  final Repository _repository;

  const OfferStatusToggleUseCase(this._repository);

  @override
  Future<Either<Failure, OfferStatusToggleResponse>> call(
      OfferStatusToggleParams params) async {
    return await _repository.offer_status_toggle(params);
  }
}

class OfferStatusToggleParams extends Equatable {
  final String uuId;
  final bool isActive;

  const OfferStatusToggleParams({
    required this.uuId,
    required this.isActive,
  });

  @override
  List<Object?> get props => [uuId, isActive];
}
