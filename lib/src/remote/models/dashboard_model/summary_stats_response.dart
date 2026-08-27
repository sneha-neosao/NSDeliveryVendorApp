import 'dart:convert';

/// Represents the response model for the Dashboard Summary Stats API.
class SummaryStatsResponse {
  final int? status;
  final String? message;
  final SummaryStatsData? data;

  SummaryStatsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory SummaryStatsResponse.fromRawJson(String str) =>
      SummaryStatsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SummaryStatsResponse.fromJson(Map<String, dynamic> json) =>
      SummaryStatsResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] != null
            ? SummaryStatsData.fromJson(json['data'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class SummaryStatsData {
  final int? liveActiveOrders;
  final int? totalMenuItems;
  final num? partnerRating;

  SummaryStatsData({
    this.liveActiveOrders,
    this.totalMenuItems,
    this.partnerRating,
  });

  factory SummaryStatsData.fromRawJson(String str) =>
      SummaryStatsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SummaryStatsData.fromJson(Map<String, dynamic> json) =>
      SummaryStatsData(
        liveActiveOrders: (json['live_active_orders'] as num?)?.toInt(),
        totalMenuItems: (json['total_menu_items'] as num?)?.toInt(),
        partnerRating: json['partner_rating'] as num?,
      );

  Map<String, dynamic> toJson() => {
        'live_active_orders': liveActiveOrders,
        'total_menu_items': totalMenuItems,
        'partner_rating': partnerRating,
      };
}
