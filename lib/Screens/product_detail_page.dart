import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highrich/APICredentials/add_to_cart.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/Home/bottomNavScreen.dart';
import 'package:highrich/Screens/Home/cart.dart';
import 'package:highrich/Screens/Home/profile.dart';
import 'package:highrich/Screens/add_address.dart';
import 'package:highrich/Screens/address.dart';
import 'package:highrich/Screens/delivery_address.dart';
import 'package:highrich/Screens/login.dart';
import 'package:highrich/Screens/pincodeDialog.dart';
import 'package:highrich/Screens/profile_details.dart';
import 'package:highrich/Screens/progress_hud.dart';
import 'package:highrich/Screens/search.dart';
import 'package:highrich/Screens/specification_product_detail.dart';
import 'package:highrich/database/database.dart';
import 'package:highrich/entity/CartEntity.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/general/custom_dialog.dart';
import 'package:highrich/general/default_button.dart';
import 'package:highrich/general/shared_pref.dart';
import 'package:highrich/general/size_config.dart';
import 'package:highrich/model/Address/address_list_model.dart';
import 'package:highrich/model/CartModel/cart_count_model.dart';

import 'package:highrich/model/cart_model.dart';
// import 'package:highrich/model/MyOrders/orders_model.dart';

import 'package:highrich/model/check_availability_model.dart';
import 'package:highrich/model/default_model.dart';
import 'package:highrich/model/deliveryCharge.dart';
import 'package:highrich/model/product_detail_model.dart';
import 'package:highrich/model/subscription_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'edit_address.dart';
import 'edit_delivery_address.dart';

/*
 *  2021 Highrich.in
 */
class Product_Detail_Page extends StatefulWidget {
  String product_id;

  Product_Detail_Page({@required this.product_id});

  @override
  __Product_Detail_PageState createState() => new __Product_Detail_PageState();
}

class __Product_Detail_PageState extends State<Product_Detail_Page> {
  int count;
  var cartDao;
  int qty = 1;
  String token;
  String email;
  String userId;
  int subQty = 1;
  String overview;
  String specification;
  int tabIndex = 0;
  int _current = 0;
  String password;
  double _discount;
  int stockValue = 0;
  String accountType;
  double _actualPrice;
  String pinCode = "";
  String discount = "";
  double _currentPrice;
  double _deliveryCharge;
  String quantity = "";
  String vendorId = "";
  int availability = 0;
  int guestCartCount = 0;
  String productID = "";
  dynamic salesIncentive;
  String vendorType = "";
  String vendor = "";
  String vendorMobile = "";
  String test = "";
  String expDate = "";
  String hintDropDown = "";
  String daysBetweenOrder;
  String productName = "";
  bool isLoading = false;
  bool secureText = true;
  List<Widget> imageSliders;
  bool subscribeFlag = false;
  String actualPrice = "0.0";
  String currentPrice = "0.0";
  CartCountModel cartCountModel;
  bool isLoadingSubscribe = false;
  String stockStatus = "In Stock";
  String pinCodeCheckAvailability = "";
  SharedPref sharedPref = SharedPref();
  var _formKey = GlobalKey<FormState>();
  List<Address> addressList = new List();
  String CHANNEL_NAME = "cartCount_event";
  SubscriptionModel selectedSubscribeValue;
  List<String> specificationsList = new List();
  List<String> sliderImagesListAPI = new List();
  RemoteDataSource _apiResponse = RemoteDataSource();
  List<ProductBatches> productBatchesList = new List();
  List<ProcessedPriceAndStocks> unitsList = new List();
  List<RelatedProducts> relatedProductsList = new List();
  List<SubscriptionModel> subscribeDeliveryList = new List();
  List<RelatedProducts> recentlyViewedProductsList = new List();
  ProductDetailModel productDetailModel = new ProductDetailModel();
  DeliveryCharge deliveryCharge = new DeliveryCharge();
  List<DropdownMenuItem<ProcessedPriceAndStocks>> _dropdownMenuItems;
  ItemCurrentPrice itemCurrentPriceCredential = new ItemCurrentPrice();
  ProcessedPriceAndStocks selectedUnit = new ProcessedPriceAndStocks();
  List<DropdownMenuItem<SubscriptionModel>> _subscribeDropdownMenuItems;
  List<ProcessedPriceAndStocks> processedPriceAndStocksList = new List();
  final GlobalKey<ScaffoldState> _scafolKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<DropdownMenuItem<ProcessedPriceAndStocks>> buildDropDownMenuItems(
      List listItems) {
    List<DropdownMenuItem<ProcessedPriceAndStocks>> items = List();
    for (ProcessedPriceAndStocks listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem.quantity + " " + listItem.unit,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat-Black',
                fontSize: 14),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<SubscriptionModel>> buildSubscribeDropDownMenuItems(
      List listItems) {
    List<DropdownMenuItem<SubscriptionModel>> items = List();
    for (SubscriptionModel listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem.subscriptionValue,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat-Black',
                fontSize: 14),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  // DateTime currentBackPressTime;
  @override
  void initState() {
    super.initState();
    DartNotificationCenter.post(
      channel: "cartCount_event",
      options: "getCart",
    );
    _loadPinCode();
    //selectedQuantity.add("select quantity");
    subscribeDeliveryList.clear();
    subscribeDeliveryList.add(SubscriptionModel("weekly", "7"));
    subscribeDeliveryList.add(SubscriptionModel("1 month", "30"));
    subscribeDeliveryList.add(SubscriptionModel("2 month", "60"));
    subscribeDeliveryList.add(SubscriptionModel("3 month", "90"));
    subscribeDeliveryList.add(SubscriptionModel("4 month", "120"));

    selectedSubscribeValue = subscribeDeliveryList[0];
    daysBetweenOrder = "7";

    _dropdownMenuItems = buildDropDownMenuItems(unitsList);
    _subscribeDropdownMenuItems =
        buildSubscribeDropDownMenuItems(subscribeDeliveryList);

    productID = widget.product_id;
    singleProductDetail();

    selectedUnit.unit = "";
    DartNotificationCenter.subscribe(
        channel: "UPDATE_PIN_CODE",
        observer: this,
        onNotification: (result) {
          _loadPinCode();
        });
    DartNotificationCenter.subscribe(
        channel: "CARTCOUNT_MODEL",
        observer: this,
        onNotification: (result) {
          cartCountModel = result;
        });
  }

  _loadPinCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pinCode = (prefs.getString('pinCode') ?? '');
      token = prefs.getString("token");
    });
  }

  getGuestCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      guestCartCount = prefs.getInt("guestCartCount");
    });
  }

  setGuestCartCount(int guestCartCount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("guestCartCount", guestCartCount);
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
    SizeConfig().init(context);
    return new Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
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
              child: Text(productName,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          Container(
            width: 30,
            margin: EdgeInsets.only(right: 4),
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Searchpage()));
              },
            ),
          ),
          Center(
              child: GestureDetector(
            onTap: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) =>
                      pinCodeDialog(message: "Please wait"));
            },
            child: Text(pinCode != defaultPincode ? pinCode : "",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.w700)),
          )),
          Container(
            margin: EdgeInsets.only(right: 4),
            child: IconButton(
              icon: Icon(
                Icons.my_location,
                color: Colors.blue,
              ),
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) =>
                        pinCodeDialog(message: "Please wait")).then((value) {
                  setState(() {
                    pinCode = value[0];
                  });
                });
              },
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: isLoading
            ? Container(
                height: MediaQuery.of(context).size.height - 300,
                width: MediaQuery.of(context).size.width,
              )
            : count != 0
                ? Container(
                    color: Colors.white,
                    child: ListView(
                      children: [
                        SizedBox(height: getProportionateScreenHeight(25)),
                        Stack(
                          children: [
                            _imageSlider(),
                            Positioned(
                                right: 10,
                                child: IconButton(
                                    onPressed: () {
                                      print(productID);
                                      Share.share(
                                          'https://highrich.in/product-detail/$productID');
                                    },
                                    icon: Icon(Icons.share))),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        _productDetails(),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        _similarProducts(context),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        _relatedProduct(context),
                        SizedBox(height: getProportionateScreenHeight(30)),
                      ],
                    ),
                  )
                : Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child:
                                SvgPicture.asset("images/no_items_image.svg")),
                        SizedBox(
                          height: 20,
                        ),
                        Center(child: Text("No products here!")),
                      ],
                    ),
                  ),
      ),
      key: _scaffoldKey,
    );
  }

