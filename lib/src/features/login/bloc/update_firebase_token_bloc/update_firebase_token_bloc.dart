import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/update_firebase_token_usecase.dart';
import '../../../../remote/models/auth_model/update_firebase_token_response.dart';

part 'update_firebase_token_event.dart';
part 'update_firebase_token_state.dart';

/// Handles state management for **Update Firebase Token**.
class UpdateFirebaseTokenBloc
    extends Bloc<UpdateFirebaseTokenEvent, UpdateFirebaseTokenState> {
  final UpdateFirebaseTokenUseCase _updateFirebaseTokenUseCase;

  UpdateFirebaseTokenBloc(this._updateFirebaseTokenUseCase)
      : super(UpdateFirebaseTokenInitialState()) {
    on<UpdateFirebaseTokenSubmitEvent>(_updateFirebaseToken);
  }

  Future<void> _updateFirebaseToken(
    UpdateFirebaseTokenSubmitEvent event,
    Emitter<UpdateFirebaseTokenState> emit,
  ) async {
    emit(UpdateFirebaseTokenLoadingState());

    final result = await _updateFirebaseTokenUseCase.call(
      UpdateFirebaseTokenParams(firebaseToken: event.firebaseToken),
    );

    result.fold(
      (l) => emit(UpdateFirebaseTokenFailureState(l.message)),
      (r) => emit(UpdateFirebaseTokenSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE UpdateFirebaseTokenBloc =====");
    return super.close();
  }
}
