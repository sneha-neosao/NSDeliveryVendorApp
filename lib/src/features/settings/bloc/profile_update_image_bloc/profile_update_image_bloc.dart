import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/profile_update_image_usecase.dart';
import '../../../../remote/models/profile_model/profile_update_image_response.dart';

part 'profile_update_image_event.dart';
part 'profile_update_image_state.dart';

/// Handles state management for **Profile Update Image** and its related operations.
class ProfileUpdateImageBloc
    extends Bloc<ProfileUpdateImageEvent, ProfileUpdateImageState> {
  final ProfileUpdateImageUseCase _profileUpdateImageUseCase;

  ProfileUpdateImageBloc(this._profileUpdateImageUseCase)
      : super(ProfileUpdateImageInitialState()) {
    on<UpdateProfileImageEvent>(_updateProfileImage);
  }

  Future<void> _updateProfileImage(
    UpdateProfileImageEvent event,
    Emitter<ProfileUpdateImageState> emit,
  ) async {
    emit(ProfileUpdateImageLoadingState());

    final result = await _profileUpdateImageUseCase.call(
      ProfileUpdateImageParams(
        imageFile: event.imageFile,
      ),
    );

    result.fold(
      (l) => emit(ProfileUpdateImageFailureState(l.message)),
      (r) => emit(ProfileUpdateImageSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ProfileUpdateImageBloc =====");
    return super.close();
  }
}
