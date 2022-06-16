// To parse this JSON data, do
//
//     final sliderResponse = sliderResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

ForceUpdateResponse forceUpdateResponseFromJson(String str) => ForceUpdateResponse.fromJson(json.decode(str));

String forceUpdateResponseToJson(ForceUpdateResponse data) => json.encode(data.toJson());

class ForceUpdateResponse {
  ForceUpdateResponse({
    this.appVersion,
    this.success
  });

  List<AppVersion> appVersion;
  bool success;

  factory ForceUpdateResponse.fromJson(Map<String, dynamic> json) => ForceUpdateResponse(
    appVersion: List<AppVersion>.from(json["app_version"].map((x) => AppVersion.fromJson(x))),
    success: json["success"]
  );

  Map<String, dynamic> toJson() => {
    "app_version": List<dynamic>.from(appVersion.map((x) => x.toJson())),
    "success": success
  };
}

class AppVersion {
  AppVersion({
    this.id,
    this.device_type,
    this.version,
    this.status
  });

  int id;
  String device_type;
  String version;
  String status;

  factory AppVersion.fromJson(Map<String, dynamic> json) => AppVersion(
    id: json["id"],
    device_type: json["device_type"],
    version: json["version"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "device_type": device_type,
    "version": version,
    "status": status,
  };
}