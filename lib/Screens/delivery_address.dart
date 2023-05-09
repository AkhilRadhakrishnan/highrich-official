import 'dart:convert';

import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/add_delivery_address.dart';
import 'package:highrich/Screens/edit_delivery_address.dart';
import 'package:highrich/Screens/payment.dart';
import 'package:highrich/Screens/progress_hud.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/general/shared_pref.dart';
import 'package:highrich/general/size_config.dart';
import 'package:highrich/model/Address/address_list_model.dart';
import 'package:highrich/model/CartModel/delivery_charge_model.dart';
import 'package:highrich/model/cart_model.dart';
import 'package:highrich/model/default_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/*
 *  2021 Highrich.in
 */
class DeliveryAddressPage extends StatefulWidget {
  String cartIdDeliveryAdrz;

  DeliveryAddressPage();

  @override
  _DeliveryAddressPageState createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  var _formKey = GlobalKey<FormState>();
  bool disableContinue = false;
  String email;
  String token;
  String cartId;
  String pinCode;
  String password;
  String addressId;
  int itemsCount = 0;
  double discount = 0;
  double totalMRP = 0;
  double totalHRP = 0;
  double finalTotal = 0;
  Cart cart = new Cart();
  bool isLoading = false;
  int itemListingFlag = 0;
  List<String> cartItemIds;
  double deliveryCharges = 0;
  var vendorDeliveryChargeMap;
  String adrzDefaultAdrz = "";
  String nameDefaultAdrz = "";
  String phoneDefaultAdrz = "";
  String pinCodeDefaultAdrz = "";
  String cartIdDeliveryAdrz = "";
  SharedPref sharedPref = SharedPref();
  List<CartItems> cartList = new List();
  List<Address> addressList = new List();
  List<Address> addressTempList = new List();
  Address defaultAddressModel = new Address();
  RemoteDataSource _apiResponse = RemoteDataSource();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    getCart();

    DartNotificationCenter.subscribe(
      channel: 'NONDELIVERABLE',
      observer: this,
      onNotification: (options) {
        cartItemIds = options;
        DartNotificationCenter.post(
            channel: "GET_CART_NON_DELIVERABLE", options: cartItemIds);
        Navigator.pop(context);
      },
    );

    DartNotificationCenter.subscribe(
        channel: "getCart",
        observer: this,
        onNotification: (result) {
          getCart();
        });

