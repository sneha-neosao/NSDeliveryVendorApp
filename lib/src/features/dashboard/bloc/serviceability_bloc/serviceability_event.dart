part of 'serviceability_bloc.dart';

sealed class ServiceabilityEvent extends Equatable {
  const ServiceabilityEvent();

  @override
  List<Object?> get props => [];
}

/// Event to update the restaurant's serviceability status
class UpdateServiceabilityEvent extends ServiceabilityEvent {
  final bool adminIsServiceable;

  const UpdateServiceabilityEvent({
    required this.adminIsServiceable,
  });

  @override
  List<Object?> get props => [adminIsServiceable];
}
