import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Screens/Home/bottomNavScreen.dart';
import 'package:highrich/Screens/Home/home_screen.dart';
import 'package:highrich/Screens/Home/profile.dart';
import 'package:highrich/Screens/payment.dart';
import 'package:highrich/Screens/progress_hud.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/general/shared_pref.dart';
import 'package:highrich/general/size_config.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
// import 'package:pdf/widgets/barcode.dart';
import 'package:highrich/Screens/my_orders.dart';

import 'package:highrich/model/PlaceOrderModel/place_order_model.dart';
import 'package:intl/intl.dart';
import 'add_address.dart';
/*
 *  2021 Highrich.in
 */
class PaymentSucccessPage extends StatefulWidget {
  Order orderModel;

  PaymentSucccessPage({@required this.orderModel});

  @override
  _PaymentSucccessPageState createState() => _PaymentSucccessPageState();
}

class _PaymentSucccessPageState extends State<PaymentSucccessPage> {
  String email;
  int count = 7;
  var orderDate;
  String password;
  Order orderModel;
  bool secureText = true;
  bool isLoading = false;
  SharedPref sharedPref = SharedPref();
  var _formKey = GlobalKey<FormState>();
  String CHANNEL_NAME = 'cartCount_event';
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  void _toggleSecure() {
    setState(() {
      secureText = !secureText;
    });
  }

  RemoteDataSource _apiResponse = RemoteDataSource();
  DateTime currentBackPressTime;
  void initState() {
    super.initState();
    orderModel=widget.orderModel;
    print("ORDRMOEL");
    print(orderModel.subTotal.toStringAsFixed(2),);
    String orderGroupId=orderModel.orderGroupId;
    String orGroupId=orderGroupId;

    DateTime now = DateTime.now();

    var date = DateTime.fromMillisecondsSinceEpoch(orderModel?.orderedDate);
    orderDate = DateFormat('dd-MM-yyyy').format(date);

  }

