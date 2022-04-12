import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/custom/drop_down_widget.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/other_config.dart';
import 'package:active_ecommerce_flutter/screens/login_register.dart';
import 'package:active_ecommerce_flutter/screens/otp.dart';
import 'package:active_ecommerce_flutter/social_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/intl_phone_input.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:active_ecommerce_flutter/screens/registration.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/password_forget.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';

//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:twitter_login/twitter_login.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _login_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");
  String _phone = "";
  int userType = 1;
  String usersTypeStatus = 'Select Users Type';
  List<String> usersTypeList = [
    'Existing Meghbela user',
    'Not existing Meghbela user'
  ];

  //controllers
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
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

  /*onPressedLogin() async {
    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();

    if (_login_by == 'email' && email == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).login_screen_email_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (_login_by == 'phone' && _phone == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).login_screen_phone_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (password == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).login_screen_password_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    var loginResponse = await AuthRepository()
        .getLoginResponse(_login_by == 'email' ? email : _phone, password);
    if (loginResponse.result == false) {
      ToastComponent.showDialog(loginResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(loginResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      AuthHelper().setUserData(loginResponse);
      // push notification starts
      if (OtherConfig.USE_PUSH_NOTIFICATION) {
        // Make changes here
        //    final FirebaseMessaging _fcm = FirebaseMessaging.instance;

        // await _fcm.requestPermission(
        //   alert: true,
        //   announcement: false,
        //   badge: true,
        //   carPlay: false,
        //   criticalAlert: false,
        //   provisional: false,
        //   sound: true,
        // );

        // String fcmToken = await _fcm.getToken();

        // if (fcmToken != null) {
        //   print("--fcm token--");
        //   print(fcmToken);
        //   if (is_logged_in.$ == true) {
        //     // update device token
        //     var deviceTokenUpdateResponse = await ProfileRepository()
        //         .getDeviceTokenUpdateResponse(fcmToken);
        //   }
        // }
      }

      //push norification ends

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }
  }*/

  onPressedFacebookLogin() async {
    final facebookLogin =
        await FacebookAuth.instance.login(loginBehavior: LoginBehavior.webOnly);

    if (facebookLogin.status == LoginStatus.success) {
      // get the user data
      // by default we get the userId, email,name and picture
      final userData = await FacebookAuth.instance.getUserData();
      print(
          "name ${userData['name']},email ${userData['email'].toString()}, id ${userData['id'].toString()}");
      var loginResponse = await AuthRepository().getSocialLoginResponse(
          userData['name'].toString(),
          userData['email'].toString(),
          userData['id'].toString());
      print("..........................${loginResponse.toString()}");
      if (loginResponse.result == false) {
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      } else {
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        AuthHelper().setUserData(loginResponse);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Main();
        }));
        FacebookAuth.instance.logOut();
      }
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");

    } else {
      print("....Facebook auth Failed.........");
      print(facebookLogin.status);
      print(facebookLogin.message);
    }

    /*print(facebookLoginResult.accessToken);
    print(facebookLoginResult.accessToken.token);
    print(facebookLoginResult.accessToken.expires);
    print(facebookLoginResult.accessToken.permissions);
    print(facebookLoginResult.accessToken.userId);
    print(facebookLoginResult.accessToken.isValid());

    print(facebookLoginResult.errorMessage);
    print(facebookLoginResult.status);*/
