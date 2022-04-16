import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:active_ecommerce_flutter/data_model/language_list_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import '../utils_log.dart';

class LanguageRepository {
  Future<LanguageListResponse> getLanguageList() async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/languages");
    final response = await http.get(url,headers: {
      "App-Language": app_language.$,
    }
    );
    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("response: "+response.body);
    return languageListResponseFromJson(response.body);
  }


}
