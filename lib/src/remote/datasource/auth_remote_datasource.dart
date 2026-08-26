import 'package:dio/dio.dart';
import 'package:nsdelivery_vendor_app/src/core/api/api_exception.dart';
import 'package:nsdelivery_vendor_app/src/core/errors/exceptions.dart';
import 'package:nsdelivery_vendor_app/src/features/login/presentation/domain/login_usecase.dart';
import 'package:nsdelivery_vendor_app/src/remote/models/auth_model/login_response.dart';
import 'package:nsdelivery_vendor_app/src/remote/models/common_response.dart';
import '../../configs/injector/injector.dart';
import '../../core/constants/error_message.dart';
import '../../core/utils/logger.dart';

sealed class RemoteDataSource {

  /// Authentication
  Future<LoginResponse> login(LoginParams params);

  Future<CommonResponse> logout(String token, String refreshToken);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiHelper _helper;

  /// Helper for normal API requests
  // final ApiHelper _superAdminHelper; /// Helper for super-admin or special API requests

  RemoteDataSourceImpl(this._helper);

  @override
  Future<LoginResponse> login(LoginParams params) async {
    try {
      var data = {"email": params.email, "password": params.password};

      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.login,
        data: data,
      );

      final respData = LoginResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
    }
  }

  @override
  Future<CommonResponse> logout(String token, String refreshToken) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.logout,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'refresh-token': refreshToken,
          },
        ),
      );

      final respData = CommonResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
    }
  }

}
