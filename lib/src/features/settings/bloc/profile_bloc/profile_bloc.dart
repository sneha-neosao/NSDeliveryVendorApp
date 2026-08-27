import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/profile_usecase.dart';
import '../../../../remote/models/profile_model/profile_response.dart';

part 'profile_event.dart';
part 'profile_state.dart';

/// Handles state management for **Profile** and its related operations.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileUseCase _profileUseCase;

  ProfileBloc(this._profileUseCase) : super(ProfileInitialState()) {
    on<FetchProfileEvent>(_fetchProfile);
  }

  Future<void> _fetchProfile(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());

    final result = await _profileUseCase.call(NoParams());

    result.fold(
      (l) => emit(ProfileFailureState(l.message)),
      (r) => emit(ProfileSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ProfileBloc =====");
    return super.close();
  }
}
