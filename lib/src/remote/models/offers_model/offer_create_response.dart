import 'dart:convert';
import 'offers_list_response.dart';

/// Represents the response model for the Offer Create API (/offers/create).
class OfferCreateResponse {
  final int? status;
  final String? message;
  final OfferItem? data;

  OfferCreateResponse({
    this.status,
    this.message,
    this.data,
  });

  factory OfferCreateResponse.fromRawJson(String str) =>
      OfferCreateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OfferCreateResponse.fromJson(Map<String, dynamic> json) =>
      OfferCreateResponse(
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
