import 'dart:convert';

/// Represents the response model for the Dashboard Revenue Analytics API.
class RevenueAnalyticsResponse {
  final int? status;
  final String? message;
  final RevenueAnalyticsData? data;

  RevenueAnalyticsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory RevenueAnalyticsResponse.fromRawJson(String str) =>
      RevenueAnalyticsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RevenueAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      RevenueAnalyticsResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] != null
            ? RevenueAnalyticsData.fromJson(json['data'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class RevenueAnalyticsData {
  final num? todaySales;
  final List<WeeklyEarningItem> weeklyEarnings;
  final int? totalOrders;
  final int? completedOrders;
  final int? rejectedOrders;

  RevenueAnalyticsData({
    this.todaySales,
    this.weeklyEarnings = const [],
    this.totalOrders,
    this.completedOrders,
    this.rejectedOrders,
  });

  factory RevenueAnalyticsData.fromRawJson(String str) =>
      RevenueAnalyticsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RevenueAnalyticsData.fromJson(Map<String, dynamic> json) {
    var rawEarnings = json['weekly_earnings'];
    List<WeeklyEarningItem> parsedEarnings = [];
    if (rawEarnings is List) {
      parsedEarnings = rawEarnings
          .whereType<Map<String, dynamic>>()
          .map((item) => WeeklyEarningItem.fromJson(item))
          .toList();
    }

    return RevenueAnalyticsData(
      todaySales: json['today_sales'] as num?,
      weeklyEarnings: parsedEarnings,
      totalOrders: (json['total_orders'] as num?)?.toInt(),
      completedOrders: (json['completed_orders'] as num?)?.toInt(),
      rejectedOrders: (json['rejected_orders'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'today_sales': todaySales,
        'weekly_earnings': weeklyEarnings.map((x) => x.toJson()).toList(),
        'total_orders': totalOrders,
        'completed_orders': completedOrders,
        'rejected_orders': rejectedOrders,
      };
}

class WeeklyEarningItem {
  final String? day;
  final String? date;
  final num? totalSales;

  WeeklyEarningItem({
    this.day,
    this.date,
    this.totalSales,
  });

  factory WeeklyEarningItem.fromRawJson(String str) =>
      WeeklyEarningItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeeklyEarningItem.fromJson(Map<String, dynamic> json) =>
      WeeklyEarningItem(
        day: json['day']?.toString(),
        date: json['date']?.toString(),
        totalSales: json['total_sales'] as num?,
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        'date': date,
        'total_sales': totalSales,
      };
}
