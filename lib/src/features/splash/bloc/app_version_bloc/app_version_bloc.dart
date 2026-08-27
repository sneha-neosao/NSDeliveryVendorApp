import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/app_version_usecase.dart';
import '../../../../remote/models/auth_model/app_version_response.dart';

part 'app_version_event.dart';
part 'app_version_state.dart';

/// Handles state management for **App Version**.
class AppVersionBloc extends Bloc<AppVersionEvent, AppVersionState> {
  final AppVersionUseCase _appVersionUseCase;

  AppVersionBloc(this._appVersionUseCase) : super(AppVersionInitialState()) {
    on<FetchAppVersionEvent>(_fetchAppVersion);
  }

  Future<void> _fetchAppVersion(
    FetchAppVersionEvent event,
    Emitter<AppVersionState> emit,
  ) async {
    emit(AppVersionLoadingState());

    final result = await _appVersionUseCase.call(NoParams());

    result.fold(
      (l) => emit(AppVersionFailureState(l.message)),
      (r) => emit(AppVersionSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE AppVersionBloc =====");
    return super.close();
  }
}