/*
    final token = facebookLoginResult.accessToken.token;

    /// for profile details also use the below code
    Uri url = Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
    final graphResponse = await http.get(url);
    final profile = json.decode(graphResponse.body);
    //print(profile);
    /*from profile you will get the below params
    {
     "name": "Iiro Krankka",
     "first_name": "Iiro",
     "last_name": "Krankka",
     "email": "iiro.krankka\u0040gmail.com",
     "id": "<user id here>"
    }*/

    var loginResponse = await AuthRepository().getSocialLoginResponse(
        profile['name'], profile['email'], profile['id'].toString());

    if (loginResponse.result == false) {
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

  onPressedGoogleLogin() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      // var v = await  GoogleSignIn().signOut();
      //print("googleUser.email ${googleUser.id}");

      var loginResponse = await AuthRepository().getSocialLoginResponse(
          googleUser.displayName, googleUser.email, googleUser.id);
      print(loginResponse);
      if (loginResponse.result == false) {
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      } else {
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        AuthHelper().setUserData(loginResponse);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Main();
        }));
      }
      GoogleSignIn().disconnect();
    } on Exception catch (e) {
      print("error is ....... $e");
      // TODO
    }

    /*
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // you can add extras if you require
      ],
    );
    print("acc.id............${}");

    _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
      GoogleSignInAuthentication auth = await acc.authentication;
      print(acc.id);
      print(acc.email);
      print(acc.displayName);
      print(acc.photoUrl);

      acc.authentication.then((GoogleSignInAuthentication auth) async {
        print(auth.idToken);
        print(auth.accessToken);

        //---------------------------------------------------
        var loginResponse = await AuthRepository().getSocialLoginResponse(
            acc.displayName, acc.email, auth.accessToken);

        if (loginResponse.result == false) {
          ToastComponent.showDialog(loginResponse.message, context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        } else {
          ToastComponent.showDialog(loginResponse.message, context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          AuthHelper().setUserData(loginResponse);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Main();
          }));
        }

        //-----------------------------------
      });
    });*/
  }

  onPressedTwitterLogin() async {
    try {
      final twitterLogin = new TwitterLogin(
          apiKey: SocialConfig().twitter_consumer_key,
          apiSecretKey: SocialConfig().twitter_consumer_secret,
          redirectURI: 'activeecommerceflutterapp://');
      // Trigger the sign-in flow
      final authResult = await twitterLogin.login();

      var loginResponse = await AuthRepository().getSocialLoginResponse(
          authResult.user.name,
          authResult.user.email,
          authResult.user.id.toString());
      print(loginResponse);
      if (loginResponse.result == false) {
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      } else {
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        AuthHelper().setUserData(loginResponse);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Main();
        }));
      }
    } on Exception catch (e) {
      print("error is ....... $e");
      // TODO
    }

    /*
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // you can add extras if you require
      ],
    );
    print("acc.id............${}");

    _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
      GoogleSignInAuthentication auth = await acc.authentication;
      print(acc.id);
      print(acc.email);
      print(acc.displayName);
      print(acc.photoUrl);

      acc.authentication.then((GoogleSignInAuthentication auth) async {
        print(auth.idToken);
        print(auth.accessToken);

        //---------------------------------------------------
        var loginResponse = await AuthRepository().getSocialLoginResponse(
            acc.displayName, acc.email, auth.accessToken);

        if (loginResponse.result == false) {
          ToastComponent.showDialog(loginResponse.message, context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        } else {
          ToastComponent.showDialog(loginResponse.message, context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          AuthHelper().setUserData(loginResponse);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Main();
          }));
        }

        //-----------------------------------
      });
    });*/
  }

  onPressedLogin() async {
    await AuthRepository()
        .getSendOtpResponse(context, _phone, userType.toString(), 0)
        .then((value) {
      if (jsonDecode(value.toString())["result"] == true) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Otp(
            phNo: _phone,
            loginPage: true,
            userType: userType.toString(),
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
    /*if(is_logged_in.$){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return Main();
          }));
    }*/
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
                  /*SizedBox(
                    height: 50,
                  ),
                  Container(
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
                  ),*/
                  SizedBox(
                    height: 20,
                  ),
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
                          AppLocalizations.of(context).login_screen_log_in,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          if (_phone == "" || _phone.length < 10) {
                            ToastComponent.showDialog(
                               "Please enter valid mobile number",
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
                  /*SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${AppLocalizations.of(context).login_screen_or_create_new_account}",
                    style: TextStyle(
                        color: MyTheme.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),*/
                  /*Padding(
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
                          AppLocalizations.of(context).login_screen_sign_up,
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

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginRegister();
                          }));
                        },
                      ),
                    ),
                  )*/
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
