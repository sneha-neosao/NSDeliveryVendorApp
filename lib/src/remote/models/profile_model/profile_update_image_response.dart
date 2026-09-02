import 'dart:convert';
import 'profile_response.dart';

/// Represents the response model for the Restaurant Profile Update Image API.
class ProfileUpdateImageResponse {
  final int? status;
  final String? message;
  final ProfileData? data;

  ProfileUpdateImageResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ProfileUpdateImageResponse.fromRawJson(String str) =>
      ProfileUpdateImageResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileUpdateImageResponse.fromJson(Map<String, dynamic> json) =>
      ProfileUpdateImageResponse(
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
