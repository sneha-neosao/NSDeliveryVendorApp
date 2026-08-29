import 'dart:convert';
import 'profile_response.dart';

/// Represents the response model for the Restaurant Profile Update API.
class ProfileUpdateResponse {
  final int? status;
  final String? message;
  final ProfileData? data;

  ProfileUpdateResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ProfileUpdateResponse.fromRawJson(String str) =>
      ProfileUpdateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) =>
      ProfileUpdateResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] != null && json['data'] is Map<String, dynamic>
            ? ProfileData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}
