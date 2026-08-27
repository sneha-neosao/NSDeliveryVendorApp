import 'dart:convert';

/// Represents the API response for order details.
class OrderDetailsResponse {
  final int? status;
  final String? message;
  final OrderDetailsData? data;

  OrderDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory OrderDetailsResponse.fromRawJson(String str) =>
      OrderDetailsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) =>
      OrderDetailsResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] != null && json['data'] is Map<String, dynamic>
            ? OrderDetailsData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

/// Represents the data object containing all details for an order.
class OrderDetailsData {
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
  final String? note;
  final String? paymentMode;
  final String? paymentStatus;
  final String? orderStatus;
  final String? createdAt;
  final String? deliveryDate;
  final String? deliveredAt;
  final String? customerName;
  final String? customerEmail;
  final String? customerContact;
  final OrderDeliveryDetails? deliveryDetails;
  final List<OrderItemDetail>? items;
  final List<OrderStatusLog>? statusLogs;
  final AssignedDeliveryBoy? assignedDeliveryBoy;
  final List<dynamic>? walletTransactions;
  final OrderVendor? vendor;
  final double? vendorRating;

  OrderDetailsData({
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
    this.note,
    this.paymentMode,
    this.paymentStatus,
    this.orderStatus,
    this.createdAt,
    this.deliveryDate,
    this.deliveredAt,
    this.customerName,
    this.customerEmail,
    this.customerContact,
    this.deliveryDetails,
    this.items,
    this.statusLogs,
    this.assignedDeliveryBoy,
    this.walletTransactions,
    this.vendor,
    this.vendorRating,
  });

  factory OrderDetailsData.fromJson(Map<String, dynamic> json) =>
      OrderDetailsData(
        id: (json['id'] as num?)?.toInt(),
        uuId: json['uu_id']?.toString() ?? '',
        totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
        couponCode: json['coupon_code']?.toString(),
        couponDiscount: (json['coupon_discount'] as num?)?.toDouble() ?? 0.0,
        walletPointsUsed:
            (json['wallet_points_used'] as num?)?.toDouble() ?? 0.0,
        walletDiscountAmount:
            (json['wallet_discount_amount'] as num?)?.toDouble() ?? 0.0,
        discountedTotal: (json['discounted_total'] as num?)?.toDouble() ?? 0.0,
        deliveryDistanceKm:
            (json['delivery_distance_km'] as num?)?.toDouble() ?? 0.0,
        deliveryCharge: (json['delivery_charge'] as num?)?.toDouble() ?? 0.0,
        packingCharge: (json['packing_charge'] as num?)?.toDouble() ?? 0.0,
        platformCharges:
            (json['platform_charges'] as num?)?.toDouble() ?? 0.0,
        deliveryBoyCommission:
            (json['delivery_boy_commission'] as num?)?.toDouble() ?? 0.0,
        deliverySeason: json['delivery_season']?.toString(),
        grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0.0,
        totalItems: (json['total_items'] as num?)?.toInt() ?? 0,
        note: json['note']?.toString(),
        paymentMode: json['payment_mode']?.toString() ?? '',
        paymentStatus: json['payment_status']?.toString() ?? '',
        orderStatus: json['order_status']?.toString() ?? '',
        createdAt: json['created_at']?.toString() ?? '',
        deliveryDate: json['delivery_date']?.toString() ?? '',
        deliveredAt: json['delivered_at']?.toString() ?? '',
        customerName: json['customer_name']?.toString() ?? '',
        customerEmail: json['customer_email']?.toString() ?? '',
        customerContact: json['customer_contact']?.toString() ?? '',
        deliveryDetails: json['delivery_details'] != null &&
                json['delivery_details'] is Map<String, dynamic>
            ? OrderDeliveryDetails.fromJson(
                json['delivery_details'] as Map<String, dynamic>)
            : null,
        items: json['items'] != null && json['items'] is List
            ? List<OrderItemDetail>.from(
                (json['items'] as List).map(
                  (x) => OrderItemDetail.fromJson(x as Map<String, dynamic>),
                ),
              )
            : [],
        statusLogs: json['status_logs'] != null && json['status_logs'] is List
            ? List<OrderStatusLog>.from(
                (json['status_logs'] as List).map(
                  (x) => OrderStatusLog.fromJson(x as Map<String, dynamic>),
                ),
              )
            : [],
        assignedDeliveryBoy: json['assigned_delivery_boy'] != null &&
                json['assigned_delivery_boy'] is Map<String, dynamic>
            ? AssignedDeliveryBoy.fromJson(
                json['assigned_delivery_boy'] as Map<String, dynamic>)
            : null,
        walletTransactions: json['wallet_transactions'] != null &&
                json['wallet_transactions'] is List
            ? List<dynamic>.from(json['wallet_transactions'] as List)
            : [],
        vendor: json['vendor'] != null &&
                json['vendor'] is Map<String, dynamic>
            ? OrderVendor.fromJson(json['vendor'] as Map<String, dynamic>)
            : null,
        vendorRating: (json['vendor_rating'] as num?)?.toDouble(),
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
        'note': note,
        'payment_mode': paymentMode,
        'payment_status': paymentStatus,
        'order_status': orderStatus,
        'created_at': createdAt,
        'delivery_date': deliveryDate,
        'delivered_at': deliveredAt,
        'customer_name': customerName,
        'customer_email': customerEmail,
        'customer_contact': customerContact,
        'delivery_details': deliveryDetails?.toJson(),
        'items': items != null
            ? List<dynamic>.from(items!.map((x) => x.toJson()))
            : [],
        'status_logs': statusLogs != null
            ? List<dynamic>.from(statusLogs!.map((x) => x.toJson()))
            : [],
        'assigned_delivery_boy': assignedDeliveryBoy?.toJson(),
        'wallet_transactions': walletTransactions,
        'vendor': vendor?.toJson(),
        'vendor_rating': vendorRating,
      };
}

