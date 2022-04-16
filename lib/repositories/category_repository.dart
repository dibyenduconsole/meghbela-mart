import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/category_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import '../utils_log.dart';

class CategoryRepository {

  Future<CategoryResponse> getCategories({parent_id = 0}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    final response =
    await http.get(url,headers: {
      "App-Language": app_language.$,
    });
    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("response: "+response.body);
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getFeturedCategories() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/categories/featured");
    final response =
        await http.get(url,headers: {
          "App-Language": app_language.$,
        });
    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("response: "+response.body);
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getTopCategories() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/categories/top");
    final response =
    await http.get(url,headers: {
      "App-Language": app_language.$,
    });
    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("response: "+response.body);
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getFilterPageCategories() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/filter/categories");
    final response =
    await http.get(url,headers: {
      "App-Language": app_language.$,
    });
    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("response: "+response.body);
    return categoryResponseFromJson(response.body);
  }


}
