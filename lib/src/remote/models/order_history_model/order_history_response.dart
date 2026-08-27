class OrderHistoryResponse {
  final int? status;
  final String? message;
  final List<OrderHistoryItem>? data;
  final OrderHistoryPagination? pagination;

  OrderHistoryResponse({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    return OrderHistoryResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
              .map((e) => OrderHistoryItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      pagination: json['pagination'] != null
          ? OrderHistoryPagination.fromJson(
              json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }
}

class OrderHistoryItem {
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
  final OrderHistoryVendor? vendor;

  OrderHistoryItem({
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

  factory OrderHistoryItem.fromJson(Map<String, dynamic> json) {
    return OrderHistoryItem(
      id: (json['id'] as num?)?.toInt(),
      uuId: json['uu_id'] as String?,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      couponCode: json['coupon_code'] as String?,
      couponDiscount: (json['coupon_discount'] as num?)?.toDouble() ?? 0.0,
      walletPointsUsed: (json['wallet_points_used'] as num?)?.toDouble() ?? 0.0,
      walletDiscountAmount:
          (json['wallet_discount_amount'] as num?)?.toDouble() ?? 0.0,
      discountedTotal: (json['discounted_total'] as num?)?.toDouble() ?? 0.0,
      deliveryDistanceKm:
          (json['delivery_distance_km'] as num?)?.toDouble() ?? 0.0,
      deliveryCharge: (json['delivery_charge'] as num?)?.toDouble() ?? 0.0,
      packingCharge: (json['packing_charge'] as num?)?.toDouble() ?? 0.0,
      platformCharges: (json['platform_charges'] as num?)?.toDouble() ?? 0.0,
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
          ? OrderHistoryVendor.fromJson(json['vendor'] as Map<String, dynamic>)
          : null,
    );
  }
}

class OrderHistoryVendor {
  final int? id;
  final String? uuId;
  final String? entityName;
  final String? entityImage;

  OrderHistoryVendor({
    this.id,
    this.uuId,
    this.entityName,
    this.entityImage,
  });

  factory OrderHistoryVendor.fromJson(Map<String, dynamic> json) {
    return OrderHistoryVendor(
      id: (json['id'] as num?)?.toInt(),
      uuId: json['uu_id'] as String?,
      entityName: json['entity_name'] as String?,
      entityImage: json['entity_image'] as String?,
    );
  }
}

class OrderHistoryPagination {
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? totalPages;

  OrderHistoryPagination({
    this.total,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  factory OrderHistoryPagination.fromJson(Map<String, dynamic> json) {
    return OrderHistoryPagination(
      total: (json['total'] as num?)?.toInt(),
      perPage: (json['per_page'] as num?)?.toInt(),
      currentPage: (json['current_page'] as num?)?.toInt(),
      totalPages: (json['total_pages'] as num?)?.toInt(),
    );
  }
}