//Banner image slider
  Center _imageSlider() {
    return imageSliders != null
        ? Center(
            child: imageSliders?.length > 0
                ? Container(
                    width: MediaQuery.of(context).size.width - 200,
                    color: Colors.white,
                    child: Column(
                      children: [
                        CarouselSlider(
                          items: imageSliders,
                          options: CarouselOptions(
                              autoPlay: imageSliders.length > 1 ? true : false,
                              aspectRatio: 2,
                              viewportFraction: 1,
                              height: 180.0,
                              // enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: sliderImagesListAPI.map((url) {
                            int index = sliderImagesListAPI.indexOf(url);
                            return imageSliders.length > 1
                                ? Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _current == index
                                          ? Colors.deepOrange
                                          : Color(0xFFFFCC80),
                                    ),
                                  )
                                : Container(
                                    width: 8.0,
                                    height: 8.0,
                                  );
                          }).toList(),
                        ),
                      ],
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width - 200,
                    color: Colors.white,
                  ))
        : Center(
            child: Container(),
          );
  }

  setSliderView() {
    setState(() {
      imageSliders = sliderImagesListAPI
          .map((item) => Container(
              child: Image.network(imageBaseURL + item,
                  fit: BoxFit.fill, width: double.infinity)))
          .toList();
    });
  }

  //Product detail UI components
  Padding _productDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                // "djfskl",
                productName ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              )),
              Text(
                stockStatus,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.0,
                    color: stockValue > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Text(
                currentPrice,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                actualPrice,
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              discount.length > 0
                  ? Container(
                      width: 80,
                      height: 30,
                      child: Stack(
                        children: [
                          // SvgPicture.asset(
                          //   'images/OfferBg.svg',
                          //   height: 30,
                          // ),
                          Center(
                            child: Text(
                              discount,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 30,
                    ),
              Spacer(),
              Text(
                "",
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
          SizedBox(height: 12),
          // test == "true"
          //     ? Row(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //           Text(
          //             "Sold-By: " + vendor,
          //             textAlign: TextAlign.left,
          //             style: TextStyle(
          //                 fontSize: 14.0, fontWeight: FontWeight.w600),
          //           ),
          //         ],
          //       )
          //     : Container(),
          // SizedBox(height: 10),
          vendor != null
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Sold By: " + vendor.toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "No.: " + vendorMobile.toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w600),
                        ),
                      ],
                    )
                  ],
                )
              : Container(),
          SizedBox(height: 10),
          Row(
            children: [
              salesIncentive != null
                  ? Container(
                      height: 32,
                      constraints: BoxConstraints(minWidth: 60.0),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(62.0),
                              bottomLeft: Radius.circular(0.0),
                              topLeft: Radius.circular(0.0),
                              topRight: Radius.circular(0.0))),
                      child: Center(
                          child: Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Text("SI: " + salesIncentive.toString() + "     ",
                              style: TextStyle(color: Colors.white)),
                        ],
                      )),
                    )
                  : Container(),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Quantity",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(children: [
            Container(
              height: 40,
              width: 200,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
              ),
              child: dropdown(),
            ),

            Spacer(),
            // Button click to decrease qty
            new minus_button(this),

            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: SizedBox(
                width: 20,
                child: Center(
                  child: Text(
                    qty.toString(),
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ),

            // Button click to increase qty
            new plus_button(this),
          ]),
          SizedBox(height: 15),
          productDetailModel?.product?.source?.serviceLocations[0] !=
                  "All India"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print(
                            productDetailModel.product.source.serviceLocations);
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) =>
                                CheckAvailabilityDialog()).then((value) {
                          pinCodeCheckAvailability = value[0];

                          checkAvailabilityAPI(pinCodeCheckAvailability);
                        });
                      },
                      child: Text(
                        "Check Availability",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: colorButtonBlue,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          productDetailModel.product.source.serviceLocations[0] != "All India"
              ? Row(
                  children: [
                    Expanded(
                      child: availability == 0
                          ? Text(
                              "Please enter PIN code to check delivery options and availability",
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.black),
                            )
                          : availability == 1
                              ? Text(
                                  "Product deliverable in " +
                                      pinCodeCheckAvailability,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w100,
                                      color: Colors.green),
                                )
                              : Text(
                                  "Product not deliverable in " +
                                      pinCodeCheckAvailability,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w100,
                                      color: Colors.red),
                                ),
                    )
                  ],
                )
              : Container(),
          SizedBox(height: 20),
          RaisedButton(
              color: availability == 2
                  ? Colors.grey
                  : stockValue < qty
                      ? Colors.grey
                      : colorButtonOrange,
              onPressed: availability == 2
                  ? () {}
                  : stockValue < qty
                      ? () {}
                      : () async {
                          bool checkConnection =
                              await DataConnectionChecker().hasConnection;
                          if (checkConnection == true) {
                            _moveToCart();
                          } else {
                            _showAlert("No internet connection",
                                "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.");
                          }
                        },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SvgPicture.asset("images/ic_cart_white.svg"),
                    ),
                    Text(
                      stockValue < qty ? "Out of Stock" : "Add to Cart",
                      style: (TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white)),
                    )
                  ],
                ),
              )),
          SizedBox(height: 20),
          token != null && token != ("null") && token != ""
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      if (subscribeFlag == true) {
                        subscribeFlag = false;
                      } else {
                        subscribeFlag = true;
                      }
                    });
                  },
                  child:
                      productDetailModel.product.source.vendorType != "SELLER"
                          ? Row(
                              children: [
                                SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: Theme(
                                    child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                                width: 2.0, color: Colors.grey),
                                            left: BorderSide(
                                                width: 2.0, color: Colors.grey),
                                            right: BorderSide(
                                                width: 2.0, color: Colors.grey),
                                            bottom: BorderSide(
                                                width: 2.0, color: Colors.grey),
                                          ),
                                        ),
                                        child: Checkbox(
                                          value: this.subscribeFlag,
                                          onChanged: (newVal) {
                                            setState(() {
                                              this.subscribeFlag = newVal;
                                            });
                                            getAddress();
                                          },
                                          checkColor: Colors.deepOrange,
                                          activeColor: Colors.white,
                                          focusColor: Colors.white,
                                        ),
                                        width: 20,
                                        height: 20),
                                    data: ThemeData(
                                      unselectedWidgetColor:
                                          Colors.white, // Your color
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Subscribe and Save")
                              ],
                            )
                          : Container(),
                )
              : Container(),
          Container(
            child: Stack(
              children: [
                subscribeFlag
                    ? Column(
                        children: [
                          SizedBox(height: 20),
                          subscribeFlag
                              ? Row(
                                  children: [
                                    Text("Subscribe Quantity"),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        color: Colors.blue,
                                        child: Center(
                                            child: Text(
                                          "-",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                      onTap: () {
                                        if (subQty > 1) {
                                          setState(() {
                                            subQty = subQty - 1;
                                          });
                                        }
                                      },
                                    ),
                                    Container(
                                        width: 35,
                                        height: 35,
                                        child: Center(
                                            child: Text(subQty.toString()))),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          subQty = subQty + 1;
                                        });
                                      },
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        color: Colors.blue,
                                        child: Center(
                                            child: Text(
                                          "+",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                    ),
                                    Spacer()
                                  ],
                                )
                              : Container(),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text("Delivery every"),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1.0, style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                              ),
                            ),
                            child: dropdownSubscribe(),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              FlatButton(
                                color: Colors.deepOrange,
                                textColor: Colors.white,
                                disabledColor: Colors.grey,
                                disabledTextColor: Colors.black,
                                padding: EdgeInsets.all(8.0),
                                splashColor: Colors.deepOrange,
                                onPressed: () async {
                                  Result delivResult =
                                      await _apiResponse.deliveryCharge(
                                          _currentPrice,
                                          selectedUnit.weightInKg * subQty);

                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (delivResult is SuccessState) {
                                    deliveryCharge = (delivResult).value;
                                    if (deliveryCharge.status == "success") {
                                      _deliveryCharge =
                                          deliveryCharge.deliveryCharge;
                                      double total = _currentPrice * subQty +
                                          _deliveryCharge;
                                      SubscriptionSummaryModel
                                          subscriptionSummaryModel =
                                          new SubscriptionSummaryModel();
                                      subscriptionSummaryModel.totalMRP =
                                          _actualPrice * subQty;
                                      subscriptionSummaryModel.totalHRP =
                                          _currentPrice * subQty;
                                      subscriptionSummaryModel.total = total;
                                      subscriptionSummaryModel.deliveryCharge =
                                          _deliveryCharge;
                                      subscriptionSummaryModel.discount =
                                          _discount;

                                      showDeliveryAddressBottomSheet(
                                          context, subscriptionSummaryModel);
                                    }
                                  }
                                },
                                child: Text(
                                  "Subscribe Now",
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
                isLoadingSubscribe
                    ? Center(
                        child: Container(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.deepOrange),
                            )),
                      )
                    : Container(),
              ],
            ),
          ),
          overview != null && overview != ("null") && overview != "" ||
                  specificationsList.length > 0
              ? Container(
                  height: 52,
                  color: Colors.white,
                  child: Center(
                    child: Row(
                      children: [
                        Row(
                          children: [
                            overview != null &&
                                    overview != ("null") &&
                                    overview != ""
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        tabIndex = 0;
                                      });
                                    },
                                    child: Container(
                                      width: 90,
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Spacer(),
                                          Center(
                                            child: Text(
                                              "Description",
                                              style: TextStyle(
                                                  color: tabIndex == 0
                                                      ? Colors.black
                                                      : Colors.black12,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: 90,
                                            height: 2,
                                            alignment: Alignment.bottomCenter,
                                            color: tabIndex == 0
                                                ? Colors.orange
                                                : Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              width: 5,
                            ),
                            specificationsList.length > 0
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        print(specification);
                                        tabIndex = 1;
                                        print("from:PAST");
                                      });
                                    },
                                    child: Container(
                                      width: 120,
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Spacer(),
                                          Center(
                                            child: Text(
                                              "Specifications",
                                              style: TextStyle(
                                                  color: tabIndex != 1
                                                      ? Colors.black12
                                                      : Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: 120,
                                            height: 4,
                                            alignment: Alignment.bottomCenter,
                                            color: tabIndex != 1
                                                ? Colors.white
                                                : Colors.orange,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ))
              : Container(),
          overview != null && overview != ("null") && overview != ""
              ? Container(
                  margin: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(overview),
                      )
                    ],
                  ),
                )
              : Container(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  showDeliveryAddressBottomSheet(
      BuildContext context, SubscriptionSummaryModel subscriptionSummaryModel) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return DeliveryAddressBottomSheet((id) {
            print("Selected AdrzID" + id);
            subscriptionSummaryModel.selectedAddressID = id;
            Navigator.pop(context);
            showSubscriptionSummaryBottomSheet(
                context, subscriptionSummaryModel);
          });
        });
  }

  showSubscriptionSummaryBottomSheet(
      BuildContext context, SubscriptionSummaryModel subscriptionSummaryModel) {
    print("DISCOUNT@ " + subscriptionSummaryModel.discount.toString());
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SubscriptionSummaryBottomSheet(
            subscriptionSummaryModel: subscriptionSummaryModel,
            subscriptionSummaryModelReturn: (value) {
              Navigator.pop(context);
              addSubscription(value.selectedAddressID);
            },
          );
        });
  }

  Container _similarProducts(BuildContext context) {
    return recentlyViewedProductsList.length > 0
        ? Container(
            color: Colors.white,
            // margin: EdgeInsets.only(left: 12.0, top: 14.0, bottom: 6.0),
            height: 350,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0, top: 14),
                      child: Text("Recently Viewed",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                    ),
                    Spacer(),
                  ],
                ),
                Container(
                  height: 280,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentlyViewedProductsList?.length,
                    itemBuilder: (_, index) =>
                        _similarProductsContent(context, index),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ))
        : Container(
            child: SizedBox(
              height: 1,
            ),
          );
  }

  Container _similarProductsContent(BuildContext context, int index) =>
      Container(
        margin: EdgeInsets.only(top: 12, left: 4),
        height: 140,
        width: 180,
        child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey[300], width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            elevation: 0,
            child: new InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Product_Detail_Page(
                        product_id:
                            recentlyViewedProductsList[index].source?.productId,
                      ),
                    ));
              },
              child: Column(
                children: [
                  Container(
                    width: 130,
                    height: 115,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: CachedNetworkImage(
                        imageUrl: (imageBaseURL +
                            recentlyViewedProductsList[index]
                                ?.source
                                ?.images[0]),
                        placeholder: (context, url) => Center(
                            child: new Text(
                          "LOADING...",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w800),
                        )),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6, right: 4),
                      child: Text(
                        recentlyViewedProductsList[index]?.source?.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    child: Row(
                      children: [
                        Text(
                          recentlyViewedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      .sellingPrice !=
                                  null
                              ? '₹ ' +
                                  recentlyViewedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      .sellingPrice
                                      .toStringAsFixed(2)
                                      .toString()
                              : '₹ 0.0',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '₹ ' +
                              recentlyViewedProductsList[index]
                                  ?.source
                                  ?.processedPriceAndStock[0]
                                  .price
                                  .toStringAsFixed(2)
                                  .toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 4),
                    child: Row(
                      children: [
                        Text(
                          recentlyViewedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      .unit
                                      .length >
                                  2
                              ? recentlyViewedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      .quantity
                                      .toString() +
                                  " " +
                                  recentlyViewedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      .unit
                                      .substring(0, 3)
                                      .toString()
                              : recentlyViewedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      .quantity
                                      .toString() +
                                  " " +
                                  recentlyViewedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      .unit
                                      .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 11.0),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Spacer(),
                        Container(
                          width: 80,
                          height: 30,
                          child: Stack(
                            children: [
                              // SvgPicture.asset(
                              //   'images/OfferBg.svg',
                              //   height: 30,
                              // ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  recentlyViewedProductsList[index]
                                          ?.source
                                          ?.processedPriceAndStock[0]
                                          ?.discount
                                          .toStringAsFixed(2)
                                          .toString() +
                                      '% off',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                ),
                              )
                            ],
                          ),
                        ),

                        // IconButton(icon: Icon(Icons.shopping_cart_outlined,color: Colors.deepOrangeAccent,), onPressed: null)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    child: recentlyViewedProductsList[index]
                                .source
                                .processedPriceAndStock
                                .length >
                            0
                        ? Row(
                            children: [
                              Text(
                                "SI:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                    fontSize: 14.0),
                                maxLines: 1,
                              ),
                              Spacer(),
                              Text(
                                // '₹ ' +
                                recentlyViewedProductsList[index]
                                    .source
                                    ?.processedPriceAndStock[0]
                                    ?.salesIncentive
                                    .toStringAsFixed(2)
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                    fontSize: 14.0),
                              )
                            ],
                          )
                        : Container(),
                  ),
                  SizedBox(
                    height: 4,
                  )
                ],
              ),
            )),
      );

  Container _relatedProduct(BuildContext context) {
    return relatedProductsList?.length > 0
        ? Container(
            color: Colors.white,
            // margin: EdgeInsets.only(left: 12.0, top: 14.0, bottom: 6.0),
            height: 380,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0, top: 14),
                      child: Text("Related Products",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                    ),
                    Spacer(),
                  ],
                ),
                Container(
                  height: 310,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: relatedProductsList?.length,
                    itemBuilder: (_, index) =>
                        _RelatedProductsContent(context, index),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ))
        : Container(
            child: SizedBox(
              height: 1,
            ),
          );
  }

  Container _RelatedProductsContent(BuildContext context, int index) =>
      Container(
        margin: EdgeInsets.only(top: 12, left: 4),
        height: 180,
        width: 165,
        child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey[300], width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            elevation: 0,
            child: new InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Product_Detail_Page(
                        product_id:
                            relatedProductsList[index].source?.productId,
                      ),
                    ));
              },
              child: Column(
                children: [
                  Container(
                    width: 130,
                    height: 140,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: CachedNetworkImage(
                        imageUrl: (imageBaseURL +
                            relatedProductsList[index]?.source?.images[0]),
                        placeholder: (context, url) => Center(
                            child: new Text(
                          "LOADING...",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w800),
                        )),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6, right: 4),
                      child: Text(
                        relatedProductsList[index]?.source?.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    child: Row(
                      children: [
                        Text(
                          relatedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      ?.sellingPrice !=
                                  null
                              ? '₹ ' +
                                  relatedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      ?.sellingPrice
                                      .toStringAsFixed(2)
                                      .toString()
                              : "₹ 0.0",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        Spacer(),
                        Text(
                          relatedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      .price !=
                                  null
                              ? '₹ ' +
                                  relatedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      .price
                                      .toStringAsFixed(2)
                                      .toString()
                              : " ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 4),
                    child: Row(
                      children: [
                        Text(
                          relatedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      .unit
                                      .length >
                                  2
                              ? relatedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      .quantity
                                      .toString() +
                                  " " +
                                  relatedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      .unit
                                      .substring(0, 3)
                              : relatedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      .quantity
                                      .toString() +
                                  " " +
                                  relatedProductsList[index]
                                      ?.source
                                      ?.processedPriceAndStock[0]
                                      .unit,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 11.0),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Spacer(),
                        Container(
                          width: 80,
                          height: 30,
                          child: Stack(
                            children: [
                              // SvgPicture.asset(
                              //   'images/OfferBg.svg',
                              //   height: 30,
                              // ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  relatedProductsList[index]
                                          ?.source
                                          ?.processedPriceAndStock[0]
                                          ?.discount
                                          .toStringAsFixed(2)
                                          .toString() +
                                      '% off',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                ),
                              )
                            ],
                          ),
                        ),

                        // IconButton(icon: Icon(Icons.shopping_cart_outlined,color: Colors.deepOrangeAccent,), onPressed: null)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    child: relatedProductsList[index]
                                .source
                                .processedPriceAndStock
                                .length >
                            0
                        ? Row(
                            children: [
                              Text(
                                "SI:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                    fontSize: 14.0),
                                maxLines: 1,
                              ),
                              Spacer(),
                              Text(
                                // '₹ ' +
                                relatedProductsList[index]
                                    .source
                                    ?.processedPriceAndStock[0]
                                    ?.salesIncentive
                                    .toStringAsFixed(2)
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                    fontSize: 14.0),
                              )
                            ],
                          )
                        : Container(),
                  ),
                  SizedBox(
                    height: 4,
                  )
                ],
              ),
            )),
      );

  DropdownButtonHideUnderline dropdown() {
    return DropdownButtonHideUnderline(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton(
            value: selectedUnit,
            items: _dropdownMenuItems,
            onChanged: (value) {
              setState(() {
                selectedUnit = value;
                salesIncentive = selectedUnit.salesIncentive;
                print(salesIncentive);
                actualPrice = "₹ " + value.price.toString();
                currentPrice = "₹ " + value.sellingPrice.toString();
                _currentPrice = value.sellingPrice;
                _actualPrice = value.price;
                stockValue = value.stock;
                DateTime now = DateTime.now();

                var date =
                    DateTime.fromMillisecondsSinceEpoch(value.expiryDate);
                expDate = DateFormat('dd-MM-yyyy').format(date);

                if (value?.discount?.toString() != null &&
                    value?.discount?.toString() != "" &&
                    value?.discount?.toString().isNotEmpty) {
                  _discount = double.parse(value?.discount?.toStringAsFixed(1));
                  discount =
                      value?.discount?.toStringAsFixed(1).toString() + "% off";
                } else {
                  discount = "";
                }
                print(selectedUnit.quantity + " " + selectedUnit.unit);
              });
            }),
      ),
    );
  }

  DropdownButtonHideUnderline dropdownSubscribe() {
    return DropdownButtonHideUnderline(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: DropdownButton(
            value: selectedSubscribeValue,
            items: _subscribeDropdownMenuItems,
            onChanged: (value) {
              setState(() {
                selectedSubscribeValue = value;
                daysBetweenOrder = selectedSubscribeValue.daysBetweenOrder;
              });
            }),
      ),
    );
  }

  //Product listing api call
  Future<ProductDetailModel> singleProductDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    userId = preferences.getString("userId");
    accountType = "customer";
    String pinCode;
    pinCode = preferences.getString("pinCode");

    if (pinCode == null || pinCode == ("null") || pinCode == "") {
      pinCode = "";
    }
    print("PINCODE=======");
    print(pinCode);
    productBatchesList.clear();
    setState(() {
      isLoading = true;
    });

    Result result = await _apiResponse.productDetail(
        userId, accountType, productID, pinCode);
    print(userId);
    print(pinCode);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      productDetailModel = (result).value;
      if (productDetailModel.status == "success") {
        setState(() {
          productDetailModel = (result).value;
          count = productDetailModel.count;

          if (count > 0) {
            relatedProductsList = productDetailModel.relatedProducts;
            recentlyViewedProductsList =
                productDetailModel.recentlyViewedProducts;

            if (productDetailModel.product.source != null) {
              productName = productDetailModel.product.source.name;
              overview = productDetailModel.product.source.overview;
              specification =
                  productDetailModel.product.source.specifications.toString();
              productBatchesList =
                  productDetailModel.product.source.productBatches;
              unitsList =
                  productDetailModel.product.source.processedPriceAndStock;
              selectedUnit = unitsList[0];
              hintDropDown = selectedUnit.quantity + " " + selectedUnit.unit;
              if (selectedUnit.sellingPrice != null) {
                currentPrice = "₹ " +
                    selectedUnit.sellingPrice.toStringAsFixed(2).toString();
                _currentPrice = selectedUnit.sellingPrice;
              } else {
                currentPrice = "₹ 0.0";
                _currentPrice = 0;
              }
              DateTime now = DateTime.now();

              var date =
                  DateTime.fromMillisecondsSinceEpoch(selectedUnit.expiryDate);
              expDate = DateFormat('dd-MM-yyyy').format(date);
              salesIncentive = selectedUnit.salesIncentive;
              actualPrice =
                  "₹ " + selectedUnit.price.toStringAsFixed(2).toString();
              _actualPrice = selectedUnit.price;
              discount =
                  selectedUnit.discount.toStringAsFixed(2).toString() + "% off";
              _discount =
                  double.parse(selectedUnit.discount.toStringAsFixed(2));
              stockValue = selectedUnit.stock;
              sliderImagesListAPI = productDetailModel.product.source.images;
              if (sliderImagesListAPI.length > 0) {
                setSliderView();
              }
              processedPriceAndStocksList =
                  productDetailModel.product.source.processedPriceAndStock;
              productID = productDetailModel.product.source.productId;
              vendorId = productDetailModel.product.source.vendorId;
              vendorType = productDetailModel.product.source.vendorType;
              vendor = productDetailModel?.product?.source?.vendor;
              vendorMobile = productDetailModel?.product?.source?.vendorMobile;

              // RegExp exp = RegExp("[?=.* ?=.*-]");
              // test = exp?.hasMatch(vendor)?.toString();

              _dropdownMenuItems = buildDropDownMenuItems(unitsList);

              if (stockValue > 0) {
                stockStatus = "In Stock";
              } else {
                stockStatus = "Out of Stock";
              }
            }
          }
        });
      } else {
        showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      ProductDetailModel unAuthoedUser = (result).value;
      showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

  //CheckAvailability
  Future<CheckAvailabilityModel> checkAvailabilityAPI(
      String pinCodeCheckAvailability) async {
    setState(() {
      isLoading = true;
    });

    Result result = await _apiResponse.checkAvailabilityAPI(
        productID, pinCodeCheckAvailability);

    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      CheckAvailabilityModel checkAvailabilityModel = (result).value;
      if (checkAvailabilityModel.status == "success") {
        setState(() {
          availability = 1;
        });
      } else {
        setState(() {
          availability = 2;
        });
      }
    } else if (result is UnAuthoredState) {
      CheckAvailabilityModel unAuthoedUser = (result).value;
      showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

//Display snack bar
  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Text(message, style: TextStyle(fontFamily: 'Poppins')),
    ));
  }

  Future<void> _showAlert(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // //Add Subscription api
  Future<DefaultModel> addSubscription(String addressId) async {
    setState(() {
      isLoadingSubscribe = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString("userId");
    String addressId = preferences.getString("addressId");

    var reqBody = Map<String, dynamic>();
    reqBody.addAll({
      "customerId": userId,
      "addressId": addressId,
      "subscriptionTitle": "",
      "image": sliderImagesListAPI[0],
      "productId": productID,
      "productName": productName,
      "quantity": subQty,
      "itemCurrentPrice": selectedUnit,
      "daysBetweenOrder": daysBetweenOrder,
      "period": selectedSubscribeValue.subscriptionValue,
      "deliveryCharge": _deliveryCharge,
      "appType": "Android",
    });
    print(jsonEncode(reqBody));
    Result result = await _apiResponse.addSubscription(reqBody);
    setState(() {
      isLoadingSubscribe = false;
    });

    if (result is SuccessState) {
      DefaultModel defaultModel = (result).value;
      if (defaultModel.status == "success") {
        _showAlert("Success!", defaultModel.message);
        print(defaultModel.message);
      } else {
        showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      DefaultModel unAuthoedUser = (result).value;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("LOGIN", false);
      prefs.setString("token", "");
      prefs.setString("userId", "");
      prefs.setString("pinCode", "");

      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => new BottomNavScreen()));
      showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

  // //Add to cart api
  Future<DefaultModel> addToCart() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    userId = preferences.getString("userId");
    productBatchesList.clear();

    itemCurrentPriceCredential.serialNumber = selectedUnit.serialNumber;
    itemCurrentPriceCredential.batchNumbers = selectedUnit.batchNumbers;
    itemCurrentPriceCredential.variant = selectedUnit.variant;
    itemCurrentPriceCredential.quantity = selectedUnit.quantity;
    itemCurrentPriceCredential.unit = selectedUnit.unit;
    itemCurrentPriceCredential.batchType = selectedUnit.batchType;
    itemCurrentPriceCredential.addedDate = selectedUnit.addedDate;
    itemCurrentPriceCredential.expiryDate = selectedUnit.expiryDate;
    itemCurrentPriceCredential.price = selectedUnit.price.toDouble();
    itemCurrentPriceCredential.weightInKg = selectedUnit.weightInKg;
    if (itemCurrentPriceCredential.discount.toString() != null &&
        itemCurrentPriceCredential.discount.toString() != ("null")) {
      itemCurrentPriceCredential.discount = selectedUnit.discount.toDouble();
    } else {
      itemCurrentPriceCredential.discount = 0;
    }
    itemCurrentPriceCredential.stock = selectedUnit.stock;
    itemCurrentPriceCredential.sellingPrice =
        selectedUnit.sellingPrice.toDouble();
    itemCurrentPriceCredential.salesIncentive = selectedUnit.salesIncentive;
    setState(() {
      isLoading = true;
    });
    print(jsonEncode(itemCurrentPriceCredential));
    Result result = await _apiResponse.addToCart(userId, productID, vendorId,
        vendorType, qty, token, itemCurrentPriceCredential);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      DefaultModel defaultModel = (result).value;
      if (defaultModel.status == "success") {
        DartNotificationCenter.post(
          channel: "cartCount_event",
          options: "getCart",
        );
        DartNotificationCenter.post(channel: 'getCart');
        // showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     builder: (BuildContext context) =>
        //         CustomDialog(message: defaultModel.message));
        Fluttertoast.showToast(
            msg: "Item Added to Cart", backgroundColor: Color(0xFF42A5F5));

        // _showAlert("Success!",defaultModel.message);
        print(defaultModel.message);
      } else {
        showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      DefaultModel unAuthoedUser = (result).value;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("LOGIN", false);
      prefs.setString("token", "");
      prefs.setString("userId", "");
      prefs.setString("pinCode", "");

      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => new BottomNavScreen()));
      showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

  _guestCart() async {
    getGuestCartCount();
    CartItems cartItemModel = new CartItems();
    cartItemModel.productId = productID;
    cartItemModel.productName = productName;
    cartItemModel.vendorId = vendorId;
    cartItemModel.vendorType = vendorType;
    cartItemModel.quantity = qty;
    cartItemModel.image = sliderImagesListAPI[0];
    cartItemModel.itemCurrentPrice = selectedUnit;
    cartItemModel.processedPriceAndStocks = processedPriceAndStocksList;
    String jsonCartItemModel = jsonEncode(cartItemModel);
    print(jsonCartItemModel);

    final cart = CartEntity(null, jsonCartItemModel);
    await cartDao.addToGuestCart(cart);
    Fluttertoast.showToast(
        msg: "Item Added to Cart", backgroundColor: Color(0xFF42A5F5));
    // showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) =>
    //         CustomDialog(message: "Item added to cart"));

    setState(() {
      isLoading = false;
      if (guestCartCount != null) {
        guestCartCount = guestCartCount + qty;
      } else {
        guestCartCount = 1;
      }

      setGuestCartCount(guestCartCount);
    });
    DartNotificationCenter.post(
      channel: "cartCount_event",
      options: "getGuestCart",
    );
    DartNotificationCenter.post(channel: "getCart");
  }

  _moveToCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = await SharedPref.shared.getToken();
    pinCode = prefs.getString('pinCode');
    if (token != null && token != ("null") && token != "") {
      if (pinCode != null && pinCode != ("null") && pinCode != "") {
        if (pinCode == defaultPincode) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) =>
                  pinCodeDialog(message: "Please wait")).then((value) {
            _loadPinCode();
          });
        } else {
          List<String> productIDList =
              cartCountModel.cartItems.map((e) => e.productId).toList();
          List<int> seriesIDList =
              cartCountModel.cartItems.map((e) => e.serialNumber).toList();
          if (productIDList.contains(productID)) {
            if (seriesIDList.contains(selectedUnit.serialNumber)) {
              showToast("Item already exist in the cart");
            } else {
              addToCart();
            }
          } else {
            addToCart();
          }
        }
      }
    } else {
      if (pinCode != null && pinCode != ("null") && pinCode != "") {
        bool isAlreadyInCart = false;
        final database =
            await $FloorAppDatabase.databaseBuilder('app_database.db').build();
        cartDao = database.cartDao;

        setState(() {
          isLoading = true;
        });

        List<CartEntity> resultEntity = await cartDao.getGuestCart();
        List<String> cartListTemp = new List();
        List<CartItems> getCartList = new List();
        List<int> seriesIDList = new List();
        List<String> guestCartProductIDList = new List();
        cartListTemp = resultEntity.map((e) => e.itemsInCart).toList();
        Map<String, dynamic> userMap;
        cartListTemp.map((e) => null);
        for (int i = 0; i < cartListTemp.length; i++) {
          Map<String, dynamic> userMap = jsonDecode(cartListTemp[i]);

          CartItems cartItemModel = CartItems.fromJson(userMap);

          setState(() {
            getCartList.add(cartItemModel);
            guestCartProductIDList.add(cartItemModel.productId);
            seriesIDList.add(cartItemModel.itemCurrentPrice.serialNumber);
          });
        }
        if (guestCartProductIDList.contains(productID)) {
          getCartList.forEach((element) {
            if (element.itemCurrentPrice.serialNumber ==
                selectedUnit.serialNumber) {
              isAlreadyInCart = true;
            }
          });
          if (isAlreadyInCart) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) =>
                    CustomDialog(message: "Item already exist in the cart"));
            setState(() {
              isLoading = false;
            });
          } else {
            _guestCart();
          }
        } else {
          _guestCart();
        }
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) =>
                pinCodeDialog(message: "Please wait")).then((value) {
          _loadPinCode();
        });
      }
    }
  }

  //Address listing api call
  Future<AddressListModel> getAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("userId");

    Result result = await _apiResponse.addressListing(userId);

    if (result is SuccessState) {
      AddressListModel response = (result).value;
      if (response.status == "success") {
        setState(() {
          addressList = response.address;
        });
        addressList.forEach((element) async {
          if (element.primary == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("addressId", element.id);
          }
        });
      } else {
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
}

// Button click to decrease qty
class minus_button extends StatelessWidget {
  __Product_Detail_PageState parent;
  int minus_qty;

  minus_button(this.parent);

  @override
  Widget build(BuildContext context) {
    return new ClipOval(
      child: Material(
        color: colorButtonBlue, // button color
        child: InkWell(
          splashColor: gray_bg, // inkwell color
          child: SizedBox(
              width: 36,
              height: 36,
              child: Icon(Icons.remove, color: Colors.white)),
          onTap: () {
            minus_qty = this.parent.qty;
            this.parent.setState(() {
              if (minus_qty > 1) {
                minus_qty = minus_qty - 1;
                this.parent.qty = minus_qty;
              }
            });
          },
        ),
      ),
    );
  }
}

// Button click to increase qty
class plus_button extends StatelessWidget {
  __Product_Detail_PageState parent;
  int plus_qty;

  plus_button(this.parent);

  @override
  Widget build(BuildContext context) {
    return new ClipOval(
      child: Material(
        color: colorButtonBlue, // button color
        child: InkWell(
          splashColor: colorButtonBlue, // inkwell color
          child: SizedBox(
              width: 36,
              height: 36,
              child: Icon(Icons.add, color: Colors.white)),
          onTap: () {
            plus_qty = this.parent.qty;
            this.parent.setState(() {
              plus_qty = plus_qty + 1;
              this.parent.qty = plus_qty;
            });
          },
        ),
      ),
    );
  }
}

class CheckAvailabilityDialog extends StatelessWidget {
  CheckAvailabilityDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

Widget dialogContent(BuildContext context) {
  String pinCode;
  final node = FocusScope.of(context);

  TextEditingController controllerPnCode = new TextEditingController();
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.only(left: 0.0, right: 0.0),
    child: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 0.0,
                  offset: Offset(0.0, 0.0),
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0, right: 14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 6.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 6.0,
                ),
                new Text("Your Delivery Pincode",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 4,
                ),
                new Text(
                    "Enter your pincode to check availability and faster delivery options",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black26,
                        fontWeight: FontWeight.normal)),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  style: TextStyle(
                      fontFamily: 'Montserrat-Black',
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  //  onSaved: (newValue) => email = newValue,
                  controller: controllerPnCode,
                  inputFormatters: <TextInputFormatter>[
                    new FilteringTextInputFormatter.allow(phoneRegex),
                  ],
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  decoration: InputDecoration(
                    hintText: "Pin Code",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                BlueButton(
                  text: "Submit",
                  press: () async {
                    pinCode = controllerPnCode.text;
                    if (controllerPnCode.text.length == 6) {
                      if (pinCode != null &&
                          pinCode != "" &&
                          pinCode != "null") {
                        Navigator.pop(context, [controllerPnCode.text]);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please enter a valid pincode",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class DeliveryAddressBottomSheet extends StatefulWidget {
  Function(String id) selectedAddressID;

  DeliveryAddressBottomSheet(this.selectedAddressID);

  _DeliveryAddressBottomSheetState createState() =>
      _DeliveryAddressBottomSheetState();
}

class _DeliveryAddressBottomSheetState extends State<DeliveryAddressBottomSheet>
    with SingleTickerProviderStateMixin {
  String pinCode;
  bool isLoading = false;
  List<Address> addressList = new List();
  Address defaultAddressModel = new Address();
  RemoteDataSource _apiResponse = RemoteDataSource();
  String selectedAddressId;

  @override
  void initState() {
    // TODO: implement initState
    DartNotificationCenter.subscribe(
        channel: "SUBSCRIBE_ADDRESS",
        observer: this,
        onNotification: (result) {
          getAddress();
        });
    DartNotificationCenter.post(channel: 'SUBSCRIBE_ADDRESS');
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        constraints: BoxConstraints(maxHeight: 550),
        child: new Wrap(
          children: <Widget>[
            Column(
              children: [
                new ListTile(
                    title: new Text(
                      "Select Address",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onTap: () => {}),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  constraints: BoxConstraints(maxHeight: 450),
                  margin: EdgeInsets.only(left: 14.0, right: 14.0),
                  child: _address(),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ));
  }

  Container _button() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: FlatButton(
          color: Color(0xFFE0E0E0),
          textColor: Colors.grey,
          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
          splashColor: Colors.grey,
          onPressed: () {
            String pageFrom = "subscribe";
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddAddressPage(pageFrom: pageFrom)));
          },
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
    );
  }

  Padding _addressContents(int indexAddress) {
    if (addressList[indexAddress].primary == true) {
      selectedAddressId = addressList[indexAddress].id.toString();
      addressList[indexAddress].primary = false;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedAddressId = addressList[indexAddress].id.toString();
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: (addressList[indexAddress].id == selectedAddressId)
                    ? Colors.redAccent
                    : Colors.transparent),
            borderRadius: new BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, right: 10.0, left: 60.0, bottom: 10.0),
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
                        String pageFrom = "subscribe";
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditAddresspage(
                                    addressModel: addressList[indexAddress],
                                    pageFrom: pageFrom)));
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

  Container _address() {
    return Container(
      child: addressList.length > 0
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: (addressList.length ?? 0) + 1,
              itemBuilder: (_, i) {
                if (i == addressList?.length) {
                  return Center(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            _button(),
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              color: Colors.deepOrange,
                              textColor: Colors.white,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.deepOrange,
                              onPressed: () {
                                widget.selectedAddressID(selectedAddressId);
                              },
                              child: Text(
                                "Continue",
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ],
                        )),
                  );
                } else {
                  return _addressContents(i);
                }
              },
            )
          : Container(
              child: Column(
                children: [
                  Container(
                      height: 100,
                      child: Center(
                          child: SvgPicture.asset("images/no_adrz.svg"))),
                  SizedBox(
                    height: 10,
                  ),
                  Center(child: Text("There is no address at the moment")),
                  SizedBox(
                    height: 10,
                  ),
                  _button()
                ],
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
      key = key + "," + addressLine1;
    }
    if (addressLine2 != null && addressLine2 != "") {
      key = key + "," + addressLine2;
    }
    if (district != null && district != "") {
      key = key + "," + district;
    }
    if (state != null && state != "") {
      key = key + "," + state;
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
          addressList.forEach((element) async {
            if (element.primary == true) {
              defaultAddressModel = element;
              pinCode = defaultAddressModel.pinCode;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("addressId", defaultAddressModel.id);
            }
          });
        });
      } else {
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
}

class SubscriptionSummaryBottomSheet extends StatefulWidget {
  SubscriptionSummaryModel subscriptionSummaryModel;
  Function(SubscriptionSummaryModel subscriptionSummaryModelReturn)
      subscriptionSummaryModelReturn;

  SubscriptionSummaryBottomSheet(
      {this.subscriptionSummaryModel, this.subscriptionSummaryModelReturn});

  @override
  _SubscriptionSummaryBottomSheetState createState() =>
      _SubscriptionSummaryBottomSheetState();
}

class _SubscriptionSummaryBottomSheetState
    extends State<SubscriptionSummaryBottomSheet>
    with SingleTickerProviderStateMixin {
  String pinCode;
  bool isLoading = false;
  List<Address> addressList = new List();

  RemoteDataSource _apiResponse = RemoteDataSource();
  String selectedAddressId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        constraints: BoxConstraints(maxHeight: 400),
        child: new Wrap(
          children: <Widget>[
            Column(
              children: [
                new ListTile(
                    title: new Text(
                      "PRICE DETAILS",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onTap: () => {}),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  constraints: BoxConstraints(maxHeight: 450),
                  margin: EdgeInsets.only(left: 14.0, right: 14.0),
                  child: _priceDetails(),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ));
  }

  Container _priceDetails() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Total MRP",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
              Spacer(),
              Text(
                "₹ ",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
              Text(
                widget.subscriptionSummaryModel.totalMRP
                    .toStringAsFixed(2)
                    .toString(),
                style: TextStyle(
                    color: colorButtonOrange,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
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
              // Text(
              //   "₹ ",
              //   style: (TextStyle(
              //       fontSize: 14.0,
              //       fontWeight: FontWeight.w600,
              //       color: Colors.black)),
              // ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.subscriptionSummaryModel.discount
                          .toStringAsFixed(2)
                          .toString() +
                      " % off",
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
                  widget.subscriptionSummaryModel.totalHRP
                      .toStringAsFixed(2)
                      .toString(),
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
                  widget.subscriptionSummaryModel.deliveryCharge
                      .toStringAsFixed(2)
                      .toString(),
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
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.subscriptionSummaryModel.total
                      .toStringAsFixed(2)
                      .toString(),
                  style: (TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: colorButtonOrange)),
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          FlatButton(
            minWidth: MediaQuery.of(context).size.width,
            color: Colors.deepOrange,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.deepOrange,
            onPressed: () {
              widget.subscriptionSummaryModelReturn(
                  widget.subscriptionSummaryModel);
            },
            child: Text(
              "Continue",
              style: TextStyle(fontSize: 14.0),
            ),
          )
        ],
      ),
    );
  }
}

class SubscriptionSummaryModel {
  String qty;
  String selectedAddressID;
  double totalMRP;
  double discount;
  double deliveryCharge;
  double totalHRP;
  double total;

  SubscriptionSummaryModel(
      {this.qty,
      this.selectedAddressID,
      this.totalMRP,
      this.deliveryCharge,
      this.totalHRP,
      this.total,
      this.discount});
}
