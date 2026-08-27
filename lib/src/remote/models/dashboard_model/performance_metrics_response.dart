import 'dart:convert';

/// Represents the response model for Performance Metrics & Top Products API.
class PerformanceMetricsResponse {
  final int? status;
  final String? message;
  final PerformanceMetricsData? data;

  PerformanceMetricsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory PerformanceMetricsResponse.fromRawJson(String str) =>
      PerformanceMetricsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PerformanceMetricsResponse.fromJson(Map<String, dynamic> json) =>
      PerformanceMetricsResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] != null
            ? PerformanceMetricsData.fromJson(json['data'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class PerformanceMetricsData {
  final OrderPerformance? orderPerformance;
  final List<TopProduct> topProducts;

  PerformanceMetricsData({
    this.orderPerformance,
    this.topProducts = const [],
  });

  factory PerformanceMetricsData.fromRawJson(String str) =>
      PerformanceMetricsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PerformanceMetricsData.fromJson(Map<String, dynamic> json) =>
      PerformanceMetricsData(
        orderPerformance: json['order_performance'] != null
            ? OrderPerformance.fromJson(json['order_performance'])
            : null,
        topProducts: json['top_products'] != null && json['top_products'] is List
            ? (json['top_products'] as List)
                .map((e) => TopProduct.fromJson(e))
                .toList()
            : const [],
      );

  Map<String, dynamic> toJson() => {
        'order_performance': orderPerformance?.toJson(),
        'top_products': topProducts.map((e) => e.toJson()).toList(),
      };
}

class OrderPerformance {
  final int? totalOrders;
  final int? completedOrders;
  final int? rejectedOrders;

  OrderPerformance({
    this.totalOrders,
    this.completedOrders,
    this.rejectedOrders,
  });

  factory OrderPerformance.fromRawJson(String str) =>
      OrderPerformance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderPerformance.fromJson(Map<String, dynamic> json) =>
      OrderPerformance(
        totalOrders: (json['total_orders'] as num?)?.toInt(),
        completedOrders: (json['completed_orders'] as num?)?.toInt(),
        rejectedOrders: (json['rejected_orders'] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => {
        'total_orders': totalOrders,
        'completed_orders': completedOrders,
        'rejected_orders': rejectedOrders,
      };
}

class TopProduct {
  final int? vendorItemId;
  final String? itemName;
  final String? itemImage;
  final int? unitsSold;

  TopProduct({
    this.vendorItemId,
    this.itemName,
    this.itemImage,
    this.unitsSold,
  });

  factory TopProduct.fromRawJson(String str) =>
      TopProduct.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TopProduct.fromJson(Map<String, dynamic> json) => TopProduct(
        vendorItemId: (json['vendor_item_id'] as num?)?.toInt(),
        itemName: json['item_name']?.toString() ?? '',
        itemImage: json['item_image']?.toString(),
        unitsSold: (json['units_sold'] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => {
        'vendor_item_id': vendorItemId,
        'item_name': itemName,
        'item_image': itemImage,
        'units_sold': unitsSold,
      };
}
