import 'package:fpdart/fpdart.dart';
import 'package:nsdelivery_vendor_app/src/core/api/api_exception.dart';
import 'package:nsdelivery_vendor_app/src/core/errors/exceptions.dart';
import 'package:nsdelivery_vendor_app/src/core/errors/failures.dart';
import 'package:nsdelivery_vendor_app/src/core/session/session_manager.dart';
import 'package:nsdelivery_vendor_app/src/core/usecases/usecase.dart';
import 'package:nsdelivery_vendor_app/src/core/utils/failure_converter.dart';
import '../../configs/injector/injector.dart';

/// Abstract Repository interface defining all data operations for the app

abstract class Repository {

  /// Authentication
  Future<Either<Failure, LoginResponse>> login(LoginParams params);

  Future<Either<Failure, CommonResponse>> logout(NoParams params);

  Future<Either<Failure, ForgotPasswordResponse>> forgot_password(ForgotPasswordParams params);

  Future<Either<Failure, UpdateFirebaseTokenResponse>> update_firebase_token(UpdateFirebaseTokenParams params);

  Future<Either<Failure, DeleteAccountResponse>> delete_account(NoParams params);

  Future<Either<Failure, AppVersionResponse>> app_version(NoParams params);

  /// Items
  Future<Either<Failure, ItemsListResponse>> items_list(ItemsListParams params);

  Future<Either<Failure, ItemStatusToggleResponse>> item_status_toggle(ItemStatusToggleParams params);

  /// Orders
  Future<Either<Failure, OrderHistoryResponse>> order_history(OrderHistoryParams params);

  Future<Either<Failure, OrdersListResponse>> orders_list(OrdersListParams params);

  Future<Either<Failure, OrderDetailsResponse>> order_details(OrderDetailsParams params);

  Future<Either<Failure, OrderStatusUpdateResponse>> order_update_status(OrderUpdateStatusParams params);

  /// Dashboard / Serviceability
  Future<Either<Failure, ServiceabilityResponse>> serviceability_update(ServiceabilityUpdateParams params);

  Future<Either<Failure, SummaryStatsResponse>> dashboard_summary_stats(NoParams params);

  Future<Either<Failure, PerformanceMetricsResponse>> dashboard_performance_metrics(NoParams params);

  /// Offers
  Future<Either<Failure, OffersListResponse>> offers_list(OffersListParams params);

  /// Settings / Time Slots
  Future<Either<Failure, SlotsListResponse>> slots_list(SlotsListParams params);

  Future<Either<Failure, SlotCreateResponse>> slot_create(SlotCreateParams params);

  Future<Either<Failure, SlotUpdateResponse>> slot_update(SlotUpdateParams params);

  Future<Either<Failure, SlotDeleteResponse>> slot_delete(SlotDeleteParams params);

  /// Profile
  Future<Either<Failure, ProfileResponse>> profile_list(NoParams params);

  Future<Either<Failure, ProfileUpdateResponse>> profile_update(ProfileUpdateParams params);
}

class AuthRepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const AuthRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, LoginResponse>> login(LoginParams params) {
    return _networkInfo.check<LoginResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.login(params);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
          }

          // Save login status & full session object
          await SessionManager.saveLoginStatus(true);
          await SessionManager.saveUserSession(respData);
          await SessionManager.saveSessionId(respData.data?.accessToken);

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, CommonResponse>> logout(NoParams params) {
    return _networkInfo.check<CommonResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          String refreshToken = await SessionManager.getRefreshToken() ?? "";

          final respData = await _remoteDataSource.logout(token, refreshToken);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message));
          }

          // Save full session object
          // await SessionManager.saveUserSession(respData);
          //
          // // Save tokens to their dedicated keys so ApiInterceptor can read them
          // if (respData.data?.accessToken != null) {
          //   await SessionManager.saveSessionId(respData.data?.accessToken);
          // }
          // if (respData.data?.refreshToken != null) {
          //   await SessionManager.saveRefreshToken(respData.data?.accessToken);
          // }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, ForgotPasswordResponse>> forgot_password(
      ForgotPasswordParams params) {
    return _networkInfo.check<ForgotPasswordResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.ForgotPassword(params);

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, ItemsListResponse>> items_list(ItemsListParams params) {
    return _networkInfo.check<ItemsListResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.itemsList(token,params);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, OrderHistoryResponse>> order_history(OrderHistoryParams params) {
    return _networkInfo.check<OrderHistoryResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.orderHistory(token, params);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, OrdersListResponse>> orders_list(OrdersListParams params) {
    return _networkInfo.check<OrdersListResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.OrdersList(token, params);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, OrderDetailsResponse>> order_details(OrderDetailsParams params) {
    return _networkInfo.check<OrderDetailsResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.OrderDetails(token, params);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, OrderStatusUpdateResponse>> order_update_status(
      OrderUpdateStatusParams params) {
    return _networkInfo.check<OrderStatusUpdateResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData =
              await _remoteDataSource.OrderUpdateStatus(token, params);

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, ServiceabilityResponse>> serviceability_update(
      ServiceabilityUpdateParams params) {
    return _networkInfo.check<ServiceabilityResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData =
              await _remoteDataSource.ServiceabilityUpdate(token, params);

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, SlotsListResponse>> slots_list(
      SlotsListParams params) {
    return _networkInfo.check<SlotsListResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.SlotsList(token, params);

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, SlotCreateResponse>> slot_create(
      SlotCreateParams params) {
    return _networkInfo.check<SlotCreateResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.SlotCreate(token, params);

          if (respData.status != 201 && respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, SlotUpdateResponse>> slot_update(
      SlotUpdateParams params) {
    return _networkInfo.check<SlotUpdateResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.SlotUpdate(token, params);

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, SlotDeleteResponse>> slot_delete(
      SlotDeleteParams params) {
    return _networkInfo.check<SlotDeleteResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.SlotDelete(token, params);

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, ProfileResponse>> profile_list(NoParams params) {
    return _networkInfo.check<ProfileResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.ProfileList(token);

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, ProfileUpdateResponse>> profile_update(
      ProfileUpdateParams params) {
    return _networkInfo.check<ProfileUpdateResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData =
              await _remoteDataSource.ProfileUpdate(token, params);

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, SummaryStatsResponse>> dashboard_summary_stats(
      NoParams params) {
    return _networkInfo.check<SummaryStatsResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData =
              await _remoteDataSource.DashboardSummaryStats(token);

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, PerformanceMetricsResponse>>
      dashboard_performance_metrics(NoParams params) {
    return _networkInfo.check<PerformanceMetricsResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData =
              await _remoteDataSource.DashboardPerformanceMetrics(token);

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, OffersListResponse>> offers_list(
      OffersListParams params) {
    return _networkInfo.check<OffersListResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.OffersList(token, params);

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, UpdateFirebaseTokenResponse>> update_firebase_token(
      UpdateFirebaseTokenParams params) {
    return _networkInfo.check<UpdateFirebaseTokenResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData =
              await _remoteDataSource.UpdateFirebaseToken(token, params);

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, DeleteAccountResponse>> delete_account(
      NoParams params) {
    return _networkInfo.check<DeleteAccountResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.DeleteAccount(token);

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, AppVersionResponse>> app_version(NoParams params) {
    return _networkInfo.check<AppVersionResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.AppVersion();

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, ItemStatusToggleResponse>> item_status_toggle(
      ItemStatusToggleParams params) {
    return _networkInfo.check<ItemStatusToggleResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData =
              await _remoteDataSource.ItemStatusToggle(token, params);

          if (respData.status != 200) {
            return Left(
                CredentialFailure(respData.message ?? "Something went wrong"));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(
              InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }
}
