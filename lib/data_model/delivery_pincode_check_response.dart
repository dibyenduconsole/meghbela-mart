import 'dart:convert';

DeliveryPicCodeResponse deliveryPicCodeResponseFromJson(String str) => DeliveryPicCodeResponse.fromJson(json.decode(str));

String deliveryPicCodeResponseToJson(DeliveryPicCodeResponse data) => json.encode(data.toJson());

class DeliveryPicCodeResponse {
  DeliveryPicCodeResponse({
    this.success,
    this.message,
  });

  bool success;
  String message;

  factory DeliveryPicCodeResponse.fromJson(Map<String, dynamic> json) => DeliveryPicCodeResponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}