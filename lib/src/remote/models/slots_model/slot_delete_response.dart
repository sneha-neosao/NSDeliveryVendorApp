import 'dart:convert';
import 'slots_list_response.dart';

/// Represents the response model for the delete slot API.
class SlotDeleteResponse {
  final int? status;
  final String? message;
  final SlotItem? data;

  SlotDeleteResponse({
    this.status,
    this.message,
    this.data,
  });

  factory SlotDeleteResponse.fromRawJson(String str) =>
      SlotDeleteResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SlotDeleteResponse.fromJson(Map<String, dynamic> json) =>
      SlotDeleteResponse(
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
