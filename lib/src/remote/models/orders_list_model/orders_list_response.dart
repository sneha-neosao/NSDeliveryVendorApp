import 'dart:convert';

/// Represents the top-level API response for the ongoing orders list.
class OrdersListResponse {
  final int? status;
  final String? message;
  final List<OrdersListItem>? data;
  final OrdersListPagination? pagination;

  OrdersListResponse({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  factory OrdersListResponse.fromRawJson(String str) =>
      OrdersListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrdersListResponse.fromJson(Map<String, dynamic> json) =>
      OrdersListResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] != null && json['data'] is List
            ? List<OrdersListItem>.from(
                (json['data'] as List).map(
                  (x) => OrdersListItem.fromJson(x as Map<String, dynamic>),
                ),
              )
            : [],
        pagination: json['pagination'] != null
            ? OrdersListPagination.fromJson(
                json['pagination'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data != null
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : [],
        'pagination': pagination?.toJson(),
      };
}

/// Represents a single ongoing order item.
class OrdersListItem {
  final int? id;
  final String? uuId;
  final double? totalAmount;
  final String? couponCode;
  final double? couponDiscount;
  final double? walletPointsUsed;
  final double? walletDiscountAmount;
  final double? discountedTotal;
  final double? deliveryDistanceKm;
  final double? deliveryCharge;
  final double? packingCharge;
  final double? platformCharges;
  final double? deliveryBoyCommission;
  final String? deliverySeason;
  final double? grandTotal;
  final int? totalItems;
  final String? paymentMode;
  final String? paymentStatus;
  final String? orderStatus;
  final String? createdAt;
  final String? deliveryDate;
  final String? deliveredAt;
  final String? customerName;
  final String? customerEmail;
  final String? customerContact;
  final OrdersListVendor? vendor;

  OrdersListItem({
    this.id,
    this.uuId,
    this.totalAmount,
    this.couponCode,
    this.couponDiscount,
    this.walletPointsUsed,
    this.walletDiscountAmount,
    this.discountedTotal,
    this.deliveryDistanceKm,
    this.deliveryCharge,
    this.packingCharge,
    this.platformCharges,
    this.deliveryBoyCommission,
    this.deliverySeason,
    this.grandTotal,
    this.totalItems,
    this.paymentMode,
    this.paymentStatus,
    this.orderStatus,
    this.createdAt,
    this.deliveryDate,
    this.deliveredAt,
    this.customerName,
    this.customerEmail,
    this.customerContact,
    this.vendor,
  });

  factory OrdersListItem.fromJson(Map<String, dynamic> json) => OrdersListItem(
        id: (json['id'] as num?)?.toInt(),
        uuId: json['uu_id'] as String?,
        totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
        couponCode: json['coupon_code'] as String?,
        couponDiscount: (json['coupon_discount'] as num?)?.toDouble() ?? 0.0,
        walletPointsUsed:
            (json['wallet_points_used'] as num?)?.toDouble() ?? 0.0,
        walletDiscountAmount:
            (json['wallet_discount_amount'] as num?)?.toDouble() ?? 0.0,
        discountedTotal:
            (json['discounted_total'] as num?)?.toDouble() ?? 0.0,
        deliveryDistanceKm:
            (json['delivery_distance_km'] as num?)?.toDouble() ?? 0.0,
        deliveryCharge:
            (json['delivery_charge'] as num?)?.toDouble() ?? 0.0,
        packingCharge:
            (json['packing_charge'] as num?)?.toDouble() ?? 0.0,
        platformCharges:
            (json['platform_charges'] as num?)?.toDouble() ?? 0.0,
        deliveryBoyCommission:
            (json['delivery_boy_commission'] as num?)?.toDouble() ?? 0.0,
        deliverySeason: json['delivery_season'] as String?,
        grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0.0,
        totalItems: (json['total_items'] as num?)?.toInt() ?? 0,
        paymentMode: json['payment_mode'] as String?,
        paymentStatus: json['payment_status'] as String?,
        orderStatus: json['order_status'] as String?,
        createdAt: json['created_at'] as String?,
        deliveryDate: json['delivery_date'] as String?,
        deliveredAt: json['delivered_at'] as String?,
        customerName: json['customer_name'] as String?,
        customerEmail: json['customer_email'] as String?,
        customerContact: json['customer_contact'] as String?,
        vendor: json['vendor'] != null
            ? OrdersListVendor.fromJson(
                json['vendor'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uu_id': uuId,
        'total_amount': totalAmount,
        'coupon_code': couponCode,
        'coupon_discount': couponDiscount,
        'wallet_points_used': walletPointsUsed,
        'wallet_discount_amount': walletDiscountAmount,
        'discounted_total': discountedTotal,
        'delivery_distance_km': deliveryDistanceKm,
        'delivery_charge': deliveryCharge,
        'packing_charge': packingCharge,
        'platform_charges': platformCharges,
        'delivery_boy_commission': deliveryBoyCommission,
        'delivery_season': deliverySeason,
        'grand_total': grandTotal,
        'total_items': totalItems,
        'payment_mode': paymentMode,
        'payment_status': paymentStatus,
        'order_status': orderStatus,
        'created_at': createdAt,
        'delivery_date': deliveryDate,
        'delivered_at': deliveredAt,
        'customer_name': customerName,
        'customer_email': customerEmail,
        'customer_contact': customerContact,
        'vendor': vendor?.toJson(),
      };
}

/// Represents vendor details within an order.
class OrdersListVendor {
  final int? id;
  final String? uuId;
  final String? entityName;
  final String? entityImage;

  OrdersListVendor({
    this.id,
    this.uuId,
    this.entityName,
    this.entityImage,
  });

  factory OrdersListVendor.fromJson(Map<String, dynamic> json) =>
      OrdersListVendor(
        id: (json['id'] as num?)?.toInt(),
        uuId: json['uu_id'] as String?,
        entityName: json['entity_name'] as String?,
        entityImage: json['entity_image'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uu_id': uuId,
        'entity_name': entityName,
        'entity_image': entityImage,
      };
}

/// Represents pagination metadata.
class OrdersListPagination {
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? totalPages;

  OrdersListPagination({
    this.total,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  factory OrdersListPagination.fromJson(Map<String, dynamic> json) =>
      OrdersListPagination(
        total: (json['total'] as num?)?.toInt() ?? 0,
        perPage: (json['per_page'] as num?)?.toInt() ?? 0,
        currentPage: (json['current_page'] as num?)?.toInt() ?? 0,
        totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'per_page': perPage,
        'current_page': currentPage,
        'total_pages': totalPages,
      };
}
