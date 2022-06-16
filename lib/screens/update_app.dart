// ignore_for_file: missing_return

import 'dart:io';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/utils_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppScreen extends StatefulWidget {
  @override
  _UpdateAppScreenState createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {


  @override
  void initState() {
    //on Splash Screen hide statusbar
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  void _launchURL(var _url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    // String _verify_by = widget.verify_by; //phone or email
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              children: [
                SizedBox(height: 180,),
                Container(
                  width: _screen_width * 0.7,
                  height: 85,
                  child:
                  Image.asset('assets/login_registration_form_logo.png'),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "There is new update available.Please the application now.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),

                Padding(
                    padding: EdgeInsets.all(20),
                    child: FlatButton(
                      minWidth: 200,
                      //height: 50,
                      color: MyTheme.golden,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(40.0))),
                      child: Text(
                        "Update",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        if (Platform.isAndroid || Platform.isIOS) {
                          final appId = Platform.isAndroid ? 'com.meghbela.mart' : 'YOUR_IOS_APP_ID';
                          final url = Uri.parse(
                            Platform.isAndroid
                                ? "market://details?id=$appId"
                                : "https://apps.apple.com/app/id$appId",
                          );
                          Utils.logResponse("App Store url: "+url.toString());
                          _launchURL(url.toString());
                        }
                      },
                    ),
                )
              ],

        ),
      ),
    );
  }
}
