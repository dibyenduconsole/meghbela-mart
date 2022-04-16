import 'dart:developer';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/login_response.dart';
import 'package:active_ecommerce_flutter/data_model/logout_response.dart';
import 'package:active_ecommerce_flutter/data_model/signup_response.dart';
import 'package:active_ecommerce_flutter/data_model/resend_code_response.dart';
import 'package:active_ecommerce_flutter/data_model/confirm_code_response.dart';
import 'package:active_ecommerce_flutter/data_model/password_forget_response.dart';
import 'package:active_ecommerce_flutter/data_model/password_confirm_response.dart';
import 'package:active_ecommerce_flutter/data_model/user_by_token.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import '../utils_log.dart';

class AuthRepository {
  Future<LoginResponse> getLoginResponse(
      @required String email, @required String password) async {
    var post_body = jsonEncode({
      "email": "${email}",
      "password": "$password",
      "identity_matrix": AppConfig.purchase_code
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/login");
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
    return loginResponseFromJson(response.body);
  }

  Future<LoginResponse> getSocialLoginResponse(@required String name,
      @required String email, @required String provider) async {
    email = email == ("null") ? "" : email;

    var post_body = jsonEncode(
        {"name": "${name}", "email": email, "provider": "$provider"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/social-login");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("Request: "+post_body);
    Utils.logResponse("response: "+response.body);
    return loginResponseFromJson(response.body);
  }

  Future<LogoutResponse> getLogoutResponse() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/logout");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );

    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("response: "+response.body);

    return logoutResponseFromJson(response.body);
  }

  Future<SignupResponse> getSignupResponse(
      @required String name,
      @required String email_or_phone,
      @required String password,
      @required String passowrd_confirmation,
      @required String register_by) async {
    var post_body = jsonEncode({
      "name": "$name",
      "email_or_phone": "${email_or_phone}",
      "password": "$password",
      "password_confirmation": "${passowrd_confirmation}",
      "register_by": "$register_by"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/signup");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("Request: "+post_body);
    Utils.logResponse("response: "+response.body);
    return signupResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getResendCodeResponse(
      @required int user_id, @required String verify_by) async {
    var post_body =
        jsonEncode({"user_id": "$user_id", "register_by": "$verify_by"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/resend_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("Request: "+post_body);
    Utils.logResponse("response: "+response.body);
    return resendCodeResponseFromJson(response.body);
  }

  Future<ConfirmCodeResponse> getConfirmCodeResponse(
      @required int user_id, @required String verification_code) async {
    var post_body = jsonEncode(
        {"user_id": "$user_id", "verification_code": "$verification_code"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/confirm_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("Request: "+post_body);
    Utils.logResponse("response: "+response.body);
    return confirmCodeResponseFromJson(response.body);
  }

  Future<PasswordForgetResponse> getPasswordForgetResponse(
      @required String email_or_phone, @required String send_code_by) async {
    var post_body = jsonEncode(
        {"email_or_phone": "$email_or_phone", "send_code_by": "$send_code_by"});

    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/auth/password/forget_request",
    );
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("Request: "+post_body);
    Utils.logResponse("response: "+response.body);

    return passwordForgetResponseFromJson(response.body);
  }

  Future<PasswordConfirmResponse> getPasswordConfirmResponse(
      @required String verification_code, @required String password) async {
    var post_body = jsonEncode(
        {"verification_code": "$verification_code", "password": "$password"});

    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/auth/password/confirm_reset",
    );
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("Request: "+post_body);
    Utils.logResponse("response: "+response.body);
    return passwordConfirmResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getPasswordResendCodeResponse(
      @required String email_or_code, @required String verify_by) async {
    var post_body = jsonEncode(
        {"email_or_code": "$email_or_code", "verify_by": "$verify_by"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/password/resend_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("Request: "+post_body);
    Utils.logResponse("response: "+response.body);
    return resendCodeResponseFromJson(response.body);
  }

  Future<UserByTokenResponse> getUserByTokenResponse() async {
    var post_body = jsonEncode({"access_token": "${access_token.$}"});
    Uri url = Uri.parse("${AppConfig.BASE_URL}/get-user-by-access_token");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    Utils.logResponse("URL: "+url.toString());
    Utils.logResponse("Request: "+post_body);
    Utils.logResponse("response: "+response.body);
    return userByTokenResponseFromJson(response.body);
  }

  Future<String> getSendOtpResponse(
      BuildContext context, String phNo, String userType, int isReg) async {
    var post_body = jsonEncode({
      "country_code": "+91",
      "phone": phNo,
      "user_type": userType,
      "is_register": isReg
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/send-otp");
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

  Future<String> getSignupMeghbelaResponse(
      BuildContext context, String phNo, String otp, String name) async {
    var post_body = jsonEncode(
        {"country_code": "+91", "phone": phNo, "otp": otp, "name": name});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/signup-meghbela");
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

  Future<LoginResponse> getLoginMeghbelaResponse(
      BuildContext context, String phNo, String otp, String userType) async {
    var post_body = jsonEncode({
      "country_code": "+91",
      "phone": phNo,
      "otp": otp,
      "user_type": userType,
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/login-meghbela");
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
    return loginResponseFromJson(response.body);
  }
}
