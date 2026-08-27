import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nsdelivery_vendor_app/src/core/errors/exceptions.dart';
import 'package:nsdelivery_vendor_app/src/core/errors/failures.dart';
import 'package:nsdelivery_vendor_app/src/core/session/session_manager.dart';
import 'package:nsdelivery_vendor_app/src/core/usecases/usecase.dart';
import 'package:nsdelivery_vendor_app/src/core/utils/failure_converter.dart';
import 'package:nsdelivery_vendor_app/src/remote/models/auth_model/login_response.dart';
import 'package:nsdelivery_vendor_app/src/remote/models/common_response.dart';

import '../../../../configs/injector/injector.dart';

part 'auth_login_event.dart';
part 'auth_login_state.dart';

/// Handles state management for **Auth Login** and its related entities.
class AuthLoginBloc extends Bloc<AuthEvent, AuthLoginState> {
  final AuthLoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthLoginBloc(
    this._loginUseCase,
    this._logoutUseCase,
  ) : super(AuthLoginInitialState()) {
    on<AuthLoginEvent>(_login);
    on<AuthCheckSignInStatusEvent>(_checkSignInStatus);
    on<AuthLogoutEvent>(_logout);
  }

  /// - **Login:** Handles [AuthLoginEvent] → calls [AuthLoginUseCase]
  Future _login(AuthLoginEvent event, Emitter emit) async {
    emit(AuthLoginLoadingState());

    final result = await _loginUseCase.call(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (l) => emit(AuthLoginFailureState(l.message)),
      (r) => emit(AuthLoginSuccessState(r)),
    );
  }

  /// - **Check Sign-In Status:** Handles [AuthCheckSignInStatusEvent] → checks [SessionManager]
  Future<Either<Failure, LoginResponse>> checkSignInStatus() async {
    try {
      final result = await SessionManager.isLoggedIn();

      if (result == true) {
        final resultData = await SessionManager.getUserSession();
        return Right(resultData!);
      }
      return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
    } on CacheException {
      return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
    }
  }

  Future _checkSignInStatus(
      AuthCheckSignInStatusEvent event, Emitter emit) async {
    emit(AuthCheckSignInStatusLoadingState());

    final result = await checkSignInStatus();
    result.fold(
      (l) => emit(AuthCheckSignInStatusFailureState(mapFailureToMessage(l))),
      (r) => emit(AuthCheckSignInStatusSuccessState(r)),
    );
  }

  /// - **Logout:** Handles [AuthLogoutEvent] → calls [LogoutUseCase] & clears [SessionManager]
  Future _logout(AuthLogoutEvent event, Emitter emit) async {
    emit(AuthLogoutLoadingState());

    final result = await _logoutUseCase.call(NoParams());

    await result.fold(
      (l) async {
        emit(AuthLogoutFailureState(l.message));
      },
      (r) async {
        await SessionManager.clear();
        emit(AuthLogoutSuccessState(r));
      },
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE AuthLoginBloc =====");
    return super.close();
  }
}
