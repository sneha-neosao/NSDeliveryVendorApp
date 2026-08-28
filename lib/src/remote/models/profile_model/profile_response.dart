import 'dart:convert';

/// Represents the response model for the Profile Details API.
class ProfileResponse {
  final int? status;
  final String? message;
  final ProfileData? data;

  ProfileResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ProfileResponse.fromRawJson(String str) =>
      ProfileResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class ProfileData {
  final int? id;
  final String? uuId;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? entityName;
  final String? entityImage;
  final String? entityContact;
  final String? email;
  final num? avgRating;
  final int? totalReviews;
  final bool? autoIsServiceable;
  final bool? adminIsServiceable;

  ProfileData({
    this.id,
    this.uuId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.entityName,
    this.entityImage,
    this.entityContact,
    this.email,
    this.avgRating,
    this.totalReviews,
    this.autoIsServiceable,
    this.adminIsServiceable,
  });

  factory ProfileData.fromRawJson(String str) =>
      ProfileData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: (json['id'] as num?)?.toInt(),
        uuId: json['uu_id']?.toString(),
        firstName: json['first_name']?.toString(),
        middleName: json['middle_name']?.toString(),
        lastName: json['last_name']?.toString(),
        entityName: json['entity_name']?.toString(),
        entityImage: json['entity_image']?.toString(),
        entityContact: json['entity_contact']?.toString(),
        email: json['email']?.toString(),
        avgRating: json['avg_rating'] as num?,
        totalReviews: (json['total_reviews'] as num?)?.toInt(),
        autoIsServiceable: json['auto_is_serviceable'] as bool?,
        adminIsServiceable: json['admin_is_serviceable'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uu_id': uuId,
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'entity_name': entityName,
        'entity_image': entityImage,
        'entity_contact': entityContact,
        'email': email,
        'avg_rating': avgRating,
        'total_reviews': totalReviews,
        'auto_is_serviceable': autoIsServiceable,
        'admin_is_serviceable': adminIsServiceable,
      };

  String get fullName {
    final parts = [firstName, middleName, lastName]
        .where((e) => e != null && e.trim().isNotEmpty)
        .join(' ');
    return parts.isNotEmpty ? parts : (entityName ?? 'Vendor');
  }
}
