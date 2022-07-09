// ignore_for_file: missing_return

import 'dart:async';
import 'dart:convert';

import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Otp extends StatefulWidget {
  final String phNo;
  final String name;
  final String userType;
  final bool loginPage;

  const Otp({Key key, this.phNo, this.name, this.loginPage, this.userType})
      : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  //controllers
  TextEditingController _verificationCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 // OtpFieldController otpController = OtpFieldController();
  String otpVal = "";
  bool otpVisible = false;

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    _timer.cancel();
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
  onTapResend() async {
    _start = 30;
    startTimer();
    await AuthRepository()
        .getSendOtpResponse(context, widget.phNo, "1", 0)
        .then((value) {
      if (jsonDecode(value.toString())["result"] == true) {
      ToastComponent.showDialog(jsonDecode(value.toString())["message"], context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(jsonDecode(value.toString())["message"], context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    }
    });
 }

  // onPressConfirm() async {
  //   var code = _verificationCodeController.text.toString();

  //   if (code == "") {
  //     ToastComponent.showDialog(
  //         AppLocalizations.of(context).otp_screen_verification_code_warning,
  //         context,
  //         gravity: Toast.CENTER,
  //         duration: Toast.LENGTH_LONG);
  //     return;
  //   }

  //   var confirmCodeResponse =
  //       await AuthRepository().getConfirmCodeResponse(widget.user_id, code);

  //   if (confirmCodeResponse.result == false) {
  //     ToastComponent.showDialog(confirmCodeResponse.message, context,
  //         gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
  //   } else {
  //     ToastComponent.showDialog(confirmCodeResponse.message, context,
  //         gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return Login();
  //     }));
  //   }
  // }
  onPressedLogin() async {
    if (widget.loginPage == false) {
      await AuthRepository()
          .getSignupMeghbelaResponse(context, widget.phNo, otpVal, widget.name)
          .then((value) {
        if (jsonDecode(value.toString())["result"] == true) {
         /* Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return Main();
          }));*/
          ToastComponent.showDialog(
              "Now you can login to your account", context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return Login();
          }));
        } else {
          ToastComponent.showDialog(
              jsonDecode(value.toString())["message"], context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        }
      });
    } else {
      var loginResponse = await AuthRepository()
          .getLoginMeghbelaResponse(
              context, widget.phNo, otpVal, widget.userType);
          //.then((value) {
        if (loginResponse.result == true) {
          AuthHelper().setUserData(loginResponse);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return Main();
          }));
        } else {
          ToastComponent.showDialog(
              loginResponse.message, context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        }
      }


    /*if (loginResponse.result == false) {
      ToastComponent.showDialog(loginResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(loginResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      AuthHelper().setUserData(loginResponse);


      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    // String _verify_by = widget.verify_by; //phone or email
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        decoration: const BoxDecoration(gradient: MyTheme.gradColor),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Stack(
            children: [
              // Container(
              //   width: _screen_width * (3 / 4),
              //   child: Image.asset(
              //       "assets/splash_login_registration_background_image.png"),
              // ),
              Container(
                width: double.infinity,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 35),
                      child: Container(
                        width: _screen_width * 0.7,
                        height: 85,
                        child: Image.asset(
                            'assets/login_registration_form_logo.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        "${AppLocalizations.of(context).otp_screen_verify_your} " +
                            AppLocalizations.of(context)
                                .otp_screen_phone_number + "\n+91${widget.phNo}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: MyTheme.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                          width: _screen_width * (3 / 4),
                          child: Text(
                              AppLocalizations.of(context)
                                  .otp_screen_enter_verification_code_to_phone,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MyTheme.white, fontSize: 14))),
                    ),
                    Container(
                      width: _screen_width * (3 / 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 45,
                                  child: TextField(
                                    controller: _verificationCodeController,
                                    autofocus: false,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    onChanged: (value) {
                                      otpVal = value;
                                      setState(() {});
                                    },
                                    decoration: InputDecorations.buildInputDecoration_1(
                                        hint_text: ""),
                                  ),
                                  /*OTPTextField(
                                      controller: otpController,
                                      length: 4,
                                      width: _screen_width,
                                      textFieldAlignment:
                                          MainAxisAlignment.center,
                                      fieldWidth: 30,
                                      fieldStyle: FieldStyle.underline,
                                      otpFieldStyle: OtpFieldStyle(
                                          borderColor: Colors.white,
                                          enabledBorderColor: otpVisible
                                              ? Colors.red
                                              : Colors.black),
                                      outlineBorderRadius: 10,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                      onChanged: (pin) {},
                                      onCompleted: (pin) {
                                        otpVal = pin;
                                        setState(() {});
                                      }),*/
                                ),
                                // Container(
                                //   height: 36,
                                //   child: TextField(
                                //     controller: _verificationCodeController,
                                //     autofocus: false,
                                //     inputFormatters: [
                                //       LengthLimitingTextInputFormatter(6),
                                //     ],
                                //     decoration:
                                //         InputDecorations.buildInputDecoration_1(
                                //             hint_text: "A X B 4 J H"),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: MyTheme.textfield_grey, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              child: FlatButton(
                                minWidth: MediaQuery.of(context).size.width,
                                //height: 50,
                                color: MyTheme.accent_color,
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .otp_screen_confirm,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  if (otpVal == "") {
                                    ToastComponent.showDialog(
                                        AppLocalizations.of(context)
                                            .otp_screen_verification_code_warning,
                                        context,
                                        gravity: Toast.CENTER,
                                        duration: Toast.LENGTH_LONG);
                                    setState(() {
                                      otpVisible = true;
                                    });
                                    return;
                                  } else {
                                    setState(() {
                                      otpVisible = false;
                                    });
                                  }
                                  onPressedLogin();

                                  // onPressConfirm();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: InkWell(
                        onTap: () {
                          if(_start == 0){
                            print("==resendOTP");
                            onTapResend();
                          }
                        },
                        child: _start == 0?Text(
                            AppLocalizations.of(context).otp_screen_resend_code,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyTheme.white,
                                decoration: TextDecoration.underline,
                                fontSize: 13))
                            :Text(
                            "Resend OTP in\n$_start",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyTheme.white,
                                fontSize: 13))
                      ),
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