  Future<bool> onWillPop() {
    DartNotificationCenter.unregisterChannel(channel: 'LOGIN');
    DartNotificationCenter.unregisterChannel(channel: 'cartCount_event');

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        BottomNavScreen()), (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
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
        body: WillPopScope(child: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  _top(),
                  Container(
                    height: 1.0,
                    width: MediaQuery.of(context).size.width,
                    color: gray_bg,
                  ),
                  _bottom(),
                ],
              ),
            ),
          ),
        ), onWillPop: onWillPop),
        key: _scaffoldkey,
      ),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
  }



  Container _top() {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0),
      // height: MediaQuery.of(context).size.height * 0.90,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          FlutterTicketWidget(
          width: 350,
          height: 500,
          color: Colors.grey[200],
          isCornerRounded: true,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  <Widget>[
                    Container(
                      width: 120,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(width: 1, color: Colors.green)
                      ),
                      child: Center(
                        child: Text(
                          'Order Confirmed',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        // Text(
                        //   'SLM',
                        //   style: TextStyle(
                        //       color: Colors.black,
                        //       fontWeight: FontWeight.bold
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.orange,
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8),
                        //   child: Text(
                        //     'BTL',
                        //     style: TextStyle(
                        //         color: Colors.black,
                        //         fontWeight: FontWeight.bold
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Order Details',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Text("Date",
                          style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold
                    ),
                    ),
                          SizedBox(width: 90,),
                          Text("Order ID",
                          style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold
                    ),
                    )
                      ],
                      ),
                      SizedBox(height: 2,),
                      
                       Row(
                        children: [
                          Text(orderDate.toString(),
                          style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    ),
                          SizedBox(width: 54,),
                          Text(orderModel.orderGroupId,
                          style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    ),
                      ], 
                      ),
                      SizedBox(height: 10,),
                       Row(
                        children: [
                          Text("Payment",
                          style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold
                    ),
                    ),
                          SizedBox(width: 63,),
                    //       Text("Status",
                    //       style: TextStyle(
                    //   color: Colors.grey[600],
                    //   fontWeight: FontWeight.bold
                    // ),
                    // )
                      ],
                      ),
                      
                      
                      SizedBox(height: 2,),
                      Row(
                        children: [
                          Text(orderModel.paymentMode,
                          style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    ),
                          SizedBox(width: 95,),
                    //       Text(orderModel.orderStatus,
                    //       style: TextStyle(
                    //   color: Colors.black,
                    //   fontWeight: FontWeight.bold,
                    //   fontSize: 12,
                    // ),
                    // ),
                          
                      ],
                      ),
                      
                      SizedBox(height: 10,),
                      Row(children: [
                        Text("Delivery address",
                        style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold
                    ),
                    )
                      ],),
                      SizedBox(height: 2,),
                       Row(
                        children: [
                          SizedBox(width: 0,),
                          Container(
                            height: 60,
                            width: 250,
                            child: Text(
                             addressDetails(),
                             maxLines: 3,
                             style: (TextStyle(
                                 fontSize: 12.0,
                                 fontWeight: FontWeight.bold,
                                 color: Colors.black)),
                           ),
                          ),
                      ],
                      ),
                      
                    ],
                    
                  ),
                ),
                  
              //   Container(
              //   height: 50,
              //   width: 50,
              //   child: BarcodeWidget(
              //     barcode: Barcode.qrCode(),
              //     data: 'https://play.google.com/store/apps/details?id=com.app.highrich',
                  
              //   ),
                
              // ),
                // ),
                SizedBox(height: 12,),
                
                Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                       color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                     child: ListView.builder(
                      //  scrollDirection: Axis.vertical,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderModel.orderedItems.length,
                    itemBuilder: (_, index) {
                      return _buildBoxProducts(index);
                    },
                  ),
                  ),
                

                // Padding(
                //   padding: const EdgeInsets.only(top: 10, left: 75, right: 75),
                //   child: Text(
                //     'Thanks for your Order',
                //     style: TextStyle(
                //       color: Colors.orange,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // )
                
              ],
            ),
          ),
        ),
         Container(height: 2,),
          // Text(
          //   "Your Order is confirmed.",
          //   style: (TextStyle(
          //       fontSize: 22.0,
          //       fontWeight: FontWeight.w400,
          //       color: Colors.lightGreen)),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 16.0),
          //   child: Row(
          //     children: <Widget>[
          //       new Expanded(
          //         child: new Text(
          //           "Order Date",
          //           style: (TextStyle(color: Colors.grey)),
          //         ),
          //         flex: 1,
          //       ),
          //       new Expanded(
          //         child: new Text(
          //           "Order ID",
          //           style: (TextStyle(color: Colors.grey)),
          //         ),
          //         flex: 1,
          //       ),
          //       SizedBox(width: 5,),
          //       new Expanded(
          //         child: new Text(
          //           "Payment",
          //           style: (TextStyle(color: Colors.grey)),
          //         ),
          //         flex: 1,
          //       )
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 6.0),
          //   child: Row(
          //     children: <Widget>[
          //       new Expanded(
          //         child: new Text(
          //           orderDate.toString(),
          //           style: (TextStyle(color: Colors.black,fontWeight: FontWeight.w600)),
          //         ),
          //         flex: 1,
          //       ),
          //       new Expanded(
          //         child: new Text(
          //           orderModel.orderGroupId,
          //           style: (TextStyle(color: Colors.black,fontWeight:FontWeight.w600)),
          //         ),
          //         flex: 1,
          //       ),
          //       SizedBox(width: 5,),
          //       new Expanded(
          //         child: new Text(
          //           orderModel?.paymentMode,
          //           style: (TextStyle(color: Colors.grey,fontWeight:FontWeight.w600)),
          //         ),
          //         flex: 1,
          //       )
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 16.0),
          //   child: Text(
          //     "Delivery Address",
          //     style: (TextStyle(color: Colors.grey)),
          //   ),
          // ),
          // Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //   SizedBox(height: 6),
          //   Text(
          //     addressDetails(),
          //     style: (TextStyle(
          //         fontSize: 12.0,
          //         fontWeight: FontWeight.w400,
          //         color: Colors.black)),
          //   ),
          //   SizedBox(height: 6),
          //   RichText(
          //     text: TextSpan(
          //       children: [
          //         WidgetSpan(
          //           child: SvgPicture.asset("images/ic_phone_blue.svg"),
          //         ),
          //         TextSpan(
          //             text: " "+orderModel.shippingAddress.phoneNo,
          //             style: new TextStyle(color: Colors.black)),
          //       ],
          //     ),
          //   ),
          //   SizedBox(height: 16),
          // ]),
          // Container(
          //   height: 1.0,
          //   width: MediaQuery.of(context).size.width,
          //   color: gray_bg,
          // ),
          // Container(
          //   height: (50 * count.toDouble()),
          //   width: MediaQuery.of(context).size.width,
          //   child: ListView.builder(
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemCount: orderModel.orderedItems.length,
          //     itemBuilder: (_, index) {
          //       return _buildBoxProducts(index);
          //     },
          //   ),
          // )
        ],
      ),
    );
  }



  Widget _buildBoxProducts(int index) => Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(height: 10),
          Row(
            children: [
                Container(
                  width: 220,
                  child: Text(
                  orderModel?.orderedItems[index]?.productName,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
              ),
                ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(
                  "₹",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[400],
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                orderModel?.orderedItems[index]?.itemCurrentPrice?.sellingPrice?.toStringAsFixed(2).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[400],
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                orderModel?.orderedItems[index]?.itemCurrentPrice?.quantity.toString()+" "+orderModel?.orderedItems[index]?.itemCurrentPrice?.unit.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(width: 6),
              Text(
                "Qty:"+orderModel?.orderedItems[index]?.quantity.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              ),
            ],
          )
        ]),
      );

  Container _bottom() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.28,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, left: 16.0, right: 16.0),
          child: Column(
            children: [
              SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    // "Total MRP ("+orderModel?.orderedItems.length.toString()+" items)",
                    "Sub Total(Inclusive of Tax)",
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
                      orderModel.subTotal.toStringAsFixed(2),
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
                    "Total tax",
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
                      orderModel?.totalTax?.toStringAsFixed(2)?.toString(),
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
                      orderModel?.deliveryCharge?.toStringAsFixed(2)?.toString(),
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
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      orderModel?.totalPrice?.toStringAsFixed(2),
                      style: (TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          color: colorButtonOrange)),
                    ),
                  )
                ],
              ),
              SizedBox(height: 12),
              RaisedButton(
                  color: colorButtonOrange,
                  onPressed: (){
                    onWillPop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Continue Shopping",
                          style: (TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white)),
                        )
                      ],
                    ),
                  )),
                  // ElevatedButton(
                  // // color: colorButtonOrange,
                  // onPressed: (){
                  //    Navigator.push(
                  //                     context,
                  //                     MaterialPageRoute(
                  //                         builder: (context) => MyOrders(tabIndex: 0,)));
                  // },
                  // child: Padding(
                  //   padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         "My Orders",
                  //         style: (TextStyle(
                  //             fontSize: 14.0,
                  //             fontWeight: FontWeight.w400,
                  //             color: Colors.white)),
                  //       )
                  //     ],
                  //   ),
                  // )),
              // SizedBox(height: 8),
            ],
          ),
        ));
  }

  Container _address() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Container(
            child: ListView.builder(
          itemCount: 7,
          itemBuilder: (_, i) {
            if (i == 0) {
              return _addressContentSelected();
            } else if (i == 6) {
              return _button();
            } else {
              return _addressContent();
            }
          },
        )));
  }

  Container _button() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.09,
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: FlatButton(
          color: Color(0xFFE0E0E0),
          textColor: Colors.grey,
          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
          splashColor: Colors.grey,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddAddressPage()));
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

  Container _addressContent() {
    return Container(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 60.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Mike Jones",
              style: (TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(
              "365 Burnside Avenue",
              style: (TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
            ),
            Text(
              "Brigam city",
              style: (TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
            ),
            Text(
              "365",
              style: (TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
            ),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: SvgPicture.asset("images/ic_phone_blue.svg"),
                  ),
                  TextSpan(
                      text: " 435-695-1967",
                      style: new TextStyle(color: Colors.black)),
                ],
              ),
            ),
            SizedBox(height: 40),
          ]),
        ));
  }

  Padding _addressContentSelected() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.redAccent),
          borderRadius: new BorderRadius.circular(4.0),
        ),
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 16.0, right: 16.0, left: 60.0, bottom: 8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Mike Jones",
              style: (TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(
              "365 Burnside Avenue",
              style: (TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
            ),
            Text(
              "Brigam city",
              style: (TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
            ),
            Text(
              "365",
              style: (TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
            ),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: SvgPicture.asset("images/ic_phone_blue.svg"),
                  ),
                  TextSpan(
                      text: " 435-695-1967",
                      style: new TextStyle(color: Colors.black)),
                ],
              ),
            ),
            SizedBox(height: 40),
          ]),
        ),
      ),
    );
  }

  String addressDetails() {
    String key = "";

    String buildingName =orderModel.shippingAddress?.buildingName;
    String addressLine1 = orderModel.shippingAddress?.addressLine1;
    String addressLine2 = orderModel.shippingAddress?.addressLine2;
    String district =orderModel.shippingAddress?.district;
    String state =orderModel.shippingAddress?.state;

    if (buildingName != null && buildingName != "") {
      key = key + buildingName;
    }
    if (addressLine1 != null && addressLine1 != "") {
      if(key.length>0)
        {
          key = key + "," + addressLine1;
        }
      else{
        key = key+ addressLine1;
      }

    }
    if (addressLine2 != null && addressLine2 != "") {
      if(key.length>0)
      {
        key = key + "," + addressLine2;
      }
      else{
        key = key+ addressLine2;
      }
    }
    if (district != null && district != "") {
      if(key.length>0)
      {
        key = key + "," + district;
      }
      else{
        key = key+ district;
      }
    }
    if (state != null && state != "") {
      if(key.length>0)
      {
        key = key + "," + state;
      }
      else{
        key = key+ state;
      }
    }
    return key;
  }
}
