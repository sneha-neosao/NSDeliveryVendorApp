import 'dart:convert';
import 'slots_list_response.dart';

/// Represents the response model for the create slot API.
class SlotCreateResponse {
  final int? status;
  final String? message;
  final SlotItem? data;

  SlotCreateResponse({
    this.status,
    this.message,
    this.data,
  });

  factory SlotCreateResponse.fromRawJson(String str) =>
      SlotCreateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SlotCreateResponse.fromJson(Map<String, dynamic> json) =>
      SlotCreateResponse(
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
