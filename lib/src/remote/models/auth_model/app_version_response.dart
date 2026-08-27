import 'dart:convert';

/// Represents the response model for the App Version API (/auth/app-version).
class AppVersionResponse {
  final int? status;
  final String? message;
  final AppVersionData? data;

  AppVersionResponse({
    this.status,
    this.message,
    this.data,
  });

  factory AppVersionResponse.fromRawJson(String str) =>
      AppVersionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppVersionResponse.fromJson(Map<String, dynamic> json) =>
      AppVersionResponse(
        status: (json['status'] as num?)?.toInt(),
        message: json['message']?.toString() ?? '',
        data: json['data'] != null
            ? AppVersionData.fromJson(json['data'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class AppVersionData {
  final PlatformAppVersion? android;
  final PlatformAppVersion? ios;
  final bool? appMaintenance;

  AppVersionData({
    this.android,
    this.ios,
    this.appMaintenance,
  });

  factory AppVersionData.fromJson(Map<String, dynamic> json) => AppVersionData(
        android: json['android'] != null
            ? PlatformAppVersion.fromJson(json['android'])
            : null,
        ios: json['ios'] != null
            ? PlatformAppVersion.fromJson(json['ios'])
            : null,
        appMaintenance: json['app_maintenance'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'android': android?.toJson(),
        'ios': ios?.toJson(),
        'app_maintenance': appMaintenance,
      };
}

class PlatformAppVersion {
  final String? version;
  final bool? forceUpdate;
  final String? updateMessage;
  final String? storeLink;

  PlatformAppVersion({
    this.version,
    this.forceUpdate,
    this.updateMessage,
    this.storeLink,
  });

  factory PlatformAppVersion.fromJson(Map<String, dynamic> json) =>
      PlatformAppVersion(
        version: json['version']?.toString() ?? '',
        forceUpdate: json['force_update'] as bool? ?? false,
        updateMessage: json['update_message']?.toString() ?? '',
        storeLink: json['store_link']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'version': version,
        'force_update': forceUpdate,
        'update_message': updateMessage,
        'store_link': storeLink,
      };
}
