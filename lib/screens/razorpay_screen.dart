import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'dart:io';

import 'package:active_ecommerce_flutter/utils_log.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:active_ecommerce_flutter/repositories/payment_repository.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'expire_login_app.dart';

class RazorpayScreen extends StatefulWidget {
  double amount;
  String payment_type;
  String payment_method_key;

  RazorpayScreen(
      {Key key,
      this.amount = 0.00,
      this.payment_type = "",
      this.payment_method_key = ""})
      : super(key: key);

  @override
  _RazorpayScreenState createState() => _RazorpayScreenState();
}

class _RazorpayScreenState extends State<RazorpayScreen> {
  int _combined_order_id = 0;
  bool _order_init = false;
  bool _isPaymentProcessing = false;

  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(widget.payment_type);

    if (widget.payment_type == "cart_payment") {
      createOrder();
    }
  }

  createOrder() async {
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponse(widget.payment_method_key);

    if (orderCreateResponse.result == false) {
      /*ToastComponent.showDialog(orderCreateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      return;*/
      Utils.logResponse("==${orderCreateResponse.message}");
      if (orderCreateResponse.message.toString().contains("expired")) {
        AuthHelper().clearUserData();
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) =>
                ExpireLoginScreen(msg: orderCreateResponse.message.toString()),
          ),
              (
              route) => false, //if you want to disable back feature set to false
        );
      }else{
        ToastComponent.showDialog(orderCreateResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        Navigator.of(context).pop();
        return;
      }
    }else {
      _combined_order_id = orderCreateResponse.combined_order_id;
      _order_init = true;
      setState(() {});

      print("-----------");
      print(_combined_order_id);
      print(user_id.$);
      print(widget.amount);
      print(widget.payment_method_key);
      print(widget.payment_type);
      print("-----------");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody(),
      ),
    );
  }

  void getData() {
    print('called.........');
    var payment_details = '';

    _webViewController
        .evaluateJavascript("document.body.innerText")
        .then((data) {
      var decodedJSON = jsonDecode(data);
      Utils.logResponse("decodedJSON:\n"+decodedJSON.toString());
      if (Platform.isIOS) {
        Utils.logResponse("Platform iOS= +");
        var responseJSON = decodedJSON;//jsonDecode(decodedJSON);
        Utils.logResponse("iOS responseJSON:\n" + responseJSON.toString());
        if (responseJSON['result'] == false) {
          Toast.show(responseJSON['message'], context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

          Navigator.pop(context);
        } else if (responseJSON['result'] == true) {
          Utils.logResponse("a");
          payment_details = responseJSON['payment_details'];
          onPaymentSuccess(payment_details);
        }
      }else {
        Utils.logResponse("Platform Android ");
        Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
        Utils.logResponse("Android responseJSON:\n" + responseJSON.toString());
        if (responseJSON["result"] == false) {
          Toast.show(responseJSON["message"], context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

          Navigator.pop(context);
        } else if (responseJSON["result"] == true) {
          Utils.logResponse("a");
          payment_details = responseJSON['payment_details'];
          onPaymentSuccess(payment_details);
        }
      }
    });
  }

  onPaymentSuccess(payment_details) async {
    Utils.logResponse("b");

    var razorpayPaymentSuccessResponse = await PaymentRepository()
        .getRazorpayPaymentSuccessResponse(widget.payment_type, widget.amount,
            _combined_order_id, payment_details);

    if (razorpayPaymentSuccessResponse.result == false) {
      Utils.logResponse("c");
      Toast.show(razorpayPaymentSuccessResponse.message, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      Navigator.pop(context);
      return;
    }

    Toast.show(razorpayPaymentSuccessResponse.message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    if (widget.payment_type == "cart_payment") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OrderList(from_checkout: true);
      }));

      /*OneContext().push(MaterialPageRoute(builder: (_) {
        return OrderList(from_checkout: true);
      }));*/
    } else if (widget.payment_type == "wallet_payment") {
      Utils.logResponse("d");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Wallet(from_recharge: true);
      }));
    }
  }

  buildBody() {
    String initial_url =
        "${AppConfig.BASE_URL}/razorpay/pay-with-razorpay?payment_type=${widget.payment_type}&combined_order_id=${_combined_order_id}&amount=${widget.amount}&user_id=${user_id.$}";

    Utils.logResponse("init url");
    Utils.logResponse(initial_url);

    if (_order_init == false &&
        _combined_order_id == 0 &&
        widget.payment_type == "cart_payment") {
      return Container(
        child: Center(
          child: Text(AppLocalizations.of(context).common_creating_order),
        ),
      );
    } else {
      return SizedBox.expand(
        child: Container(
          child: Stack(
            children: [
              
              WebView(
                debuggingEnabled: false,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                  _webViewController.loadUrl(initial_url);
                },
                onWebResourceError: (error) {},
                onPageFinished: (page) {
                  Utils.logResponse("web- "+page.toString());
                  if(page.toString().contains("https://www.meghbelamart.com/api/v2/razorpay/payment")){
                    setState(() {
                      _isPaymentProcessing = true;
                    });
                  }else{
                    setState(() {
                      _isPaymentProcessing = false;
                    });
                  }
                  getData();
                },
              ),
              _isPaymentProcessing
              ?Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Center(
                    child: Text("Payment is processing", textAlign: TextAlign.center,
                        style: TextStyle(color: MyTheme.font_grey)),
                  )
              ):Container(),
            ],
          )
        ),
      );
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        AppLocalizations.of(context).razorpay_screen_pay_with_razorpay,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
