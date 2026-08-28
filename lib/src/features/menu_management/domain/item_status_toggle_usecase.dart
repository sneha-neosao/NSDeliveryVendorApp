import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../remote/models/items_model/item_status_toggle_response.dart';
import '../../../remote/repositories/repository_impl.dart';

/// Domain layer use case for toggling the availability status of a menu item.
class ItemStatusToggleUseCase
    implements UseCase<ItemStatusToggleResponse, ItemStatusToggleParams> {
  final Repository _repository;

  const ItemStatusToggleUseCase(this._repository);

  @override
  Future<Either<Failure, ItemStatusToggleResponse>> call(
      ItemStatusToggleParams params) async {
    return await _repository.item_status_toggle(params);
  }
}

class ItemStatusToggleParams extends Equatable {
  final String uuId;
  final bool itemStatus;

  const ItemStatusToggleParams({
    required this.uuId,
    required this.itemStatus,
  });

  @override
  List<Object?> get props => [uuId, itemStatus];
}
