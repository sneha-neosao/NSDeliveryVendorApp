part of 'item_status_toggle_bloc.dart';

sealed class ItemStatusToggleEvent extends Equatable {
  const ItemStatusToggleEvent();

  @override
  List<Object?> get props => [];
}

/// Event to toggle the status (available / unavailable) of a menu item
class ToggleItemStatusEvent extends ItemStatusToggleEvent {
  final String uuId;
  final bool itemStatus;

  const ToggleItemStatusEvent({
    required this.uuId,
    required this.itemStatus,
  });

  @override
  List<Object?> get props => [uuId, itemStatus];
}
