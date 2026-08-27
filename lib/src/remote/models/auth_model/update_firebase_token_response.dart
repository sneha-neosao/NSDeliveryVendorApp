import 'dart:convert';

/// Represents the response model for the Update Firebase Token API (/auth/update-firebase-token).
class UpdateFirebaseTokenResponse {
  final int? status;
  final String? message;
  final FirebaseTokenData? data;

  UpdateFirebaseTokenResponse({
    this.status,
    this.message,
    this.data,
  });

  factory UpdateFirebaseTokenResponse.fromRawJson(String str) =>
      UpdateFirebaseTokenResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateFirebaseTokenResponse.fromJson(Map<String, dynamic> json) =>
      UpdateFirebaseTokenResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] != null
            ? FirebaseTokenData.fromJson(json['data'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class FirebaseTokenData {
  final String? firebaseToken;

  FirebaseTokenData({
    this.firebaseToken,
  });

  factory FirebaseTokenData.fromJson(Map<String, dynamic> json) =>
      FirebaseTokenData(
        firebaseToken: json['firebase_token']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'firebase_token': firebaseToken,
      };
}
