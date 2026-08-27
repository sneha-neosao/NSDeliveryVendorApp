import 'dart:convert';

/// Represents the response model for the forgot password API.
class ForgotPasswordResponse {
  final int? status;
  final String? message;
  final dynamic data;

  ForgotPasswordResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ForgotPasswordResponse.fromRawJson(String str) =>
      ForgotPasswordResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'],
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data,
      };
}
