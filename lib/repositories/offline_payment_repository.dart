import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:active_ecommerce_flutter/data_model/offline_payment_submit_response.dart';

import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

import '../utils_log.dart';

class OfflinePaymentRepository {
  Future<OfflinePaymentSubmitResponse> getOfflinePaymentSubmitResponse(
      {@required int order_id,
      @required String amount,
      @required String name,
      @required String trx_id,
      @required int photo}) async {
    var post_body = jsonEncode({
      "order_id": "$order_id",
      "amount": "$amount",
      "name": "$name",
      "trx_id": "$trx_id",
      "photo": "$photo",
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/offline/payment/submit");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("Request: "+post_body);
    Utils.logResponse("response: "+response.body);
    return offlinePaymentSubmitResponseFromJson(response.body);
  }



}
