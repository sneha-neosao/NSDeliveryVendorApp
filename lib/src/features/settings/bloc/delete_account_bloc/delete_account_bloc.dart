import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/delete_account_usecase.dart';
import '../../../../remote/models/auth_model/delete_account_response.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

/// Handles state management for **Delete Account**.
class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final DeleteAccountUseCase _deleteAccountUseCase;

  DeleteAccountBloc(this._deleteAccountUseCase)
      : super(DeleteAccountInitialState()) {
    on<DeleteAccountSubmitEvent>(_deleteAccount);
  }

  Future<void> _deleteAccount(
    DeleteAccountSubmitEvent event,
    Emitter<DeleteAccountState> emit,
  ) async {
    emit(DeleteAccountLoadingState());

    final result = await _deleteAccountUseCase.call(NoParams());

    await result.fold(
      (l) async {
        emit(DeleteAccountFailureState(l.message));
      },
      (r) async {
        // Clear session on successful account deletion
        await SessionManager.clear();
        emit(DeleteAccountSuccessState(r));
      },
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE DeleteAccountBloc =====");
    return super.close();
  }
}
