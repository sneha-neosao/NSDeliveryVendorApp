import 'dart:convert';
import 'slots_list_response.dart';

/// Represents the response model for the update slot API.
class SlotUpdateResponse {
  final int? status;
  final String? message;
  final SlotItem? data;

  SlotUpdateResponse({
    this.status,
    this.message,
    this.data,
  });

  factory SlotUpdateResponse.fromRawJson(String str) =>
      SlotUpdateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SlotUpdateResponse.fromJson(Map<String, dynamic> json) =>
      SlotUpdateResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] != null && json['data'] is Map<String, dynamic>
            ? SlotItem.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}
