import 'dart:convert';

import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginRegister extends StatefulWidget {
  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  String _login_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");
  String _phone = "", _fullName = "";
  int userType = 0;
  String usersTypeStatus = 'Select Users Type';
  List<String> usersTypeList = [
    'Existing Meghbela user',
    'Not existing Meghbela user'
  ];

  //controllers
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }


  onPressedLogin() async {
    await AuthRepository()
        .getSendOtpResponse(context, _phone, "2", 1)
        .then((value) {
      if (jsonDecode(value.toString())["result"] == true) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Otp(
            phNo: _phone,
            name: _nameController.text,
            loginPage: false,
            userType: "2",
          );
        }));
      } else {
        ToastComponent.showDialog(
            jsonDecode(value.toString())["message"], context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    });
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
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        decoration: const BoxDecoration(gradient: MyTheme.gradColor),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: _screen_width * 0.7,
                    height: 85,
                    child:
                        Image.asset('assets/login_registration_form_logo.png'),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  /*Container(
                    // padding: const EdgeInsets.only(left: 24, right: 24),
                    margin: EdgeInsets.only(left: 50, right: 50),
                    child: Container(
                      // padding: const EdgeInsets.only(left: 0, right: 0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: DropDownWidget(
                        onTap: (value) {
                          usersTypeStatus = value.toString();
                          userType =
                              value.toString() == "Existing Meghbela user"
                                  ? 1
                                  : 2;
                          setState(() {});
                        },
                        status: usersTypeStatus,
                        statusList: usersTypeList,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),*/
                  Text(
                    "${AppLocalizations.of(context).login_screen_enter_your_10_digit_mobile_no} ",
                    style: TextStyle(
                        color: MyTheme.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    height: 46,
                    child: TextField(
                      controller: _phoneNumberController,
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onChanged: (value) {
                        _phone = value;
                      },
                      decoration: InputDecorations.buildInputDecoration_1(
                          hint_text: ""),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${AppLocalizations.of(context).registration_screen_name_warning} ",
                    style: TextStyle(
                        color: MyTheme.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    height: 46,
                    child: TextField(
                      controller: _nameController,
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20),
                      ],
                      onChanged: (value) {
                        _fullName = value;
                      },
                      decoration: InputDecorations.buildInputDecoration_1(
                          hint_text: ""),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30.0, left: 100, right: 100),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: MyTheme.textfield_grey, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(40.0))),
                      child: FlatButton(
                        minWidth: MediaQuery.of(context).size.width,
                        //height: 50,
                        color: MyTheme.golden,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40.0))),
                        child: Text(
                          AppLocalizations.of(context).login_screen_sign_up,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {

                          if (_phone == "" || _fullName == "" || _phone.length <10) {
                            ToastComponent.showDialog(
                                "All fields required",
                                context,
                                gravity: Toast.CENTER,
                                duration: Toast.LENGTH_LONG);
                            return;
                          }

                          onPressedLogin();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Or",
                    style: TextStyle(
                        color: MyTheme.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30.0, left: 100, right: 100),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: MyTheme.textfield_grey, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(40.0))),
                      child: FlatButton(
                        minWidth: MediaQuery.of(context).size.width,
                        //height: 50,
                        color: MyTheme.splash_screen_color,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40.0))),
                        child: Text(
                          AppLocalizations.of(context).login_screen_log_in,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          //    onPressedLogin();
                          // if (_phone == "") {
                          //   ToastComponent.showDialog(
                          //       AppLocalizations.of(context)
                          //           .login_screen_phone_warning,
                          //       context,
                          //       gravity: Toast.CENTER,
                          //       duration: Toast.LENGTH_LONG);
                          //   return;
                          // }

                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return LoginRegister();
                          // }));
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          /*Stack(
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
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                      child: Container(
                        width: _screen_width * 0.5,
                        height: 75,
                        child: Image.asset(
                            'assets/login_registration_form_logo.png'),
                      ),
                    ),


              Container(
                height: 400,
                width: _screen_width * (3 / 4),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 20.0, top: _screen_height * 0.05),
                        child: Text(
                            "${AppLocalizations.of(context).login_screen_enter_your_10_digit_mobile_no} ",
                          style: TextStyle(
                              color: MyTheme.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        height: 46,
                        child: TextField(
                          controller: _phoneNumberController,
                          autofocus: false,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onChanged: (value) {
                            _phone = value;
                          },
                          decoration: InputDecorations
                              .buildInputDecoration_1(
                              hint_text: ""),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                    */ /*Padding(
                      padding: EdgeInsets.only(
                          bottom: 20.0, top: _screen_height * 0.05),
                      child: Text(
                        "${AppLocalizations.of(context).login_screen_login_to} " +
                            AppConfig.app_name,
                        style: TextStyle(
                            color: MyTheme.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: _screen_width * (3 / 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: _screen_height * 0.05,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              _login_by == "email"
                                  ? AppLocalizations.of(context)
                                      .login_screen_email
                                  : AppLocalizations.of(context)
                                      .login_screen_phone,
                              style: TextStyle(
                                  color: MyTheme.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          if (_login_by == "email")
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 46,
                                    child: TextField(
                                      controller: _emailController,
                                      autofocus: false,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecorations
                                          .buildInputDecoration_1(
                                              hint_text: ""),
                                    ),
                                  ),
                                  otp_addon_installed.$
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _login_by = "phone";
                                            });
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .login_screen_or_login_with_phone,
                                            style: TextStyle(
                                                color: MyTheme.white,
                                                fontStyle: FontStyle.italic,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 46,
                                    child: TextField(
                                      controller: _phoneNumberController,
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(color: Colors.white),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      onChanged: (value) {
                                        _phone = value;
                                      },
                                      decoration: InputDecorations
                                          .buildInputDecoration_1(
                                              hint_text: ""),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _login_by = "email";
                                      });
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .login_screen_or_login_with_email,
                                      style: TextStyle(
                                          color: MyTheme.white,
                                          fontStyle: FontStyle.italic,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          // Padding(
                          //   padding: const EdgeInsets.only(bottom: 8.0),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.end,
                          //     children: [
                          //       Container(
                          //         height: 36,
                          //         child: CustomInternationalPhoneNumberInput(
                          //           onInputChanged: (PhoneNumber number) {
                          //             print(number.phoneNumber);
                          //             setState(() {
                          //               _phone = number.phoneNumber;
                          //             });
                          //           },
                          //           onInputValidated: (bool value) {
                          //             print(value);
                          //           },
                          //           selectorConfig: SelectorConfig(
                          //             selectorType:
                          //                 PhoneInputSelectorType.DIALOG,
                          //           ),
                          //           ignoreBlank: false,
                          //           autoValidateMode:
                          //               AutovalidateMode.disabled,
                          //           selectorTextStyle:
                          //               TextStyle(color: MyTheme.font_grey),
                          //           textStyle:
                          //               TextStyle(color: MyTheme.font_grey),
                          //           initialValue: phoneCode,
                          //           textFieldController:
                          //               _phoneNumberController,
                          //           formatInput: true,
                          //           keyboardType:
                          //               TextInputType.numberWithOptions(
                          //                   signed: true, decimal: true),
                          //           inputDecoration: InputDecorations
                          //               .buildInputDecoration_phone(
                          //                   hint_text: "01710 333 558"),
                          //           onSaved: (PhoneNumber number) {
                          //             print('On Saved: $number');
                          //           },
                          //         ),
                          //       ),
                          //       GestureDetector(
                          //         onTap: () {
                          //           setState(() {
                          //             _login_by = "email";
                          //           });
                          //         },
                          //         child: Text(
                          //           AppLocalizations.of(context)
                          //               .login_screen_or_login_with_email,
                          //           style: TextStyle(
                          //               color: MyTheme.white,
                          //               fontStyle: FontStyle.italic,
                          //               decoration: TextDecoration.underline),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),

                          // Padding(
                          //   padding: const EdgeInsets.only(bottom: 4.0),
                          //   child: Text(
                          //     AppLocalizations.of(context)
                          //         .login_screen_password,
                          //     style: TextStyle(
                          //         color: MyTheme.white,
                          //         fontWeight: FontWeight.w600),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(bottom: 8.0),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.end,
                          //     children: [
                          //       Container(
                          //         height: 36,
                          //         child: TextField(
                          //           controller: _passwordController,
                          //           autofocus: false,
                          //           obscureText: true,
                          //           enableSuggestions: false,
                          //           autocorrect: false,
                          //           decoration:
                          //               InputDecorations.buildInputDecoration_1(
                          //                   hint_text: "• • • • • • • •"),
                          //         ),
                          //       ),
                          //       GestureDetector(
                          //         onTap: () {
                          //           Navigator.push(context,
                          //               MaterialPageRoute(builder: (context) {
                          //             return PasswordForget();
                          //           }));
                          //         },
                          //         child: Text(
                          //           AppLocalizations.of(context)
                          //               .login_screen_forgot_password,
                          //           style: TextStyle(
                          //               color: MyTheme.white,
                          //               fontStyle: FontStyle.italic,
                          //               decoration: TextDecoration.underline),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),

                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
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
                                color: MyTheme.golden,
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .login_screen_log_in,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  //onPressedLogin();
                                  var email = _emailController.text.toString();
                                  var password =
                                      _passwordController.text.toString();

                                  if (_login_by == 'email' && email == "") {
                                    ToastComponent.showDialog(
                                        AppLocalizations.of(context)
                                            .login_screen_email_warning,
                                        context,
                                        gravity: Toast.CENTER,
                                        duration: Toast.LENGTH_LONG);
                                    return;
                                  } else if (_login_by == 'phone' &&
                                      _phone == "") {
                                    ToastComponent.showDialog(
                                        AppLocalizations.of(context)
                                            .login_screen_phone_warning,
                                        context,
                                        gravity: Toast.CENTER,
                                        duration: Toast.LENGTH_LONG);
                                    return;
                                  }
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Otp(
                                      verify_by: _login_by == 'phone'
                                          ? 'phone'
                                          : 'email',
                                    );
                                  }));
                                },
                              ),
                            ),
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.only(top: 20.0),
                          //   child: Center(
                          //       child: Text(
                          //     AppLocalizations.of(context)
                          //         .login_screen_or_create_new_account,
                          //     style:
                          //         TextStyle(color: MyTheme.white, fontSize: 12),
                          //   )),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 4.0),
                          //   child: Container(
                          //     height: 45,
                          //     decoration: BoxDecoration(
                          //         border: Border.all(
                          //             color: MyTheme.textfield_grey, width: 1),
                          //         borderRadius: const BorderRadius.all(
                          //             Radius.circular(12.0))),
                          //     child: FlatButton(
                          //       minWidth: MediaQuery.of(context).size.width,
                          //       //height: 50,
                          //       color: MyTheme.accent_color,
                          //       shape: RoundedRectangleBorder(
                          //           borderRadius: const BorderRadius.all(
                          //               Radius.circular(12.0))),
                          //       child: Text(
                          //         AppLocalizations.of(context)
                          //             .login_screen_sign_up,
                          //         style: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 14,
                          //             fontWeight: FontWeight.w600),
                          //       ),
                          //       onPressed: () {
                          //         Navigator.push(context,
                          //             MaterialPageRoute(builder: (context) {
                          //           return Registration();
                          //         }));
                          //       },
                          //     ),
                          //   ),
                          // ),
                          // Visibility(
                          //   visible:
                          //       allow_google_login.$ || allow_facebook_login.$,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(top: 20.0),
                          //     child: Center(
                          //         child: Text(
                          //       AppLocalizations.of(context)
                          //           .login_screen_login_with,
                          //       style: TextStyle(
                          //           color: MyTheme.white, fontSize: 14),
                          //     )),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 30.0),
                          //   child: Center(
                          //     child: Container(
                          //       width: 120,
                          //       child: Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Visibility(
                          //             visible: allow_google_login.$,
                          //             child: InkWell(
                          //               onTap: () {
                          //                 // onPressedGoogleLogin();
                          //                 ToastComponent.showDialog(
                          //                     AppConfig.featureNotAvailable,
                          //                     context,
                          //                     gravity: Toast.CENTER,
                          //                     duration: Toast.LENGTH_LONG);
                          //               },
                          //               child: Container(
                          //                 width: 28,
                          //                 child: Image.asset(
                          //                     "assets/google_logo.png"),
                          //               ),
                          //             ),
                          //           ),
                          //           Visibility(
                          //             visible: allow_facebook_login.$,
                          //             child: InkWell(
                          //               onTap: () {
                          //                 // onPressedFacebookLogin();
                          //                 ToastComponent.showDialog(
                          //                     AppConfig.featureNotAvailable,
                          //                     context,
                          //                     gravity: Toast.CENTER,
                          //                     duration: Toast.LENGTH_LONG);
                          //               },
                          //               child: Container(
                          //                 width: 28,
                          //                 child: Image.asset(
                          //                     "assets/facebook_logo.png"),
                          //               ),
                          //             ),
                          //           ),
                          //           Visibility(
                          //             visible: allow_twitter_login.$,
                          //             child: InkWell(
                          //               onTap: () {
                          //                 // onPressedTwitterLogin();
                          //                 ToastComponent.showDialog(
                          //                     AppConfig.featureNotAvailable,
                          //                     context,
                          //                     gravity: Toast.CENTER,
                          //                     duration: Toast.LENGTH_LONG);
                          //               },
                          //               child: Container(
                          //                 width: 28,
                          //                 child: Image.asset(
                          //                     "assets/twitter_logo.png"),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    )*/ /*
                  ],
                )),
              )
            ],
          ),*/
        ),
      ),
    );
  }
}
