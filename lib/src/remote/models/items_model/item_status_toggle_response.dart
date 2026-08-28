import 'dart:convert';
import 'items_list_response.dart';

/// Represents the response model for the Toggle Item Status API (/items/toggle-status).
class ItemStatusToggleResponse {
  final int? status;
  final String? message;
  final RestaurantItem? data;

  ItemStatusToggleResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ItemStatusToggleResponse.fromRawJson(String str) =>
      ItemStatusToggleResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemStatusToggleResponse.fromJson(Map<String, dynamic> json) =>
      ItemStatusToggleResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] != null
            ? RestaurantItem.fromJson(json['data'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}