    DartNotificationCenter.subscribe(
        channel: "DELIVERY_ADDRESS",
        observer: this,
        onNotification: (result) {
          getAddress();
        });
  }

  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    SizeConfig().init(context);

    return new Scaffold(
      backgroundColor: Colors.white,
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
              child: Text("Your Address",
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _address(),
            ),
            _bottom(),
          ],
        ),
      ),
      key: _scaffoldkey,
    );
  }

  Container _bottom() {
    return Container(
        height: 290,
        child: Column(
          children: [
            _button(),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 1.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 12.0, right: 12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
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
                        "Total MRP (" + itemsCount.toString() + " items)",
                        style: (TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                      ),
                      Spacer(),
                      Text(
                        "₹ ",
                        style: (TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          totalMRP.toStringAsFixed(2).toString(),
                          style: (TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
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
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                      ),
                      Spacer(),
                      Text(
                        "₹ ",
                        style: (TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          discount.toStringAsFixed(2).toString(),
                          style: (TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
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
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                      ),
                      Spacer(),
                      Text(
                        "₹ ",
                        style: (TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          totalHRP.toStringAsFixed(2).toString(),
                          style: (TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
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
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                      ),
                      Spacer(),
                      Text(
                        "₹ ",
                        style: (TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          deliveryCharges.toStringAsFixed(2).toString(),
                          style: (TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
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
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                      ),
                      Spacer(),
                      Text(
                        "₹ ",
                        style: (TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          finalTotal.toStringAsFixed(2).toString(),
                          style: (TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: colorButtonOrange)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      if (defaultAddressModel != null &&
                          disableContinue == false) {
                        if (defaultAddressModel.id != null &&
                            disableContinue == false) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(name: "/Paymentpage"),
                              builder: (context) => Paymentpage(
                                  nameAdrz: defaultAddressModel.ownerName,
                                  fullAdrz:
                                      deliveryAddress(defaultAddressModel),
                                  pinCodeAdrz: defaultAddressModel.pinCode,
                                  phoneAdrz: defaultAddressModel.phoneNo,
                                  idAdrz: defaultAddressModel.id,
                                  cartIDAdrz: cartIdDeliveryAdrz,
                                  deliveryCharges: deliveryCharges,
                                  finalTotal: finalTotal,
                                  subTotal: totalHRP,
                                  totalPrice: totalMRP,
                                  vendorDeliveryChargeMap:
                                      vendorDeliveryChargeMap),
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Please select a delivery address",
                          );
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "Please select a delivery address",
                        );
                      }
                    },
                    child: Container(
                        color: colorButtonOrange,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Continue",
                                style: (TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white)),
                              )
                            ],
                          ),
                        )),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ));
  }

  Container _address() {
    return Container(
      child: itemListingFlag == 1
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: addressList.length,
              itemBuilder: (_, i) {
                return _addressContents(i, addressList[i]?.primary);
              },
            )
          : itemListingFlag == 2
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    Container(
                        height: 100,
                        child: Center(
                            child: SvgPicture.asset("images/no_adrz.svg"))),
                    SizedBox(
                      height: 10,
                    ),
                    Center(child: Text("There is no address at the moment")),
                    Spacer(),
                  ],
                )
              : Container(),
    );
  }

  Container _button() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddDeliveryAddressPage()));
          },
          child: Container(
            color: Color(0xFFE0E0E0),
            // textColor: Colors.grey,
            padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
            // splashColor: Colors.grey,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SvgPicture.asset("images/ic_add_orange.svg"),
                ),
                Text(
                  "Deliver to another address",
                  style: (TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _addressContents(int indexAddress, bool primary) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          setDefaultAddress(addressList[indexAddress]?.id);
          setState(() {
            disableContinue = false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: (addressList[indexAddress].primary ?? false)
                    ? Colors.redAccent
                    : Colors.transparent),
            borderRadius: new BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, right: 10.0, left: 10.0, bottom: 10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      addressList[indexAddress]?.ownerName,
                      style: (TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      iconSize: 20,
                      icon: new Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditDeliveryAddressPage(
                                    addressModel: addressList[indexAddress])));
                      }),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                addressDetails(indexAddress),
                style: (TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black)),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                addressList[indexAddress]?.pinCode,
                style: (TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black)),
              ),
              SizedBox(
                height: 10.0,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: SvgPicture.asset("images/ic_phone_blue.svg"),
                    ),
                    TextSpan(
                        text: " " + addressList[indexAddress]?.phoneNo,
                        style: new TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  String addressDetails(int indexAddress) {
    String key = "";

    String buildingName = addressList[indexAddress]?.buildingName;
    String addressLine1 = addressList[indexAddress]?.addressLine1;
    String addressLine2 = addressList[indexAddress]?.addressLine2;
    String district = addressList[indexAddress]?.district;
    String state = addressList[indexAddress]?.state;

    if (buildingName != null && buildingName != "") {
      key = key + buildingName;
    }
    if (addressLine1 != null && addressLine1 != "") {
      if (key.length > 0) {
        key = key + "," + addressLine1;
      } else {
        key = key + addressLine1;
      }
    }
    if (addressLine2 != null && addressLine2 != "") {
      if (key.length > 0) {
        key = key + "," + addressLine2;
      } else {
        key = key + addressLine2;
      }
    }
    if (district != null && district != "") {
      if (key.length > 0) {
        key = key + "," + district;
      } else {
        key = key + district;
      }
    }
    if (state != null && state != "") {
      if (key.length > 0) {
        key = key + "," + state;
      } else {
        key = key + state;
      }
    }
    return key;
  }

  String deliveryAddress(Address defaultAddressModel) {
    String key = "";

    String buildingName = defaultAddressModel.buildingName;
    String addressLine1 = defaultAddressModel.addressLine1;
    String addressLine2 = defaultAddressModel.addressLine2;

    if (buildingName != null && buildingName != "") {
      key = key + buildingName;
    }
    if (addressLine1 != null && addressLine1 != "") {
      key = key + "," + addressLine1;
    }
    if (addressLine2 != null && addressLine2 != "") {
      key = key + "," + addressLine2;
    }

    return key;
  }

//Address listing api call
  Future<AddressListModel> getAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("userId");
    setState(() {
      isLoading = true;
    });
    Result result = await _apiResponse.addressListing(userId);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      AddressListModel response = (result).value;
      if (response.status == "success") {
        setState(() {
          addressList = response.address;
          if (addressList.length > 0) {
            itemListingFlag = 1;
          } else {
            itemListingFlag = 2;
          }

          addressList.forEach((element) async {
            if (element.primary == true) {
              defaultAddressModel = element;
              pinCode = defaultAddressModel.pinCode;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("addressId", defaultAddressModel.id);
            }
          });
        });
        getDeliveryCharge();
        getDataFromDeliveryChargeAPI();
      } else {
        setState(() {
          itemListingFlag = 2;
        });
        // showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      AddressListModel unAuthoedUser = (result).value;
      // showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      //showSnackBar("Failed, please try agian later");
    }
  }

  //Default adrz api call
  Future<DefaultModel> setDefaultAddress(String addressId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("userId");
    setState(() {
      isLoading = true;
    });
    print("Address iD" + addressId);
    print("UDI iD" + userId);
    print("Toke" + token);
    Result result = await _apiResponse.setDefaultAddress(userId, addressId);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      DefaultModel response = (result).value;
      if (response.status == "success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("addressId", addressId);
        setState(() {
          for (int j = 0; j < addressList.length; j++) {
            if (addressList[j].id == addressId) {
              defaultAddressModel = addressList[j];
              pinCode = defaultAddressModel.pinCode;
              addressList[j].primary = true;
            } else {
              addressList[j].primary = false;
            }
          }
          getDeliveryCharge();
          getDataFromDeliveryChargeAPI();
        });
      } else {
        // showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      DefaultModel unAuthoedUser = (result).value;
      // showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      //showSnackBar("Failed, please try agian later");
    }
  }

  //Cart listing api call...
  Future<CartModel> getCart() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        isLoading = true;
      });
    }
    String userId = preferences.getString("userId");

    var reqBody = Map<String, dynamic>();
    reqBody.addAll({
      "accountType": "customer",
      "userId": userId,
    });
    Result result = await _apiResponse.getCart(reqBody);

    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
    if (result is SuccessState) {
      CartModel cartModel = (result).value;
      if (cartModel.status == "success") {
        cart = cartModel.cart;
        if (this.mounted) {
          setState(() {
            cartList = cart.cartItems;
            cartId = cart.cartId;
            cartIdDeliveryAdrz = cart.cartId;
            itemsCount = cartList.length;
            totalHRP = cart.totalPrice;
            discount = cart.totalDiscount;
            totalMRP = cart.bagTotal;
            finalTotal = totalHRP;
          });
        }

        getAddress();
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

  //Delivery charge api call
  Future<DeliveryChargeModel> getDeliveryCharge() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString("userId");
    var reqBody = Map<String, dynamic>();
    reqBody.addAll({
      "accountType": "customer",
      "userId": userId,
      "cartId": cartId,
      "pinCode": pinCode,
    });
    print("Delivery charge api params......");
    print(jsonEncode(reqBody));
    Result result = await _apiResponse.getDeliveryCharge(reqBody);

    if (result is SuccessState) {
      DeliveryChargeModel deliveryChargeModel = (result).value;
      if (deliveryChargeModel.status == "success") {
        setState(() {
          deliveryCharges = deliveryChargeModel.priceSummary.deliveryCharge;
          finalTotal = deliveryChargeModel.priceSummary.totalPrice;
        });
        DartNotificationCenter.post(
            channel: "NON_DELIVERABLE_BUTTON", options: null);
      } else {
        String failureType = deliveryChargeModel.failureType;
        if (failureType == "ADDRESS") {
          setState(() {
            disableContinue = true;
          });
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => AddressDelivryPageDialog(
                    message:
                        "Some Items in the cart are cannot be delivered to your selected address, do you want to remove them from cart ?",
                    type: "ADDRESS",
                    cartItemIds: deliveryChargeModel.cartItemIds,
                  ));
        } else if (failureType == "STOCK") {
          setState(() {
            disableContinue = true;
          });
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => AddressDelivryPageDialog(
                    message:
                        "Some Items in the cart out of stock, do you want to remove them from cart ?",
                    type: "STOCK",
                    cartItemIds: deliveryChargeModel.cartItemIds,
                  ));
        }
      }
    } else if (result is UnAuthoredState) {
      DeliveryChargeModel unAuthoedUser = (result).value;
      //  showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      //  showSnackBar("Failed, please try agian later");
    }
  }

  getDataFromDeliveryChargeAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString("userId");
    token = preferences.getString("token");

    final Uri URL = Uri.parse(baseURL + "user/cart/calculate-delivery-charge");
    final response = await http.post(
      URL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
      body: jsonEncode(<String, String>{
        'cartId': cartId,
        'userId': userId,
        'accountType': "customer",
        'pinCode': pinCode
      }),
    );
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body);
      String message = extractedData['message'];
      vendorDeliveryChargeMap = extractedData['vendorDeliveryChargeMap'];
      print("VendorDeliveryChargeMap");
      print(jsonEncode(vendorDeliveryChargeMap));
    }
  }

  //Display snack bar
  void showSnackBar(String message) {
    final snackBarContent = SnackBar(
      // padding: EdgeInsets.only(bottom: 16.0),
      content: Text(message),
      action: SnackBarAction(
          label: 'OK',
          onPressed: () => ScaffoldMessenger.of(context)
              .hideCurrentSnackBar(reason: SnackBarClosedReason.hide)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarContent);
  }
}

