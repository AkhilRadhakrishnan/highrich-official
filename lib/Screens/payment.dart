import 'dart:convert';

import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/Home/cart.dart';
import 'package:highrich/Screens/address.dart';
import 'package:highrich/Screens/delivery_address.dart';
import 'package:highrich/Screens/payment_success.dart';
import 'package:highrich/Screens/progress_hud.dart';
import 'package:highrich/constants.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/model/PlaceOrderModel/place_order_model.dart';
import 'package:highrich/model/cart_model.dart';
import 'package:highrich/model/default_model.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 *  2021 Highrich.in
 */
enum SingingCharacter { ONLINE, COD }

class Paymentpage extends StatefulWidget {
  String nameAdrz = "";
  String pinCodeAdrz = "";
  String fullAdrz = "";
  String phoneAdrz = "";
  String idAdrz = "";
  String cartIDAdrz = "";
  double deliveryCharges = 0;
  double finalTotal = 0;
  double totalPrice = 0;
  double subTotal = 0;
  var vendorDeliveryChargeMap;

  Paymentpage(
      {@required this.nameAdrz,
      this.fullAdrz,
      this.pinCodeAdrz,
      this.phoneAdrz,
      this.idAdrz,
      this.cartIDAdrz,
      this.deliveryCharges,
      this.finalTotal,
      this.subTotal,
      this.totalPrice,
      this.vendorDeliveryChargeMap});

  @override
  _PaymentpageState createState() => _PaymentpageState();
}

class _PaymentpageState extends State<Paymentpage> {
  bool _hideNavBar;
  int _currVal = 1;
  String cartId = "";
  int itemsCount = 0;
  double discount = 0;
  double totalMRP = 0;
  double totalHRP = 0;
  double subTotal = 0;
  String pinCode = "";
  String orderGroupId;
  String nameAdrz = "";
  String fullAdrz = "";
  String addressId = "";
  double totalPrice = 0;
  String phoneAdrz = "";
  String _currText = '';
  double finalTotal = 0;
  Cart cart = new Cart();
  bool isLoading = false;
  bool isSeller;
  double deliveryCharges = 0;
  var vendorDeliveryChargeMap;
  String paymentMode = "ONLINE";
  Order orderModel = new Order();
  String _selectedPaymentMethod;
  Razorpay _razorpay = Razorpay();
  PersistentTabController _controller;
  List<CartItems> cartList = new List();
  String CHANNEL_NAME = "cartCount_event";
  RemoteDataSource _apiResponse = RemoteDataSource();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  // SingingCharacter _character = SingingCharacter.ONLINEPAY;