/// Represents the delivery address and contact details of an order.
class OrderDeliveryDetails {
  final String? name;
  final String? phone;
  final String? address;
  final String? pincode;
  final double? lat;
  final double? lng;

  OrderDeliveryDetails({
    this.name,
    this.phone,
    this.address,
    this.pincode,
    this.lat,
    this.lng,
  });

  factory OrderDeliveryDetails.fromJson(Map<String, dynamic> json) =>
      OrderDeliveryDetails(
        name: json['name']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        pincode: json['pincode']?.toString() ?? '',
        lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
        lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'address': address,
        'pincode': pincode,
        'lat': lat,
        'lng': lng,
      };
}

/// Represents an item in the order details.
class OrderItemDetail {
  final int? itemId;
  final String? vendorItemName;
  final String? variantName;
  final int? quantity;
  final double? price;
  final double? totalPrice;
  final int? addonId;
  final dynamic addonData;
  final List<String>? images;
  final double? rating;
  final String? review;

  OrderItemDetail({
    this.itemId,
    this.vendorItemName,
    this.variantName,
    this.quantity,
    this.price,
    this.totalPrice,
    this.addonId,
    this.addonData,
    this.images,
    this.rating,
    this.review,
  });

  factory OrderItemDetail.fromJson(Map<String, dynamic> json) =>
      OrderItemDetail(
        itemId: (json['item_id'] as num?)?.toInt(),
        vendorItemName: json['vendor_item_name']?.toString() ?? '',
        variantName: json['variant_name']?.toString() ?? '',
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
        addonId: (json['addon_id'] as num?)?.toInt(),
        addonData: json['addon_data'],
        images: json['images'] != null && json['images'] is List
            ? List<String>.from(
                (json['images'] as List).map((x) => x.toString()))
            : [],
        rating: (json['rating'] as num?)?.toDouble(),
        review: json['review']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'item_id': itemId,
        'vendor_item_name': vendorItemName,
        'variant_name': variantName,
        'quantity': quantity,
        'price': price,
        'total_price': totalPrice,
        'addon_id': addonId,
        'addon_data': addonData,
        'images': images != null ? List<dynamic>.from(images!) : [],
        'rating': rating,
        'review': review,
      };
}

/// Represents a status log entry for the order.
class OrderStatusLog {
  final String? fromStatus;
  final String? toStatus;
  final String? changedBy;
  final String? note;
  final String? createdAt;

  OrderStatusLog({
    this.fromStatus,
    this.toStatus,
    this.changedBy,
    this.note,
    this.createdAt,
  });

  factory OrderStatusLog.fromJson(Map<String, dynamic> json) =>
      OrderStatusLog(
        fromStatus: json['from_status']?.toString(),
        toStatus: json['to_status']?.toString() ?? '',
        changedBy: json['changed_by']?.toString() ?? '',
        note: json['note']?.toString(),
        createdAt: json['created_at']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'from_status': fromStatus,
        'to_status': toStatus,
        'changed_by': changedBy,
        'note': note,
        'created_at': createdAt,
      };
}

/// Represents the assigned delivery boy for the order.
class AssignedDeliveryBoy {
  final int? id;
  final String? name;
  final String? phone;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? assignmentStatus;
  final double? rating;
  final String? review;

  AssignedDeliveryBoy({
    this.id,
    this.name,
    this.phone,
    this.vehicleType,
    this.vehicleNumber,
    this.assignmentStatus,
    this.rating,
    this.review,
  });

  factory AssignedDeliveryBoy.fromJson(Map<String, dynamic> json) =>
      AssignedDeliveryBoy(
        id: (json['id'] as num?)?.toInt(),
        name: json['name']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        vehicleType: json['vehicle_type']?.toString() ?? '',
        vehicleNumber: json['vehicle_number']?.toString() ?? '',
        assignmentStatus: json['assignment_status']?.toString() ?? '',
        rating: (json['rating'] as num?)?.toDouble(),
        review: json['review']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'vehicle_type': vehicleType,
        'vehicle_number': vehicleNumber,
        'assignment_status': assignmentStatus,
        'rating': rating,
        'review': review,
      };
}

/// Represents vendor details in order details.
class OrderVendor {
  final int? id;
  final String? uuId;
  final String? entityName;
  final String? entityImage;

  OrderVendor({
    this.id,
    this.uuId,
    this.entityName,
    this.entityImage,
  });

  factory OrderVendor.fromJson(Map<String, dynamic> json) => OrderVendor(
        id: (json['id'] as num?)?.toInt(),
        uuId: json['uu_id']?.toString() ?? '',
        entityName: json['entity_name']?.toString() ?? '',
        entityImage: json['entity_image']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uu_id': uuId,
        'entity_name': entityName,
        'entity_image': entityImage,
      };
}
