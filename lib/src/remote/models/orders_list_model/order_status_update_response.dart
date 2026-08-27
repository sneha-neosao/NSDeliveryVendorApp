import 'dart:convert';

/// Represents the response model for the Order Status Update API.
class OrderStatusUpdateResponse {
  final int? status;
  final String? message;
  final dynamic data;

  OrderStatusUpdateResponse({
    this.status,
    this.message,
    this.data,
  });

  factory OrderStatusUpdateResponse.fromRawJson(String str) =>
      OrderStatusUpdateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderStatusUpdateResponse.fromJson(Map<String, dynamic> json) =>
      OrderStatusUpdateResponse(
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
