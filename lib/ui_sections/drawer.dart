import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/change_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/profile.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/wishlist.dart';

import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/messenger_list.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  onTapLogout(context) async {
    AuthHelper().clearUserData();

    // var logoutResponse = await AuthRepository().getLogoutResponse();
    //
    // if (logoutResponse.result == true) {
    //   ToastComponent.showDialog(logoutResponse.message, context,
    //       gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //
    //   Navigator.push(context, MaterialPageRoute(builder: (context) {
    //     return Login();
    //   }));
    // }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Main();
    }), (route) => false);
  }
  _launchURL(String _url) async {
    String url = _url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection:
            app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          //decoration: const BoxDecoration(gradient: MyTheme.gradColor),
          padding: EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                is_logged_in.$ == true
                    ? ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            AppConfig.BASE_PATH + "${avatar_original.$}",
                          ),
                        ),
                        title: Text("${user_name.$}"),
                        subtitle: Text(
                          //if user email is not available then check user phone if user phone is not available use empty string
                          "${user_phone.$ != "" && user_phone.$ != null ? user_phone.$ : ''}",
                        ))
                    : Text(
                        AppLocalizations.of(context).main_drawer_not_logged_in,
                        style: TextStyle(
                            color: MyTheme
                                .font_grey, //Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 14)),
                Divider(),
                /*ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset(
                      "assets/language.png",
                      height: 16,
                      color: MyTheme.font_grey, //Color.fromRGBO(153, 153, 153, 1)
                    ),
                    title: Text(
                        AppLocalizations.of(context)
                            .main_drawer_change_language,
                        style: TextStyle(
                            color: MyTheme
                                .font_grey, //Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ChangeLanguage();
                      }));
                    }),*/
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset(
                      "assets/home.png",
                      height: 16,
                      color: MyTheme.font_grey, //Color.fromRGBO(153, 153, 153, 1)
                    ),
                    title: Text(AppLocalizations.of(context).main_drawer_home,
                        style: TextStyle(
                            color: MyTheme
                                .font_grey, //Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Main();
                      }));
                    }),
                is_logged_in.$ == true
                    ? Column(
                        children: [
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset(
                                "assets/profile.png",
                                height: 16,
                                color: MyTheme
                                    .font_grey, //Color.fromRGBO(153, 153, 153, 1)
                              ),
                              title: Text(
                                  AppLocalizations.of(context)
                                      .main_drawer_profile,
                                  style: TextStyle(
                                      color: MyTheme
                                          .font_grey, //Color.fromRGBO(153, 153, 153, 1),
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Profile(show_back_button: true);
                                }));
                              }),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset(
                                "assets/order.png",
                                height: 16,
                                color: MyTheme
                                    .font_grey, //Color.fromRGBO(153, 153, 153, 1)
                              ),
                              title: Text(
                                  AppLocalizations.of(context)
                                      .main_drawer_orders,
                                  style: TextStyle(
                                      color: MyTheme
                                          .font_grey, //Color.fromRGBO(153, 153, 153, 1),
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return OrderList(from_checkout: false);
                                }));
                              }),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset(
                                "assets/heart.png",
                                height: 16,
                                color: MyTheme
                                    .font_grey, //Color.fromRGBO(153, 153, 153, 1)
                              ),
                              title: Text(
                                  AppLocalizations.of(context)
                                      .main_drawer_my_wishlist,
                                  style: TextStyle(
                                      color: MyTheme
                                          .font_grey, //Color.fromRGBO(153, 153, 153, 1),
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Wishlist();
                                }));
                              }),
                          /*ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset(
                                "assets/chat.png",
                                height: 16,
                                color: MyTheme
                                    .white, //Color.fromRGBO(153, 153, 153, 1)
                              ),
                              title: Text(
                                  AppLocalizations.of(context)
                                      .main_drawer_messages,
                                  style: TextStyle(
                                      color: MyTheme
                                          .font_grey, //Color.fromRGBO(153, 153, 153, 1),
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MessengerList();
                                }));
                              }),*/
                          ListTile(
                              visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                              leading: Icon(Icons.compare),
                              title: Text(
                                  "Compare",
                                  style: TextStyle(
                                      color: MyTheme
                                          .font_grey, //Color.fromRGBO(153, 153, 153, 1),
                                      fontSize: 14)),
                              onTap: () {


                              }),
                          ListTile(
                              visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                              leading: Icon(Icons.privacy_tip_outlined),
                              title: Text(
                                  "Privacy policy",
                                  style: TextStyle(
                                      color: MyTheme
                                          .font_grey, //Color.fromRGBO(153, 153, 153, 1),
                                      fontSize: 14)),
                              onTap: () {

                                _launchURL(AppConfig.BASE_privacy_policy);
                              }),
                          ListTile(
                              visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                              leading: Icon(Icons.security),
                              title: Text(
                                  "Terms of use",
                                  style: TextStyle(
                                      color: MyTheme
                                          .font_grey, //Color.fromRGBO(153, 153, 153, 1),
                                      fontSize: 14)),
                              onTap: () {
                                _launchURL(AppConfig.BASE_terms);
                              }),
                          ListTile(
                              visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                              leading: Icon(Icons.policy_outlined),
                              title: Text(
                                  "Refund policy",
                                  style: TextStyle(
                                      color: MyTheme
                                          .font_grey, //Color.fromRGBO(153, 153, 153, 1),
                                      fontSize: 14)),
                              onTap: () {
                                _launchURL(AppConfig.BASE_refund_policy);
                              }),
                          wallet_system_status.$
                              ? ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  leading: Image.asset(
                                    "assets/wallet.png",
                                    height: 16,
                                    color: MyTheme
                                        .font_grey, //Color.fromRGBO(153, 153, 153, 1)
                                  ),
                                  title: Text(
                                      AppLocalizations.of(context)
                                          .main_drawer_wallet,
                                      style: TextStyle(
                                          color: MyTheme
                                              .font_grey, //Color.fromRGBO(153, 153, 153, 1),
                                          fontSize: 14)),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Wallet();
                                    }));
                                  })
                              : Container(),
                        ],
                      )
                    : Container(),
                Divider(height: 24),
                is_logged_in.$ == false
                    ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset(
                          "assets/login.png",
                          height: 16,
                          color:
                              MyTheme.font_grey, //Color.fromRGBO(153, 153, 153, 1)
                        ),
                        title: Text(
                            AppLocalizations.of(context).main_drawer_login,
                            style: TextStyle(
                                color: MyTheme
                                    .font_grey, //Color.fromRGBO(153, 153, 153, 1),
                                fontSize: 14)),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Login();
                          }));
                        },
                      )
                    : Container(),
                is_logged_in.$ == true
                    ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset(
                          "assets/logout.png",
                          height: 16,
                          color:
                              MyTheme.font_grey, //Color.fromRGBO(153, 153, 153, 1)
                        ),
                        title: Text(
                            AppLocalizations.of(context).main_drawer_logout,
                            style: TextStyle(
                                color: MyTheme
                                    .font_grey, //Color.fromRGBO(153, 153, 153, 1),
                                fontSize: 14)),
                        onTap: () {
                          onTapLogout(context);
                        })
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