  @override
  void initState() {
    nameAdrz = widget.nameAdrz;
    fullAdrz = widget.fullAdrz;
    pinCode = widget.pinCodeAdrz;
    phoneAdrz = widget.phoneAdrz;
    addressId = widget.idAdrz;
    cartId = widget.cartIDAdrz;
    totalPrice = widget.totalPrice;
    subTotal = widget.subTotal;
    deliveryCharges = widget.deliveryCharges;
    finalTotal = widget.finalTotal;
    vendorDeliveryChargeMap = widget.vendorDeliveryChargeMap;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    getCart();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    var body = new Container(
        color: Colors.white,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: [
                _top(),
                Divider(
                  height: 1.0,
                ),
                _bottom()
              ],
            )
            //Your content
          ],
        ));
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_backspace,
                  color: Colors.black,
                ),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text("Payment",
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: body,
      ),
      key: _scaffoldkey,
    );
  }

  Container _top() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 12.0, right: 12.0),
                    child: Text(
                      "Payment Option",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                RadioListTile<String>(
                  dense: true,
                  activeColor: colorOrange,
                  title: const Text(
                    'ONLINE PAY',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  value: "ONLINE",
                  groupValue: paymentMode,
                  controlAffinity: ListTileControlAffinity.trailing,
                  onChanged: (String value) {
                    setState(() {
                      paymentMode = value;
                    });
                  },
                ),
                isSeller == false
                    ? RadioListTile<String>(
                        activeColor: colorOrange,
                        dense: true,
                        title: const Text(
                          'COD',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600),
                        ),
                        value: "COD",
                        groupValue: paymentMode,
                        controlAffinity: ListTileControlAffinity.trailing,
                        onChanged: (String value) {
                          setState(() {
                            paymentMode = value;
                          });
                        },
                      )
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _bottom() {
    return Container(
        padding: const EdgeInsets.only(top: 12, left: 12.0, right: 12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName("/DeliveryAddressPage"));
                    Navigator.pop(context);
                  },
                  child: Text("EDIT CART",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text(
                  "Total MRP (" + itemsCount?.toString() + " " + "items)",
                  style: (TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
                ),
                Spacer(),
                Text(
                  "₹ ",
                  style: (TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    totalMRP?.toStringAsFixed(2)?.toString(),
                    style: (TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: colorButtonOrange)),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Discounts",
                  style: (TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
                ),
                Spacer(),
                Text(
                  "₹ ",
                  style: (TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    discount?.toStringAsFixed(2)?.toString(),
                    style: (TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: colorButtonOrange)),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Total HRP",
                  style: (TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
                ),
                Spacer(),
                Text(
                  "₹ ",
                  style: (TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    totalHRP?.toStringAsFixed(2)?.toString(),
                    style: (TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: colorButtonOrange)),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Delivery Charges",
                  style: (TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
                ),
                Spacer(),
                Text(
                  "₹ ",
                  style: (TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    deliveryCharges.toStringAsFixed(2).toString(),
                    style: (TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: colorButtonOrange)),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Total",
                  style: (TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
                ),
                Spacer(),
                Text(
                  "₹ ",
                  style: (TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    finalTotal?.toStringAsFixed(2).toString(),
                    style: (TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: colorButtonOrange)),
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Deliver To",
                  style: (TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
                ),
                Spacer(),
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "CHANGE DELIVERY ADDRESS",
                      style: (TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: colorButtonBlue)),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Container(
              height: 1.0,
              color: gray_bg,
            ),
            SizedBox(height: 15),
            Container(alignment: Alignment.centerLeft, child: _address()),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                print(pinCode);
                placeOrderAPI(paymentMode);
              },
              child: Container(
                  color: colorButtonOrange,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Place Order",
                          style: (TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white)),
                        )
                      ],
                    ),
                  )),
            ),
            SizedBox(height: 10),
          ],
        ));
  }

  Column _address() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nameAdrz,
          style: (TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Colors.black)),
        ),
        SizedBox(
          height: 4.0,
        ),
        Text(
          fullAdrz,
          style: (TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Colors.black)),
        ),
        SizedBox(
          height: 2.0,
        ),
        Text(
          pinCode,
          style: (TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Colors.black)),
        ),
        SizedBox(
          height: 4.0,
        ),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: SvgPicture.asset("images/ic_phone_blue.svg"),
              ),
              TextSpan(
                  text: " " + phoneAdrz,
                  style: new TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ],
    );
  }

  //Cart listing api call
  Future<CartModel> getCart() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    String userId = preferences.getString("userId");
    var reqBody = Map<String, dynamic>();
    reqBody.addAll({
      "accountType": "customer",
      "userId": userId,
    });
    Result result = await _apiResponse.getCart(reqBody);

    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      CartModel cartModel = (result).value;
      if (cartModel.status == "success") {
        cart = cartModel.cart;

        setState(() {
          cartList = cart.cartItems;
          itemsCount = cartList.length;
          totalHRP = cart.totalPrice;
          discount = cart.totalDiscount;
          totalMRP = cart.bagTotal;
        });

        for (int i = 0; i < cart.cartItems.length; i++) {
          if (cart.cartItems[i].vendorType == "SELLER") {
            setState(() {
              isSeller = true;
            });
            break;
          } else {
            setState(() {
              isSeller = false;
            });
          }
        }
      } else {
        showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      CartModel unAuthoedUser = (result).value;
      showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

  //Place Order api call
  Future<PlaceOrderModel> placeOrderAPI(String paymentMode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    String userId = preferences.getString("userId");

    var reqBody = Map<String, dynamic>();
    reqBody.addAll({
      "customerId": userId,
      "accountType": "customer",
      "paymentMode": paymentMode,
      "appType": "Android",
      "addressId": addressId,
      "cartId": cartId,
      "deliveryCharge": deliveryCharges,
      "totalPrice": finalTotal,
      "subTotal": subTotal,
      "vendorDeliveryChargeMap": vendorDeliveryChargeMap,
      "pinCode": pinCode
    });
    print("HELLOOO WORLD*");
    print(jsonEncode(reqBody));
    Result result = await _apiResponse.placeOrderAPI(reqBody);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      PlaceOrderModel placeOrderModel = (result).value;
      String message = placeOrderModel.message;
      print("******" + message + "******");
      if (placeOrderModel.status == "success") {
        orderGroupId = placeOrderModel.order.orderGroupId;

        setState(() {});

        if (paymentMode == "COD") {
          Navigator.pop(context);
          DartNotificationCenter.post(
            channel: CHANNEL_NAME,
            options: "getCartCountAPI",
          );

          PersistentNavBarNavigator.pushNewScreen(context,
              screen: PaymentSucccessPage(orderModel: placeOrderModel.order),
              withNavBar: false);
        } else {
          String razorPayCustomerId = placeOrderModel.order.razorPayCustomerId;
          String razorPayOrderId = placeOrderModel.order.razorPayOrderId;
          print("razorPayCustomerId:" + razorPayCustomerId);
          print("razorPayOrderId:" + razorPayOrderId);
          orderModel = placeOrderModel.order;
          openCheckout(subTotal, razorPayOrderId, razorPayCustomerId);
        }
      } else {
        String failureType = placeOrderModel.failureType;
        if (failureType == "ADDRESS") {
          Navigator.pop(context);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => addressDialog(
                    message:
                        "Some Items in the cart cannot be delivered to your selected address, do you want to remove them from cart ?",
                    type: "ADDRESS",
                    cartItemIds: placeOrderModel.cartItemIds,
                  ));
        } else if (failureType == "STOCK") {
          Navigator.pop(context);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => addressDialog(
                    message:
                        "Some Items in the cart  out of stock, do you want to remove them from cart ?",
                    type: "STOCK",
                    cartItemIds: placeOrderModel.cartItemIds,
                  ));
        }
      }
    } else if (result is UnAuthoredState) {
      CartModel unAuthoedUser = (result).value;
      showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

  //Display snack bar
  void showSnackBar(String message) {
    GlobalKey<ScaffoldState> _scafolKey = new GlobalKey<ScaffoldState>();
    final snackBarContent = SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: 'OK',
          onPressed: () => ScaffoldMessenger.of(context)
              .hideCurrentSnackBar(reason: SnackBarClosedReason.hide)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarContent);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(
      double subTotal, String order_id, String customer_id) async {
    double amount = subTotal * 100;
    var options = {
      'key': razorpay,
      'amount': amount,
      'name': 'HighRich',
      // 'image':
      //     "https://highrich-dev.s3.amazonaws.com/images/category/a22e1ea6-9a90-44d0-a11b-5bfc9e4efe57.jpg",
      'order_id': order_id,
      //This is a sample Order ID. Pass the `id` obtained in the response of Step 1
      'customer_id': customer_id,
      'description': '',
      'prefill': {'contact': true, 'email': true},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Fluttertoast.showToast(
    //   msg: "SUCCESS: " + response.paymentId,
    //   toastLength: Toast.LENGTH_SHORT,
    // );

    String razorpay_payment_id = response.paymentId;
    String razorpay_signature = response.signature;
    String razorpay_order_id = response.orderId;
    verifyPayment(razorpay_payment_id, razorpay_signature, razorpay_order_id);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment canceled, please try again...",
        toastLength: Toast.LENGTH_SHORT);
    // showSnackBar("Payment failed, please try again...");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "EXTERNAL_WALLET: " + response.walletName,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  //  Payment Verification api
  Future<DefaultModel> verifyPayment(String razorpay_payment_id,
      String razorpay_signature, String razorpay_order_id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");

    setState(() {
      isLoading = true;
    });
    var reqBody = Map<String, dynamic>();
    reqBody.addAll({
      "orderGroupId": orderGroupId,
      "razorpay_payment_id": razorpay_payment_id,
      "razorpay_signature": razorpay_signature,
      "razorpay_order_id": razorpay_order_id,
    });
    Result result = await _apiResponse.verifyPayment(reqBody, token);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      DartNotificationCenter.post(
        channel: CHANNEL_NAME,
        options: "getCartCountAPI",
      );
      DefaultModel defaultModel = (result).value;
      if (defaultModel.status == "success") {
        print(defaultModel.message);
        Navigator.pop(context);
        PersistentNavBarNavigator.pushNewScreen(context,
            screen: PaymentSucccessPage(orderModel: orderModel),
            withNavBar: false);
        print(defaultModel.message);
      } else {
        showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      DefaultModel unAuthoedUser = (result).value;
      showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }
}

class addressDialog extends StatelessWidget {
  addressDialog({Key key, this.message, this.type, this.cartItemIds})
      : super(key: key);
  final String message;
  final String type;
  List<String> cartItemIds;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 18.0,
            ),
            margin: EdgeInsets.only(top: 8.0, right: 8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: new RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Icon(Icons.error_outline,
                                color: Colors.orangeAccent, size: 18),
                          ),
                        ),
                        TextSpan(
                            text: message,
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      type == "ADDRESS"
                          ? InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => DeliveryAddressPage()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    border: Border.all(
                                      width: 2.0,
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                    )),
                                child: new Text("Change ADDRESS"),
                              ),
                            )
                          : Container(),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          DartNotificationCenter.post(
                              channel: "NONDELIVERABLE", options: cartItemIds);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: colorButtonOrange,
                              borderRadius: new BorderRadius.circular(5.0)),
                          child: new Text(
                            "Yes",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
