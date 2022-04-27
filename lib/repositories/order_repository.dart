import 'dart:convert';
import 'dart:developer';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:active_ecommerce_flutter/data_model/order_mini_response.dart';
import 'package:active_ecommerce_flutter/data_model/order_detail_response.dart';
import 'package:active_ecommerce_flutter/data_model/order_item_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import '../utils_log.dart';

class OrderRepository {
  Future<OrderMiniResponse> getOrderList(
      {page = 1, payment_status = "", delivery_status = ""}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/purchase-history" +
        "?page=${page}&payment_status=${payment_status}&delivery_status=${delivery_status}");
    Utils.logResponse("url:" +url.toString());
    Utils.logResponse("token:" +access_token.$);
    final response = await http.get(url,headers: {
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
        });

    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("response: "+response.body);
    return orderMiniResponseFromJson(response.body);
  }

  Future<OrderDetailResponse> getOrderDetails({@required int id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/purchase-history-details/" + id.toString());

    final response = await http.get(url,headers: {
      "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$,
        });
    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("response: "+response.body);
    return orderDetailResponseFromJson(response.body);
  }

  Future<String> cancelOrderDetails({ String code , String phone}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/auth/change-delivery-status");

    var post_body = jsonEncode({
      "code": code,
      "phone": phone
    });
    log("=Request: \n$url\n" + post_body);
    final response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("Request: "+post_body);
    Utils.logResponse("response: "+response.body);
    return response.body;
  }

  Future<OrderItemResponse> getOrderItems({@required int id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/purchase-history-items/" + id.toString());
    final response = await http.get(url,headers: {
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
        });
    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("response: "+response.body);
    return orderItemlResponseFromJson(response.body);
  }
}
