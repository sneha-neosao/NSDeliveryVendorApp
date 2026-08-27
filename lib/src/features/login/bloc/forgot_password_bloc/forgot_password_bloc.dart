import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/forgot_password_usecase.dart';
import '../../../../remote/models/auth_model/forgot_password_response.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

/// Handles state management for **Forgot Password** and its related operations.
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordBloc(this._forgotPasswordUseCase)
      : super(ForgotPasswordInitialState()) {
    on<SubmitForgotPasswordEvent>(_submitForgotPassword);
  }

  Future<void> _submitForgotPassword(
    SubmitForgotPasswordEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoadingState());

    final result = await _forgotPasswordUseCase.call(
      ForgotPasswordParams(
        email: event.email,
      ),
    );

    result.fold(
      (l) => emit(ForgotPasswordFailureState(l.message)),
      (r) => emit(ForgotPasswordSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ForgotPasswordBloc =====");
    return super.close();
  }
}