class AddressDelivryPageDialog extends StatefulWidget {
  AddressDelivryPageDialog({Key key, this.message, this.type, this.cartItemIds})
      : super(key: key);
  final String message;
  final String type;
  List<String> cartItemIds;

  @override
  _AddressDelivryPageDialogState createState() =>
      _AddressDelivryPageDialogState();
}

class _AddressDelivryPageDialogState extends State<AddressDelivryPageDialog> {
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
                            text: widget.message,
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
                      widget.type == "ADDRESS"
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
                                    border: Border.all(
                                  width: 2.0,
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                )),
                                child: new Text("Change ADDRESS"),
                              ),
                            )
                          : Container(
                              width: 0,
                            ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          // Navigator.pop(context);
                          // Navigator.of(context)
                          //     .popUntil(ModalRoute.withName("/DeliveryAddressPage"));
                          // Navigator.pop(context);

                          DartNotificationCenter.post(
                              channel: "NONDELIVERABLE",
                              options: widget.cartItemIds);

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => CartPage(
                          //           hideStatus: false,
                          //             deleteNoDeliverableBtnFlag: true,
                          //             cartItemIds: cartItemIds)));
                        },
                        child: Container(

                            decoration: BoxDecoration(
                                color: colorButtonOrange,
                                borderRadius: new BorderRadius.circular(5.0)
                            ),
                            child: new Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),

                        )
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
