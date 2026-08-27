part of 'serviceability_bloc.dart';

sealed class ServiceabilityState extends Equatable {
  const ServiceabilityState();

  @override
  List<Object?> get props => [];
}

class ServiceabilityInitialState extends ServiceabilityState {}

/// States representing the serviceability update operation
class ServiceabilityUpdateLoadingState extends ServiceabilityState {}

class ServiceabilityUpdateSuccessState extends ServiceabilityState {
  final ServiceabilityResponse data;

  const ServiceabilityUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceabilityUpdateFailureState extends ServiceabilityState {
  final String message;

  const ServiceabilityUpdateFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
