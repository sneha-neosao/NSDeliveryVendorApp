import 'dart:convert';

/// Represents the response model for the Offers List API (/offers/list).
class OffersListResponse {
  final int? status;
  final String? message;
  final List<OfferItem> data;
  final OffersPagination? pagination;

  OffersListResponse({
    this.status,
    this.message,
    this.data = const [],
    this.pagination,
  });

  factory OffersListResponse.fromRawJson(String str) =>
      OffersListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OffersListResponse.fromJson(Map<String, dynamic> json) =>
      OffersListResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] == null
            ? []
            : List<OfferItem>.from(
                (json['data'] as List).map((x) => OfferItem.fromJson(x))),
        pagination: json['pagination'] != null
            ? OffersPagination.fromJson(json['pagination'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
        'pagination': pagination?.toJson(),
      };
}

class OfferItem {
  final int? id;
  final String? uuId;
  final int? vendorId;
  final String? couponCode;
  final String? title;
  final String? couponType;
  final double? discValue;
  final double? capLimit;
  final double? orderValue;
  final int? perUserLimit;
  final String? termsCondition;
  final String? couponDescription;
  final int? useLimit;
  final String? startDate;
  final String? expiryDate;
  final bool? isActive;
  final String? createdAt;
  final OfferVendor? vendor;
  final int? totalUsed;
  final int? remainingUses;

  OfferItem({
    this.id,
    this.uuId,
    this.vendorId,
    this.couponCode,
    this.title,
    this.couponType,
    this.discValue,
    this.capLimit,
    this.orderValue,
    this.perUserLimit,
    this.termsCondition,
    this.couponDescription,
    this.useLimit,
    this.startDate,
    this.expiryDate,
    this.isActive,
    this.createdAt,
    this.vendor,
    this.totalUsed,
    this.remainingUses,
  });

  factory OfferItem.fromJson(Map<String, dynamic> json) => OfferItem(
        id: (json['id'] as num?)?.toInt(),
        uuId: json['uu_id']?.toString() ?? '',
        vendorId: (json['vendor_id'] as num?)?.toInt(),
        couponCode: json['coupon_code']?.toString() ?? '',
        title: json['title']?.toString(),
        couponType: json['coupon_type']?.toString() ?? '',
        discValue: (json['disc_value'] as num?)?.toDouble() ?? 0.0,
        capLimit: (json['cap_limit'] as num?)?.toDouble() ?? 0.0,
        orderValue: (json['order_value'] as num?)?.toDouble() ?? 0.0,
        perUserLimit: (json['per_user_limit'] as num?)?.toInt() ?? 0,
        termsCondition: json['termscondition']?.toString() ?? '',
        couponDescription: json['coupon_description']?.toString() ?? '',
        useLimit: (json['use_limit'] as num?)?.toInt() ?? 0,
        startDate: json['start_date']?.toString(),
        expiryDate: json['expiry_date']?.toString() ?? '',
        isActive: json['is_active'] as bool? ?? false,
        createdAt: json['created_at']?.toString() ?? '',
        vendor: json['vendor'] != null
            ? OfferVendor.fromJson(json['vendor'])
            : null,
        totalUsed: (json['total_used'] as num?)?.toInt() ?? 0,
        remainingUses: (json['remaining_uses'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uu_id': uuId,
        'vendor_id': vendorId,
        'coupon_code': couponCode,
        'title': title,
        'coupon_type': couponType,
        'disc_value': discValue,
        'cap_limit': capLimit,
        'order_value': orderValue,
        'per_user_limit': perUserLimit,
        'termscondition': termsCondition,
        'coupon_description': couponDescription,
        'use_limit': useLimit,
        'start_date': startDate,
        'expiry_date': expiryDate,
        'is_active': isActive,
        'created_at': createdAt,
        'vendor': vendor?.toJson(),
        'total_used': totalUsed,
        'remaining_uses': remainingUses,
      };
}

class OfferVendor {
  final int? id;
  final String? entityName;

  OfferVendor({
    this.id,
    this.entityName,
  });

  factory OfferVendor.fromJson(Map<String, dynamic> json) => OfferVendor(
        id: (json['id'] as num?)?.toInt(),
        entityName: json['entity_name']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'entity_name': entityName,
      };
}

class OffersPagination {
  final int? total;
  final int? page;
  final int? limit;
  final int? totalPages;
  final bool? hasNext;
  final bool? hasPrev;

  OffersPagination({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
    this.hasNext,
    this.hasPrev,
  });

  factory OffersPagination.fromJson(Map<String, dynamic> json) =>
      OffersPagination(
        total: (json['total'] as num?)?.toInt(),
        page: (json['page'] as num?)?.toInt(),
        limit: (json['limit'] as num?)?.toInt(),
        totalPages: (json['total_pages'] as num?)?.toInt(),
        hasNext: json['has_next'] as bool?,
        hasPrev: json['has_prev'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'page': page,
        'limit': limit,
        'total_pages': totalPages,
        'has_next': hasNext,
        'has_prev': hasPrev,
      };
}
