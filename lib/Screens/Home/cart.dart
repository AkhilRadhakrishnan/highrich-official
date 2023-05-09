import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highrich/APICredentials/GuestCart/addAllToCartCredentials.dart';
import 'package:highrich/APICredentials/add_to_cart.dart';
import 'package:highrich/APICredentials/updatecart_credential.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/Home/bottomNavScreen.dart';
import 'package:highrich/Screens/Home/profile.dart';
import 'package:highrich/Screens/delivery_address.dart';
import 'package:highrich/database/database.dart';
import 'package:highrich/entity/CartEntity.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/model/cart_model.dart';
import 'package:highrich/model/default_model.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login.dart';
import '../product_detail_page.dart';
import '../progress_hud.dart';
import 'home_screen.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:http/http.dart' as http;

/*
 *  2021 Highrich.in
 */
class CartPage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  bool deleteNoDeliverableBtnFlag;
  List<String> cartItemIds;

  CartPage(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false,
      this.deleteNoDeliverableBtnFlag,
      this.cartItemIds})
      : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var cartDao;
  String token;
  var database;
  String userId;
  int stockValue;
  int countTest = 0;
  String cartId = "";
  int itemsCount = 0;
  double totalHRP = 0;
  double discount = 0;
  double totalMRP = 0;
  String _discount = "";
  int guestCartCount = 0;
  Cart cart = new Cart();
  bool isLoading = false;
  bool outOfStock = false;
  bool isPullDown = false;
  String actualPrice = "";
  String productName = "";
  int itemListingCount = 0;
  String currentPrice = "";
  List<String> cartItemIds;
  String itemToalAmount = "";
  List selectedQuantity = [];
  bool deleteNoDeliverableBtnFlag;
  PersistentTabController _controller;
  List<CartItems> cartList = new List();
  List<CartItems> cartStoreList = new List();
  List<CartItems> cartSellerList = new List();
  String CHANNEL_NAME = "cartCount_event";
  List<CartItems> cartListTemp = new List();
  RemoteDataSource _apiResponse = RemoteDataSource();
  List<ProcessedPriceAndStocks> unitsList = new List();
  ProcessedPriceAndStocks selectedUnit = new ProcessedPriceAndStocks();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<DropdownMenuItem<ProcessedPriceAndStocks>> buildDropDownMenuItems(
      List listItems) {
    List<DropdownMenuItem<ProcessedPriceAndStocks>> items = List();
    for (ProcessedPriceAndStocks listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem.quantity + " " + listItem.unit,
            style: TextStyle(
                color: Colors.black, fontFamily: 'Poppins', fontSize: 14),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  void _onRefresh() async {
    isPullDown = true;
    _loadToken();
  }

  @override
  void initState() {
    _loadToken();
    deleteNoDeliverableBtnFlag = widget.deleteNoDeliverableBtnFlag;
    cartItemIds = widget.cartItemIds;
    DartNotificationCenter.subscribe(
        channel: 'LOGIN',
        observer: this,
        onNotification: (result) {
          _loadToken();
        });
    DartNotificationCenter.subscribe(
        channel: "NON_DELIVERABLE_BUTTON",
        observer: this,
        onNotification: (result) {
          setState(() {
            cartItemIds = result;
            deleteNoDeliverableBtnFlag = false;
          });
          getCart();
        });
    if (cartItemIds != null) {
      if (cartItemIds.length > 0) {
        setState(() {
          deleteNoDeliverableBtnFlag = true;
        });
      } else {
        setState(() {
          deleteNoDeliverableBtnFlag = false;
        });
      }
    }

    DartNotificationCenter.subscribe(
        channel: "GET_ALL_CART",
        observer: this,
        onNotification: (result) async {
          cartList.clear();
          cartDao = database.cartDao;
          List<CartEntity> resultEntity = await cartDao.getGuestCart();
          List<String> cartListTemp = new List();
          cartListTemp = resultEntity.map((e) => e.itemsInCart).toList();

          Map<String, dynamic> userMap;
          cartListTemp.map((e) => null);
          for (int i = 0; i < cartListTemp.length; i++) {
            Map<String, dynamic> userMap = jsonDecode(cartListTemp[i]);

            CartItems cartItemModel = CartItems.fromJson(userMap);
            AddAllToCartCredentials addAllToCartCredentials =
                new AddAllToCartCredentials();
            addAllToCartCredentials.productId = cartItemModel.productId;
            addAllToCartCredentials.productName = cartItemModel.productName;
            addAllToCartCredentials.vendorId = cartItemModel.vendorId;
            addAllToCartCredentials.vendorType = cartItemModel.vendorType;
            addAllToCartCredentials.quantity = cartItemModel.quantity;
            addAllToCartCredentials.image = cartItemModel.image;
            addAllToCartCredentials.itemCurrentPrice =
                cartItemModel.itemCurrentPrice;
            addAllToCartCredentials.processedPriceAndStocks =
                cartItemModel.processedPriceAndStocks;
            cartList.add(cartItemModel);
          }

          addAllToCart(cartList);
        });
    // TODO: implement initState
    super.initState();
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

  _loadToken() async {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });

    DartNotificationCenter.subscribe(
        channel: "getCart",
        observer: this,
        onNotification: (result) {
          countTest = countTest + 1;
          print(countTest);
          if (token != null && token != ("null") && token != "") {
            getCart();
          } else {
            getGuestCartCount();
            getGuestCart();
          }
        });
    DartNotificationCenter.subscribe(
        channel: "GET_CART_NON_DELIVERABLE",
        observer: this,
        onNotification: (result) {
          cartItemIds = result;

          if (cartItemIds != null) {
            if (cartItemIds.length > 0) {
              setState(() {
                deleteNoDeliverableBtnFlag = true;
              });
            } else {
              setState(() {
                deleteNoDeliverableBtnFlag = false;
              });
            }
          }

          getCart();
        });
    if (token != null && token != ("null") && token != "") {
      getCart();
    } else {
      getGuestCartCount();
      getGuestCart();
    }
  }

  //Loding products in cart for guest user
  getGuestCart() async {
    cartList.clear();
    cartSellerList.clear();
    cartStoreList.clear();
    cartDao = database.cartDao;
    List<CartEntity> resultEntity = await cartDao.getGuestCart();
    List<String> cartListTemp = new List();
    cartListTemp = resultEntity.map((e) => e.itemsInCart).toList();

    Map<String, dynamic> userMap;
    cartListTemp.map((e) => null);
    for (int i = 0; i < cartListTemp.length; i++) {
      Map<String, dynamic> userMap = jsonDecode(cartListTemp[i]);

      CartItems cartItemModel = CartItems.fromJson(userMap);
      cartList.add(cartItemModel);
    }
    totalHRP = 0.0;
    totalMRP = 0.0;
    discount = 0.0;
    for (int i = 0; i < cartList.length; i++) {
      if (cartList[i].vendorType == "SELLER") {
        setState(() {
          cartSellerList.add(cartList[i]);
        });
      } else {
        setState(() {
          cartStoreList.add(cartList[i]);
        });
      }

      double sellingPrice = cartList[i].itemCurrentPrice.sellingPrice;
      double price = cartList[i].itemCurrentPrice.price;
      int qty = cartList[i].quantity;
      double total = sellingPrice * qty;
      double mrpTotal = price * qty;
      itemsCount = cartList?.length ?? 0;
      cartList[i].totalAmount = total;
      totalHRP = totalHRP + total;
      totalMRP = totalMRP + mrpTotal;
      discount = totalMRP - totalHRP;
    }
    cartList.clear();
    setState(() {
      cartList.addAll(cartSellerList);
      cartList.addAll(cartStoreList);
    });

    setState(() {
      if (cartList.length > 0) {
        itemListingCount = 1;
      } else {
        itemListingCount = 2;
      }
      print(cartList.length);
    });
    if (isPullDown == true) {
      setState(() {
        isPullDown = false;
      });
    }
  }

  Widget getTotalHRP() {
    return Row(
      children: [
        Text(
          "Total HRP",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        Spacer(),
        Text(
          "₹ ",
          style: TextStyle(
              color: Colors.green[800],
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
        Text(
          totalHRP.toStringAsFixed(2),
          style: TextStyle(
              color: Colors.green[800],
              fontWeight: FontWeight.w600,
              fontSize: 16),
        )
      ],
    );
  }

  Widget getTotalDiscount() {
    return Row(
      children: [
        Text(
          "Total Discounts",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        Spacer(),
        Text(
          "₹ ",
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        Text(
          discount.toStringAsFixed(2),
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 15),
        )
      ],
    );
  }

  Widget getTotalMRP() {
    return Row(
      children: [
        Text(
          "Total MRP(" + '$itemsCount' + ")",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        Spacer(),
        Text(
          "₹ ",
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        Text(
          totalMRP.toStringAsFixed(2),
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 15),
        )
      ],
    );
  }

  Widget cartItems(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 12, bottom: 15, right: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Product_Detail_Page(
                  product_id: cartList[index]?.productId,
                ),
              ));
        },
        child: Container(
          child: Column(
            children: [
              cartList[index].vendorType == "SELLER"
                  ? Row(
                      children: [
                        Text("SELLER (COD not available)",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ],
                    )
                  : Row(
                      children: [
                        Text("STORE",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
              Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      if (token != null && token != ("null") && token != "") {
                        deleteSigleItemFromCart(cartList[index].id,
                            cartList[index].productId, index, context);
                      } else {
                        cartList.removeAt(index);
                        await cartDao.clearCartEntity();
                        cartList.forEach((element) async {
                          String jsonCartItemModel = jsonEncode(element);
                          final cart = CartEntity(null, jsonCartItemModel);
                          await cartDao.addToGuestCart(cart);
                        });
                        totalHRP = 0.0;
                        totalMRP = 0.0;
                        discount = 0.0;
                        for (int i = 0; i < cartList.length; i++) {
                          double sellingPrice =
                              cartList[i].itemCurrentPrice.sellingPrice;
                          int qty = cartList[i].quantity;
                          double total = sellingPrice * qty;
                          double price = cartList[i].itemCurrentPrice.price;
                          double mrpTotal = price * qty;
                          cartList[i].totalAmount = total;
                          totalHRP = totalHRP + total;
                          totalMRP = totalMRP + mrpTotal;
                          discount = totalMRP - totalHRP;
                          if (cartList.length > 0) {
                            guestCartCount = cartList[i].quantity;
                            setGuestCartCount(guestCartCount);
                          }
                        }
                        if (cartList.length == 0) {
                          guestCartCount = 0;
                        }
                        setGuestCartCount(guestCartCount);
                        if (cartList.length == 0) {
                          setState(() {
                            itemListingCount = 2;
                          });
                        }

                        DartNotificationCenter.post(
                          channel: CHANNEL_NAME,
                          options: "getCartCountAPI",
                        );
                        setState(() {});
                      }
                    },
                    child: Text(
                      "REMOVE",
                      style: TextStyle(
                        color: cartList[index]?.cartStockFlage
                            ? Colors.orangeAccent.withOpacity(0.9)
                            : Colors.orange,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // ClipRRect(borderRadius: BorderRadius.circular(25),child:Image.network("https://homepages.cae.wisc.edu/~ece533/images/airplane.png",height: 50,width: 50,),),
                  CircleAvatar(
                    radius: 31,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage:
                          NetworkImage(imageBaseURL + cartList[index].image),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                getProductname(index),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: cartList[index]?.cartStockFlage
                                        ? Colors.red
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                            cartList[index]?.outOfStock ?? false
                                ? cartList[index].itemCurrentPrice?.stock != 0
                                    ? Container(
                                        width: 75,
                                        child: Text(
                                          cartList[index]
                                                  .itemCurrentPrice
                                                  .stock
                                                  .toString() +
                                              ' stocks left',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ))
                                    : Container(
                                        child: Text(
                                        'Out of stock',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ))
                                : Container(),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              "Total",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "₹ ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            Text(
                              cartList[index]
                                  .itemCurrentPrice
                                  .sellingPrice
                                  .toStringAsFixed(2)
                                  .toString(),
                              style: TextStyle(
                                  color: cartList[index]?.cartStockFlage
                                      ? colorButtonOrange.withOpacity(0.10)
                                      : colorButtonOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "₹ ",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            Text(
                              cartList[index]
                                  .itemCurrentPrice
                                  .price
                                  .toStringAsFixed(2),
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: cartList[index]?.cartStockFlage
                                      ? Colors.grey.withOpacity(0.10)
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Spacer(),
                            Text(
                              "₹ ",
                              style: TextStyle(
                                  color: cartList[index]?.cartStockFlage
                                      ? Colors.grey.withOpacity(0.10)
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            Text(
                              itemToalAmount != "null"
                                  ? double.parse(itemToalAmount ?? "0")
                                      .toStringAsFixed(2)
                                  : "",
                              style: TextStyle(
                                  color: cartList[index]?.cartStockFlage
                                      ? Colors.grey.withOpacity(0.10)
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    width: 220,
                    child: _dropdownCart(index),
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  Expanded(
                      child: SizedBox(
                          width: 28,
                          height: 38,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: cartList[index].cartStockFlage
                                  ? colorButtonBlue.withOpacity(0.10)
                                  : colorButtonBlue,
                            ),
                            child: TextButton(
                              child: Text(
                                '-',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              onPressed: () {
                                if (cartList[index]?.cartStockFlage == false) {
                                  int qty = 0;
                                  qty = cartList[index]?.quantity;
                                  setState(() async {
                                    if (qty > 1) {
                                      if (token != null &&
                                          token != ("null") &&
                                          token != "") {
                                        cartList[index]?.quantity = qty - 1;
                                        updateCart(cartList[index], "-",
                                            cartList[index]?.quantity);
                                      } else {
                                        cartList[index]?.quantity = qty - 1;
                                        await cartDao.clearCartEntity();
                                        cartList.forEach((element) async {
                                          String jsonCartItemModel =
                                              jsonEncode(element);
                                          final cart = CartEntity(
                                              null, jsonCartItemModel);
                                          await cartDao.addToGuestCart(cart);
                                        });
                                        totalHRP = 0.0;
                                        totalMRP = 0.0;
                                        discount = 0.0;
                                        for (int i = 0;
                                            i < cartList.length;
                                            i++) {
                                          double sellingPrice = cartList[i]
                                              .itemCurrentPrice
                                              .sellingPrice;
                                          int qty = cartList[i].quantity;
                                          double total = sellingPrice * qty;
                                          double price = cartList[i]
                                              .itemCurrentPrice
                                              .price;
                                          double mrpTotal = price * qty;
                                          cartList[i].totalAmount = total;
                                          totalHRP = totalHRP + total;
                                          totalMRP = totalMRP + mrpTotal;
                                          discount = totalMRP - totalHRP;
                                        }
                                        if (guestCartCount > 0) {
                                          guestCartCount = guestCartCount - 1;
                                          setGuestCartCount(guestCartCount);
                                        }

                                        DartNotificationCenter.post(
                                          channel: CHANNEL_NAME,
                                          options: "getCartCountAPI",
                                        );
                                        setState(() {});
                                      }
                                    }
                                  });
                                }
                              },
                            ),
                          ))),
                  SizedBox(
                    child: Center(
                        child: Text(cartList[index]?.quantity.toString())),
                    width: 38,
                  ),
                  Expanded(
                      child: SizedBox(
                          width: 18,
                          height: 38,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: cartList[index].cartStockFlage
                                  ? colorButtonBlue.withOpacity(0.10)
                                  : colorButtonBlue,
                            ),
                            child: TextButton(
                              child: Text(
                                '+',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              onPressed: () {
                                if (cartList[index]?.cartStockFlage == false) {
                                  int qty = 0;
                                  qty = cartList[index]?.quantity;

                                  if (cartList[index].itemCurrentPrice.stock ==
                                      qty) {
                                    Fluttertoast.showToast(
                                        msg: "Out of Stock",
                                        backgroundColor: Color(0xFF42A5F5));
                                  }

                                  setState(() async {
                                    if (cartList[index].itemCurrentPrice.stock >
                                        qty) {
                                      cartList[index]?.quantity = qty + 1;
                                      if (token != null &&
                                          token != ("null") &&
                                          token != "") {
                                        updateCart(cartList[index], "+",
                                            cartList[index]?.quantity);
                                      } else {
                                        await cartDao.clearCartEntity();
                                        cartList.forEach((element) async {
                                          String jsonCartItemModel =
                                              jsonEncode(element);
                                          final cart = CartEntity(
                                              null, jsonCartItemModel);
                                          await cartDao.addToGuestCart(cart);
                                        });
                                        totalHRP = 0.0;
                                        totalMRP = 0.0;
                                        discount = 0.0;
                                        for (int i = 0;
                                            i < cartList.length;
                                            i++) {
                                          double sellingPrice = cartList[i]
                                              .itemCurrentPrice
                                              .sellingPrice;
                                          int qty = cartList[i].quantity;
                                          double total = sellingPrice * qty;
                                          double price = cartList[i]
                                              .itemCurrentPrice
                                              .price;

                                          cartList[i].totalAmount = total;
                                          totalHRP = totalHRP + total;
                                          double mrpTotal = price * qty;
                                          totalMRP = totalMRP + mrpTotal;
                                          discount = totalMRP - totalHRP;
                                        }
                                        if (guestCartCount > 0) {
                                          guestCartCount = guestCartCount + 1;
                                        }
                                        setGuestCartCount(guestCartCount);
                                        DartNotificationCenter.post(
                                          channel: CHANNEL_NAME,
                                          options: "getCartCountAPI",
                                        );
                                        setState(() {});
                                      }
                                    }
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Some items in the cart are out of stock");
                                }
                              },
                            ),
                          )))
                ],
              )
            ],
          ),
        ),
      ),
    );
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
    void choiceAction(String choice) {
      if (choice == Menu.Home) {
        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(context,
            screen: HomePage());
      }
      if (choice == Menu.Cart) {
        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(context,
            screen: ProfilePage());
      }
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(6),
                child: SvgPicture.asset("images/logo_highrich.svg"),
              ),
            ),
            Spacer(),
          ],
        ),
        body: SafeArea(
            child: Container(
          color: Colors.white,
          child: itemListingCount == 1
              ? Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: SmartRefresher(
                          enablePullDown: true,
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          header: MaterialClassicHeader(
                            color: Colors.deepOrange,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: cartList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return cartItems(index);
                            },
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 1.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[400],
                            offset: Offset(10.0, 20.0), //(x,y)
                            blurRadius: 36.0,
                          ),
                        ],
                        // border: Border(
                        //     left: BorderSide(
                        //         color: Colors.green,
                        //         width: 3,
                        //     ),
                        //   ),
                      ),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                              padding:
                                  EdgeInsets.only(top: 10, left: 20, right: 20),
                              child: Column(
                                children: [
                                  getTotalMRP(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  getTotalDiscount(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  getTotalHRP()
                                ],
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Text(
                                "*Additional charges may apply during checkout",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          deleteNoDeliverableBtnFlag
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: InkWell(
                                    onTap: () {
                                      if (cartItemIds.length > 0) {
                                        deleteMultipleFromCart(context);
                                      }
                                    },
                                    child: Container(
                                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      color: Colors.red,

                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12.0, bottom: 12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Remove non deliverable items",
                                              style: (TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 1,
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: InkWell(
                              onTap: () {
                                if (token != null &&
                                    token != ("null") &&
                                    token != "" &&
                                    cartSellerList.length > 0) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.warning_outlined,
                                            color: Colors.red,
                                          ),
                                          Text(" COD not available"),
                                        ],
                                      ),
                                      content: Text(
                                          "Ony ONLINE payment available. Seller products fount in cart."),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("Go back"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).push(
                                              MaterialPageRoute(
                                                settings: RouteSettings(
                                                    name:
                                                        "/DeliveryAddressPage"),
                                                builder: (ctx) =>
                                                    DeliveryAddressPage(),
                                              ),
                                            );
                                          },
                                          child: Text("Proceed"),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (token != null &&
                                    token != ("null") &&
                                    token != "" &&
                                    cartSellerList.length == 0) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      settings: RouteSettings(
                                          name: "/DeliveryAddressPage"),
                                      builder: (context) =>
                                          DeliveryAddressPage(),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage(fromPage: "cart")))
                                      .then((value) {
                                    setState(() {
                                      token = value;
                                    });
                                  });
                                }
                              },
                              child: Container(
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  color: colorButtonOrange,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, bottom: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Proceed to Checkout",
                                          style: (TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white)),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 34,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : itemListingCount == 2
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child:
                                  SvgPicture.asset("images/no_items_cart.svg")),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                              child: Text(
                                  "Looks like you haven't made your choice yet")),
                        ],
                      ),
                    )
                  : Container(),
        )),
        key: _scaffoldkey);
  }

  //Add all guest products to cart when user is login
  Future<DefaultModel> addAllToCart(List<CartItems> cartList) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    userId = preferences.getString("userId");
    var reqBody = Map<String, dynamic>();
    reqBody.addAll({
      "userId": userId,
      "accountType": "customer",
      "cartItems": cartList,
    });
    setState(() {
      isLoading = true;
    });
    Result result = await _apiResponse.addAllToCart(reqBody);
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

  //Cart listing api call
  Future<CartModel> getCart() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cartList.clear();
    cartSellerList.clear();
    cartStoreList.clear();
    if (this.mounted) {
      setState(() {
        isLoading = true;
      });
    }
    // if (isPullDown == false) {
    //   setState(() {
    //     isLoading = true;
    //   });
    // }
    userId = preferences.getString("userId");
    var reqBody = Map<String, dynamic>();
    reqBody.addAll({
      "accountType": "customer",
      "userId": userId,
    });

    Result result = await _apiResponse.getCart(reqBody);
    if (this.mounted) {
      setState(() {
        isLoading = false;
        isPullDown = false;
      });
    }

    _refreshController.refreshCompleted();
    if (result is SuccessState) {
      CartModel cartModel = (result).value;
      if (cartModel.status == "success") {
        cart = cartModel.cart;
        List<ProcessedPriceAndStocks> processedPriceListTmp = new List();
        List outOfStockList = cart.cartItems
            .where((element) => element.outOfStock == true)
            .toList();
        if (outOfStockList.length > 0) {
          setState(() {
            outOfStock = true;
          });
        }

        // Expected: received: with options!!
        DartNotificationCenter.post(
          channel: CHANNEL_NAME,
          options: "getCartCountAPI",
        );
        setState(() {
          cartList = cart.cartItems;
          if (cartList.length > 0) {
            itemListingCount = 1;
          } else {
            itemListingCount = 2;
          }

          cartId = cart?.cartId;
          itemsCount = cartList?.length ?? 0;
          totalHRP = cart?.totalPrice ?? 0.0;
          discount = cart?.totalDiscount ?? 0.0;
          totalMRP = cart?.bagTotal ?? 0.0;
          if (cartItemIds != null) {
            for (int j = 0; j < cartList.length; j++) {
              for (int i = 0; i < cartItemIds.length; i++) {
                if (cartList[j].id == cartItemIds[i]) {
                  cartList[j].cartStockFlage = true;
                }
              }
            }
          }
        });

        for (int i = 0; i < cartList.length; i++) {
          if (cartList[i].vendorType == "SELLER") {
            setState(() {
              cartSellerList.add(cartList[i]);
            });
          } else {
            setState(() {
              cartStoreList.add(cartList[i]);
            });
          }
        }
        cartList.clear();
        setState(() {
          cartList.addAll(cartSellerList);
          cartList.addAll(cartStoreList);
        });
      } else {
        showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      CartModel unAuthoedUser = (result).value;
      showSnackBar("Failed, please try agian later");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("LOGIN", false);
      prefs.setString("token", "");
      prefs.setString("userId", "");
      prefs.setString("pinCode", "");
      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => new BottomNavScreen()));
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

  // Delete an item from cart
  Future<String> deleteSigleItemFromCart(
      String id, String productId, int index, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString("userId");
    String token = preferences.getString("token");
    final apiUrl = baseURL + "user/cart/item/delete";
    Map jsonMap = {
      'id': id,
      'productId': productId,
      'userId': userId,
    };

    final request = http.Request("DELETE", Uri.parse(apiUrl));
    request.headers.addAll(<String, String>{
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    });
    request.body = jsonEncode(jsonMap);
    final response = await request.send();
    setState(() {
      isLoading = false;
    });
    if (response.statusCode != 200) {
      return Future.error("error: status code ${response.statusCode}");
    } else {
      final resp = await response.stream.bytesToString();
      DefaultModel defaultModel = DefaultModel.fromRawJson(resp);
      String status = defaultModel.status;
      if (status == "success") {
        DartNotificationCenter.post(
          channel: "cartCount_event",
          options: "getCart",
        );
        setState(() {
          deleteNoDeliverableBtnFlag = false;
        });
        DartNotificationCenter.post(channel: 'getCart');
        DartNotificationCenter.post(channel: 'DELIVERY_ADDRESS');
        setState(() {
          cartList.removeAt(index);
        });
      }

      return resp;
    }
  }

  // Delete non deliverable products from cart
  Future<String> deleteMultipleFromCart(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString("userId");
    String token = preferences.getString("token");
    final apiUrl = baseURL + "user/cart/items/delete-by-ids";
    Map jsonMap = {'cartItemIds': cartItemIds};
    print("TOKEN : " + token);
    final request = http.Request("DELETE", Uri.parse(apiUrl));
    request.headers.addAll(<String, String>{
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    });
    request.body = jsonEncode(jsonMap);
    final response = await request.send();
    setState(() {
      isLoading = false;
    });
    if (response.statusCode != 200) {
      return Future.error("error: status code ${response.statusCode}");
    } else {
      final resp = await response.stream.bytesToString();
      DefaultModel defaultModel = DefaultModel.fromRawJson(resp);
      String status = defaultModel.status;
      if (status == "success") {
        // getCart();
        setState(() {
          deleteNoDeliverableBtnFlag = false;
        });
        DartNotificationCenter.post(channel: 'getCart');
        DartNotificationCenter.post(channel: 'DELIVERY_ADDRESS');
      } else {}

      return resp;
    }
  }

  //Display snack bar
  void showSnackBar(String message) {
    final snackBarContent = SnackBar(
      //padding: EdgeInsets.only(bottom: 16.0),
      content: Text(message),
      action: SnackBarAction(
          label: 'OK',
          onPressed: () => ScaffoldMessenger.of(context)
              .hideCurrentSnackBar(reason: SnackBarClosedReason.hide)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarContent);
  }

  //To show Product Name
  String getProductname(int index) {
    String key;

    if (cartList.length > 0) {
      key = cartList[index].productName;

      if (cartList[index].totalAmount != null) {
        itemToalAmount = cartList[index].totalAmount.toStringAsFixed(2);
      }
    } else {
      key = "";
    }
    return key;
  }

  //To show Product Name
  String getQty(int index) {
    int key;
    if (cartList.length > 0) {
      key = cartList[index].quantity;
    } else {
      key = 1;
    }
    return key.toString();
  }

  //To show Product Name
  String getCurrentPrice(int index) {
    double key;
    if (cartList.length > 0) {
      key = cartList[index].processedPriceAndStocks[0].sellingPrice;
    } else {
      key = 0.0;
    }
    return key.toString();
  }

  String getActualPrice(int index) {
    double key;
    if (cartList.length > 0) {
      key = cartList[index].processedPriceAndStocks[0].price;
    } else {
      key = 0.0;
    }
    return key.toString();
  }

  String getItemTotalPrice(int index) {
    double key;
    if (cartList.length > 0) {
      key = cartList[index].totalAmount;
    } else {
      key = 0.0;
    }
    return key.toString();
  }

  Future<DefaultModel> addToCart(CartItems cartModel, String from) async {
    int qty = 0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    userId = preferences.getString("userId");
    String productID = cartModel?.productId;
    String vendorId = cartModel?.vendorId;
    String vendorType = cartModel?.vendorType;
    if (from == "-") {
      qty = -1;
    } else if (from == "+") {
      qty = 1;
    } else {
      qty = 1;
    }

    ItemCurrentPrice itemCurrentPriceCredential = new ItemCurrentPrice();
    itemCurrentPriceCredential.serialNumber =
        cartModel.itemCurrentPrice.serialNumber;
    itemCurrentPriceCredential.batchNumbers =
        cartModel.itemCurrentPrice.batchNumbers;
    itemCurrentPriceCredential.variant = cartModel.itemCurrentPrice.variant;
    itemCurrentPriceCredential.quantity = cartModel.itemCurrentPrice.quantity;
    itemCurrentPriceCredential.unit = cartModel.itemCurrentPrice.unit;
    itemCurrentPriceCredential.batchType = cartModel.itemCurrentPrice.batchType;
    itemCurrentPriceCredential.addedDate = cartModel.itemCurrentPrice.addedDate;
    itemCurrentPriceCredential.expiryDate =
        cartModel.itemCurrentPrice.expiryDate;
    itemCurrentPriceCredential.price =
        cartModel.itemCurrentPrice.price.toDouble();
    itemCurrentPriceCredential.discount =
        cartModel.itemCurrentPrice.discount.toDouble();
    itemCurrentPriceCredential.stock = cartModel.itemCurrentPrice.stock;
    itemCurrentPriceCredential.sellingPrice =
        cartModel.itemCurrentPrice.sellingPrice.toDouble();

    print(jsonEncode(itemCurrentPriceCredential));

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
        print(defaultModel.message);
        getCart();
        // _showAlert("Success!",defaultModel.message);
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

  //Api call for update cart
  Future<DefaultModel> updateCart(
      CartItems cartModel, String from, int qty) async {
    UpdateCartCredential updateCartCredential = new UpdateCartCredential();
    updateCartCredential.id = cartModel.id;
    updateCartCredential.productId = cartModel.productId;
    updateCartCredential.cartId = cartId;
    updateCartCredential.quantity = qty;
    ItemCurrentPriceUpdateCart itemCurrentPriceUpdateCart =
        new ItemCurrentPriceUpdateCart();
    itemCurrentPriceUpdateCart.serialNumber =
        cartModel.itemCurrentPrice.serialNumber;
    itemCurrentPriceUpdateCart.batchNumbers =
        cartModel.itemCurrentPrice.batchNumbers;
    itemCurrentPriceUpdateCart.variant = cartModel.itemCurrentPrice.variant;
    itemCurrentPriceUpdateCart.quantity = cartModel.itemCurrentPrice.quantity;
    itemCurrentPriceUpdateCart.unit = cartModel.itemCurrentPrice.unit;
    itemCurrentPriceUpdateCart.price = cartModel.itemCurrentPrice.price;
    itemCurrentPriceUpdateCart.discount = cartModel.itemCurrentPrice.discount;
    itemCurrentPriceUpdateCart.stock = cartModel.itemCurrentPrice.stock;
    itemCurrentPriceUpdateCart.sellingPrice =
        cartModel.itemCurrentPrice.sellingPrice;

    updateCartCredential.itemCurrentPrice = itemCurrentPriceUpdateCart;

    setState(() {
      isLoading = true;
    });

    Result result = await _apiResponse.updateCart(updateCartCredential);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      DefaultModel defaultModel = (result).value;
      if (defaultModel.status == "success") {
        DartNotificationCenter.post(channel: 'getCart');
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

  DropdownButtonHideUnderline _dropdownCart(int index) {
    List<String> guestCartProductIDList = new List();
    bool isAlreadyInCart = false;
    List<DropdownMenuItem<ProcessedPriceAndStocks>> _dropdownMenuItems;
    _dropdownMenuItems =
        buildDropDownMenuItems(cartList[index]?.processedPriceAndStocks);

    //cartList[index]?.itemCurrentPrice=_selectedDropDownMenuItems(_dropdownMenuItems,cartList[index]?.itemCurrentPrice).value;
    selectedUnit = _selectedDropDownMenuItems(
            _dropdownMenuItems, cartList[index]?.itemCurrentPrice)
        .value;
    actualPrice = "₹ " + selectedUnit.price.toString();
    currentPrice = "₹ " + selectedUnit.sellingPrice.toString();
    return DropdownButtonHideUnderline(
      child: DropdownButton(
          value: selectedUnit,
          items: _dropdownMenuItems,
          onChanged: (value) {
            setState(() async {
              cartList[index]?.itemCurrentPrice = value;
              if (token != null && token != ("null") && token != "") {
                updateCart(
                    cartList[index], "dropdown", cartList[index]?.quantity);
              } else {
                await cartDao.clearCartEntity();
                cartList.forEach((element) async {
                  String jsonCartItemModel = jsonEncode(element);
                  final cart = CartEntity(null, jsonCartItemModel);
                  await cartDao.addToGuestCart(cart);
                });
                totalHRP = 0.0;
                totalMRP = 0.0;
                discount = 0.0;
                for (int i = 0; i < cartList.length; i++) {
                  double sellingPrice =
                      cartList[i].itemCurrentPrice.sellingPrice;
                  int qty = cartList[i].quantity;
                  double total = sellingPrice * qty;
                  double price = cartList[i].itemCurrentPrice.price;

                  cartList[i].totalAmount = total;
                  totalHRP = totalHRP + total;
                  double mrpTotal = price * qty;
                  totalMRP = totalMRP + mrpTotal;
                  discount = totalMRP - totalHRP;
                }
                setState(() {});
              }
            });
          }),
    );
  }

  DropdownMenuItem<ProcessedPriceAndStocks> _selectedDropDownMenuItems(
      List<DropdownMenuItem<ProcessedPriceAndStocks>> _dropdownMenuItems,
      ProcessedPriceAndStocks checkValue) {
    for (DropdownMenuItem<ProcessedPriceAndStocks> listItem
        in _dropdownMenuItems) {
      if (listItem.value.serialNumber == checkValue.serialNumber) {
        return listItem;
      }
    }
    return _dropdownMenuItems[0];
  }
}
