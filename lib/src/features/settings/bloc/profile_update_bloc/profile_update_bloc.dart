import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/profile_update_usecase.dart';
import '../../../../remote/models/profile_model/profile_update_response.dart';

part 'profile_update_event.dart';
part 'profile_update_state.dart';

/// Handles state management for **Profile Update** and its related operations.
class ProfileUpdateBloc extends Bloc<ProfileUpdateEvent, ProfileUpdateState> {
  final ProfileUpdateUseCase _profileUpdateUseCase;

  ProfileUpdateBloc(this._profileUpdateUseCase)
      : super(ProfileUpdateInitialState()) {
    on<UpdateProfileEvent>(_updateProfile);
  }

  Future<void> _updateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileUpdateState> emit,
  ) async {
    emit(ProfileUpdateLoadingState());

    final result = await _profileUpdateUseCase.call(
      ProfileUpdateParams(
        firstName: event.firstName,
        middleName: event.middleName,
        lastName: event.lastName,
        entityContact: event.entityContact,
      ),
    );

    result.fold(
      (l) => emit(ProfileUpdateFailureState(l.message)),
      (r) => emit(ProfileUpdateSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ProfileUpdateBloc =====");
    return super.close();
  }
}
