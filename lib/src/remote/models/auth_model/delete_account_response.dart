import 'dart:convert';

/// Represents the response model for the Delete Account API (/auth/delete-account).
class DeleteAccountResponse {
  final int? status;
  final String? message;
  final dynamic data;

  DeleteAccountResponse({
    this.status,
    this.message,
    this.data,
  });

  factory DeleteAccountResponse.fromRawJson(String str) =>
      DeleteAccountResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) =>
      DeleteAccountResponse(
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
