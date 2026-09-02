import 'dart:convert';
import 'offers_list_response.dart';

/// Represents the response model for the Offer Status Toggle API (/offers/{uu_id}/status).
class OfferStatusToggleResponse {
  final int? status;
  final String? message;
  final OfferItem? data;

  OfferStatusToggleResponse({
    this.status,
    this.message,
    this.data,
  });

  factory OfferStatusToggleResponse.fromRawJson(String str) =>
      OfferStatusToggleResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OfferStatusToggleResponse.fromJson(Map<String, dynamic> json) =>
      OfferStatusToggleResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] != null ? OfferItem.fromJson(json['data']) : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}
