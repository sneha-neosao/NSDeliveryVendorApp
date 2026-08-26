import 'dart:convert';

/// Represents the API response for login.
class LoginResponse {
  int? status;
  String? message;
  LoginResult? data;

  LoginResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromRawJson(String str) =>
      LoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] != null ? LoginResult.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (status != null) map['status'] = status;
    if (message != null) map['message'] = message;
    if (data != null) map['data'] = data?.toJson();
    return map;
  }
}

/// Represents the login result containing tokens and restaurant details.
class LoginResult {
  String? accessToken;
  String? refreshToken;
  String? tokenType;
  Restaurant? restaurant;

  LoginResult({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.restaurant,
  });

  factory LoginResult.fromRawJson(String str) =>
      LoginResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
    accessToken: json["access_token"] ?? "",
    refreshToken: json["refresh_token"] ?? "",
    tokenType: json["token_type"] ?? "",
    restaurant: json["restaurant"] != null
        ? Restaurant.fromJson(json["restaurant"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "token_type": tokenType,
    "restaurant": restaurant?.toJson(),
  };
}

/// Represents the restaurant details.
class Restaurant {
  int? id;
  String? uuId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? entityName;
  String? email;
  bool? isActive;

  Restaurant({
    required this.id,
    required this.uuId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.entityName,
    required this.email,
    required this.isActive,
  });

  factory Restaurant.fromRawJson(String str) =>
      Restaurant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    uuId: json["uu_id"] ?? "",
    firstName: json["first_name"] ?? "",
    middleName: json["middle_name"],
    lastName: json["last_name"] ?? "",
    entityName: json["entity_name"] ?? "",
    email: json["email"] ?? "",
    isActive: json["is_active"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uu_id": uuId,
    "first_name": firstName,
    "middle_name": middleName,
    "last_name": lastName,
    "entity_name": entityName,
    "email": email,
    "is_active": isActive,
  };
}
