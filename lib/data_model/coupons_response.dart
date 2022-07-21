// To parse this JSON data, do
//
//     final clubpointResponse = clubpointResponseFromJson(jsonString);

import 'dart:convert';

CouponsResponse couponsResponseFromJson(String str) => CouponsResponse.fromJson(json.decode(str));

String couponsResponseToJson(CouponsResponse data) => json.encode(data.toJson());

class CouponsResponse {
  CouponsResponse({
    this.discount,
    this.success
  });

  List<Coupons> discount;
  bool success;

  factory CouponsResponse.fromJson(Map<String, dynamic> json) => CouponsResponse(
    discount: List<Coupons>.from(json["discount"].map((x) => Coupons.fromJson(x))),
    success: json["success"]
  );

  Map<String, dynamic> toJson() => {
    "discount": List<dynamic>.from(discount.map((x) => x.toJson())),
    "success": success
  };
}

class Coupons {
  Coupons({
    this.code,
    this.discount,
    this.discount_type,
    this.coupon_discount_text,
    this.status,
    this.offer_end,
    this.details,
  });

  String code;
  int discount;
  String discount_type;
  String coupon_discount_text;
  String status;
  String offer_end;
  Details details;

  factory Coupons.fromJson(Map<String, dynamic> json) => Coupons(
    code: json["code"],
    discount: json["discount"],
    discount_type: json["discount_type"],
    coupon_discount_text: json["coupon_discount_text"],
    status:json["status"],
    offer_end:json["offer_end"],
    details: Details.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "discount": discount,
    "discount_type": discount_type,
    "coupon_discount_text": coupon_discount_text,
    "status":status,
    "offer_end":offer_end,
    "details": details.toJson(),
  };
}
//------------------------
class Details {
  Details({
    this.min_buy,
    this.max_discount
  });

  String min_buy;
  String max_discount;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    min_buy: json["min_buy"],
    max_discount: json["max_discount"]
  );

  Map<String, dynamic> toJson() => {
    "min_buy": min_buy,
    "max_discount": max_discount
  };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}
