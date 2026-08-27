import 'package:dio/dio.dart';
import 'package:nsdelivery_vendor_app/src/core/api/api_exception.dart';
import 'package:nsdelivery_vendor_app/src/core/errors/exceptions.dart';
import '../../configs/injector/injector.dart';
import '../../core/constants/error_message.dart';

sealed class RemoteDataSource {

  /// Authentication
  Future<LoginResponse> login(LoginParams params);

  Future<CommonResponse> logout(String token, String refreshToken);

  Future<ForgotPasswordResponse> ForgotPassword(ForgotPasswordParams params);

  /// Items
  Future<ItemsListResponse> itemsList(String token, ItemsListParams params);

  /// Orders
  Future<OrderHistoryResponse> orderHistory(String token, OrderHistoryParams params);

  Future<OrdersListResponse> OrdersList(String token, OrdersListParams params);

  Future<OrderDetailsResponse> OrderDetails(String token, OrderDetailsParams params);

  Future<ServiceabilityResponse> ServiceabilityUpdate(String token, ServiceabilityUpdateParams params);

  Future<SlotsListResponse> SlotsList(String token, SlotsListParams params);

  Future<SlotCreateResponse> SlotCreate(String token, SlotCreateParams params);

  Future<SlotUpdateResponse> SlotUpdate(String token, SlotUpdateParams params);

  Future<SlotDeleteResponse> SlotDelete(String token, SlotDeleteParams params);
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

  @override
  Future<ForgotPasswordResponse> ForgotPassword(
      ForgotPasswordParams params) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.forgotPassword,
        data: params.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      final respData = ForgotPasswordResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<ItemsListResponse> itemsList(String token, ItemsListParams params) async {
    try {
      final queryParams = <String, String>{
        'page': '${params.page}',
        'limit': '${params.limit}',
      };
      if (params.q != null && params.q!.trim().isNotEmpty) {
        queryParams['q'] = params.q!.trim();
      }
      if (params.status != null && params.status!.trim().isNotEmpty) {
        queryParams['status'] = params.status!.trim();
      }

      final queryString = queryParams.entries
          .map((e) => "${e.key}=${Uri.encodeComponent(e.value)}")
          .join('&');

      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.itemsList}?$queryString",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = ItemsListResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<OrderHistoryResponse> orderHistory(
      String token, OrderHistoryParams params) async {
    try {
      final queryString = 'page=${params.page}&limit=${params.limit}';

      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.orderHistory}?$queryString',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = OrderHistoryResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<OrdersListResponse> OrdersList(
      String token, OrdersListParams params) async {
    try {
      final queryString = 'page=${params.page}&limit=${params.limit}';

      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.ordersList}?$queryString',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = OrdersListResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<OrderDetailsResponse> OrderDetails(
      String token, OrderDetailsParams params) async {
    try {
      final queryString = 'uu_id=${Uri.encodeComponent(params.uuId)}';

      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.orderDetails}?$queryString',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = OrderDetailsResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<ServiceabilityResponse> ServiceabilityUpdate(
      String token, ServiceabilityUpdateParams params) async {
    try {
      final response = await _helper.execute(
        method: Method.put,
        url: ApiUrl.serviceabilityUpdate,
        data: params.toFormData(),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = ServiceabilityResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<SlotsListResponse> SlotsList(
      String token, SlotsListParams params) async {
    try {
      final queryString = 'page=${params.page}&limit=${params.limit}';

      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.slotsList}?$queryString',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = SlotsListResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<SlotCreateResponse> SlotCreate(
      String token, SlotCreateParams params) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.slotCreate,
        data: params.toFormData(),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = SlotCreateResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<SlotUpdateResponse> SlotUpdate(
      String token, SlotUpdateParams params) async {
    try {
      final url = '${ApiUrl.slotUpdate}?uu_id=${Uri.encodeComponent(params.uuId)}';

      final response = await _helper.execute(
        method: Method.put,
        url: url,
        data: params.toFormData(),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = SlotUpdateResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<SlotDeleteResponse> SlotDelete(
      String token, SlotDeleteParams params) async {
    try {
      final url = '${ApiUrl.slotDelete}?uu_id=${Uri.encodeComponent(params.uuId)}';

      final response = await _helper.execute(
        method: Method.delete,
        url: url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = SlotDeleteResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

}
