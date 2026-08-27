import 'dart:convert';

/// Represents the response model for the restaurant slots list API.
class SlotsListResponse {
  final int? status;
  final String? message;
  final List<SlotItem>? data;
  final SlotPagination? pagination;

  SlotsListResponse({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  factory SlotsListResponse.fromRawJson(String str) =>
      SlotsListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SlotsListResponse.fromJson(Map<String, dynamic> json) =>
      SlotsListResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] != null && json['data'] is List
            ? List<SlotItem>.from(
                (json['data'] as List).map(
                  (x) => SlotItem.fromJson(x as Map<String, dynamic>),
                ),
              )
            : [],
        pagination: json['pagination'] != null &&
                json['pagination'] is Map<String, dynamic>
            ? SlotPagination.fromJson(
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

/// Represents a single time slot item.
class SlotItem {
  final int? id;
  final String? uuId;
  final String? slug;
  final int? vendorId;
  final String? dayOfWeek;
  final String? startTime;
  final String? endTime;
  final bool? isActive;
  final String? createdAt;

  SlotItem({
    this.id,
    this.uuId,
    this.slug,
    this.vendorId,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.isActive,
    this.createdAt,
  });

  factory SlotItem.fromJson(Map<String, dynamic> json) => SlotItem(
        id: (json['id'] as num?)?.toInt(),
        uuId: json['uu_id']?.toString() ?? '',
        slug: json['slug']?.toString() ?? '',
        vendorId: (json['vendor_id'] as num?)?.toInt(),
        dayOfWeek: json['day_of_week']?.toString() ?? '',
        startTime: json['start_time']?.toString() ?? '',
        endTime: json['end_time']?.toString() ?? '',
        isActive: json['is_active'] == true,
        createdAt: json['created_at']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uu_id': uuId,
        'slug': slug,
        'vendor_id': vendorId,
        'day_of_week': dayOfWeek,
        'start_time': startTime,
        'end_time': endTime,
        'is_active': isActive,
        'created_at': createdAt,
      };
}

/// Represents pagination metadata for slots list.
class SlotPagination {
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? totalPages;

  SlotPagination({
    this.total,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  factory SlotPagination.fromJson(Map<String, dynamic> json) => SlotPagination(
        total: (json['total'] as num?)?.toInt() ?? 0,
        perPage: (json['per_page'] as num?)?.toInt() ?? 10,
        currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
        totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'per_page': perPage,
        'current_page': currentPage,
        'total_pages': totalPages,
      };
}
