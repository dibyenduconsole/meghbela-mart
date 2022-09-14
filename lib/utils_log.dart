

import 'package:active_ecommerce_flutter/screens/update_app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';

import 'app_config.dart';

class Utils{
  static void logResponse(var value){
    //print(value);
  }

  static String getImageFilePath(var value){
    String path = "";
    logResponse("value- $value");
    if(value != null){
      if(value.toString().startsWith("http")){
        path = value.toString().replaceAll("https://d2bi56w5lxny86.cloudfront.net/", AppConfig.BASE_PATH);
      }else if(value.toString().startsWith("file:///")){
        path = value.toString().replaceAll("file:///", AppConfig.BASE_PATH);
      }
      else{
        path = AppConfig.BASE_PATH + value.toString();
      }
    }else{
      path = "${AppConfig.ERROR_IMAGE}";
    }
    logResponse("path- "+path);
    return path;
  }

  static String getDateFromTime(int millis){
    var dt = DateTime.fromMillisecondsSinceEpoch(millis);

// 12 Hour format:
    var d12 = DateFormat('MM/dd/yyyy').format(dt);
    Utils.logResponse("Time-"+d12);
    return d12.toString();
  }

  static void checkForceUpdateRequired(var context, String v){
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      print("appName- ${appName}");
      print("packageName- ${packageName}");
      print("version- ${version}");
      print("local buildNumber- ${buildNumber}");
      print("server v- ${v}");
      try{
      var iVersion = int.parse(v);
      var iBuildNumber = int.parse(buildNumber);
      if(iVersion > iBuildNumber){
        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateAppScreen()));
      }
      }catch(error){

      }

    });
  }
}