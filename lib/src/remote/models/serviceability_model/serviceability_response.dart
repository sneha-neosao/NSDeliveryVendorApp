import 'dart:convert';

/// Represents the response model for the serviceability update API.
class ServiceabilityResponse {
  final int? status;
  final String? message;
  final ServiceabilityData? data;

  ServiceabilityResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ServiceabilityResponse.fromRawJson(String str) =>
      ServiceabilityResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServiceabilityResponse.fromJson(Map<String, dynamic> json) =>
      ServiceabilityResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] != null && json['data'] is Map<String, dynamic>
            ? ServiceabilityData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

/// Represents the serviceability data object.
class ServiceabilityData {
  final int? id;
  final String? uuId;
  final String? entityName;
  final bool? adminIsServiceable;
  final bool? autoIsServiceable;

  ServiceabilityData({
    this.id,
    this.uuId,
    this.entityName,
    this.adminIsServiceable,
    this.autoIsServiceable,
  });

  factory ServiceabilityData.fromJson(Map<String, dynamic> json) =>
      ServiceabilityData(
        id: (json['id'] as num?)?.toInt(),
        uuId: json['uu_id']?.toString() ?? '',
        entityName: json['entity_name']?.toString() ?? '',
        adminIsServiceable: json['admin_is_serviceable'] == true,
        autoIsServiceable: json['auto_is_serviceable'] == true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uu_id': uuId,
        'entity_name': entityName,
        'admin_is_serviceable': adminIsServiceable,
        'auto_is_serviceable': autoIsServiceable,
      };
}
