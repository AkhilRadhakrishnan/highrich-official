import 'dart:convert';

import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/order_detail.dart';
import 'package:highrich/Screens/profile_details.dart';
import 'package:highrich/Screens/progress_hud.dart';
import 'package:highrich/Screens/search.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/model/MyOrders/orders_model.dart';
import 'package:highrich/model/LogInModel.dart';
import 'package:highrich/model/MyOrders/subscription_response_model.dart';
import 'package:highrich/model/default_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:highrich/Screens/invoice_template.dart';
import 'package:highrich/model/invoice_customer.dart';
import 'package:highrich/model/invoice_seller.dart';
import 'package:highrich/model/invoice_company.dart';
import 'package:highrich/model/invoice_company_contact.dart';
import 'package:highrich/model/invoice.dart';
import 'package:highrich/APICredentials/pdf_api.dart';
import 'package:highrich/APICredentials/pdf_invoice_api.dart';
/*
 *  2021 Highrich.in
 */

class MyOrders extends StatefulWidget {
  int tabIndex;

  MyOrders({this.tabIndex});

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrders> {
  int size;
  int offset;
  int tabIndex;
  int count = 0;
  int totalCount;
  bool invoice = true;
  bool _enabled = true;
  bool isLoading = false;
  String sortType = "desc";
  String paymentMode = "COD";
  bool _isPaginationInProgress = false;
  List<Orders> ordersList = new List();
  List<Documents> subscriptionList = new List();
  List<OrdersModel> ordersMainModel = new List();
  //  List<LogInModel> loginModel = new List();
  RemoteDataSource _apiResponse = RemoteDataSource();
  ScrollController scrollController = ScrollController();
  List<ProcessedOrderedItems> processedOrderedItemsList = new List();
  List<OrderedItemsOfVendor> orderedItemsOfVendor = new List();
  String highrichID = '';
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    tabIndex = widget.tabIndex;
    ordersList.clear();
    subscriptionList.clear();
    offset = 0;
    size = 10;
    getMyOrders(tabIndex, sortType);
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
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

  Widget _uiSetup(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!_isPaginationInProgress) {
          if (size < totalCount) {
            _isPaginationInProgress = true;
            print("from:Pagination");
            getMyOrders(tabIndex, sortType);
          }
        }
      }
    });
    return Scaffold(
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
              child: Text("My Orders",
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // Tab layout to show Active or Past orders title
            Container(
                height: 52,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Center(
                    child: Row(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  tabIndex = 0;
                                  print("from:Active");
                                  ordersList.clear();
                                  subscriptionList.clear();
                                  offset = 0;
                                  size = 20;
                                  getMyOrders(tabIndex, sortType);
                                });
                              },
                              child: Container(
                                width: 80,
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Spacer(),
                                    Center(
                                      child: Text(
                                        "Active",
                                        style: TextStyle(
                                            color: tabIndex == 0
                                                ? Colors.black
                                                : Colors.black12,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      height: 4,
                                      alignment: Alignment.bottomCenter,
                                      color: tabIndex == 0
                                          ? Colors.orange
                                          : Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  tabIndex = 1;
                                  print("from:PAST");
                                  ordersList.clear();
                                  subscriptionList.clear();
                                  offset = 0;
                                  size = 20;
                                  getMyOrders(tabIndex, sortType);
                                });
                              },
                              child: Container(
                                width: 80,
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Spacer(),
                                    Center(
                                      child: Text(
                                        "Past",
                                        style: TextStyle(
                                            color: tabIndex != 1
                                                ? Colors.black12
                                                : Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      height: 4,
                                      alignment: Alignment.bottomCenter,
                                      color: tabIndex != 1
                                          ? Colors.white
                                          : Colors.orange,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  tabIndex = 2;
                                  print("from:PAST");
                                  ordersList.clear();
                                  subscriptionList.clear();
                                  offset = 0;
                                  size = 20;
                                  getSubscriptonListing();
                                });
                              },
                              child: Container(
                                width: 100,
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Spacer(),
                                    Center(
                                      child: Text(
                                        "Subscription",
                                        style: TextStyle(
                                            color: tabIndex != 2
                                                ? Colors.black12
                                                : Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      height: 4,
                                      alignment: Alignment.bottomCenter,
                                      color: tabIndex != 2
                                          ? Colors.white
                                          : Colors.orange,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Spacer(),
                        Container(
                          width: 1,
                          color: Colors.grey.shade200,
                        ),
                        InkWell(
                          onTap: () {
                            Future(() => showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ModalBottomSheetSortMyOrders(
                                      sortType: sortType,
                                      valueChanged: (value) {
                                        print("from:SORT:" + value);
                                        ordersList.clear();
                                        offset = 0;
                                        size = 20;
                                        getMyOrders(tabIndex, value);
                                        Navigator.pop(context);
                                      });
                                }));
                          },
                          child: Container(
                            width: 60,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset("images/sort.svg"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            tabIndex == 2
                ? Expanded(
                    child: subscriptionList.length > 0
                        ? Container(
                            margin: const EdgeInsets.all(12.0),
                            child: ListView.builder(
                                controller: scrollController,
                                itemCount: subscriptionList?.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: InkWell(
                                      onTap: () {},
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(14.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  // ClipRRect(borderRadius: BorderRadius.circular(25),child:Image.network("https://homepages.cae.wisc.edu/~ece533/images/airplane.png",height: 50,width: 50,),),
                                                  CircleAvatar(
                                                    radius: 36,
                                                    backgroundColor: gray_bg,
                                                    child: CircleAvatar(
                                                      radius: 35,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              imageBaseURL +
                                                                  subscriptionList[
                                                                          index]
                                                                      .source
                                                                      .image),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                subscriptionList[
                                                                        index]
                                                                    .source
                                                                    ?.productName,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "₹ " +
                                                                  subscriptionList[
                                                                          index]
                                                                      .source
                                                                      ?.itemCurrentPrice
                                                                      .sellingPrice
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color:
                                                                      colorButtonOrange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              "₹ " +
                                                                  subscriptionList[
                                                                          index]
                                                                      .source
                                                                      ?.itemCurrentPrice
                                                                      .price
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Spacer(),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              subscriptionList[
                                                                          index]
                                                                      .source
                                                                      ?.itemCurrentPrice
                                                                      .quantity
                                                                      .toString() +
                                                                  " " +
                                                                  subscriptionList[
                                                                          index]
                                                                      .source
                                                                      ?.itemCurrentPrice
                                                                      .unit
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              "Qty: " +
                                                                  subscriptionList[
                                                                          index]
                                                                      .source
                                                                      ?.quantity
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .calendar_today,
                                                              color:
                                                                  Colors.grey,
                                                              size: 20,
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(getFormatedDate(
                                                                subscriptionList[
                                                                        index]
                                                                    .source
                                                                    .lastOrderedDate))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.all_inbox,
                                                              color:
                                                                  Colors.grey,
                                                              size: 20,
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              subscriptionList[
                                                                      index]
                                                                  .source
                                                                  .period,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .lightGreen),
                                                            ),
                                                            Spacer(),
                                                            ButtonTheme(
                                                              minWidth: 80.0,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  showAlertDialog(
                                                                      context,
                                                                      subscriptionList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          border:
                                                                              Border.all(
                                                                    color: Colors
                                                                        .red,
                                                                  )),
                                                                  child: Text(
                                                                    "Cancel Subscription",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .deepOrange,
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
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
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : Container(
                            child: Center(
                              child: Text("No items available"),
                            ),
                          ),
                  )
                : Expanded(
                    child: ordersList.length > 0
                        ? Container(
                            margin: const EdgeInsets.all(12.0),
                            child: ListView.builder(
                                controller: scrollController,
                                itemCount: ordersList?.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: InkWell(
                                      onTap: () {
                                        processedOrderedItemsList =
                                            ordersList[index]
                                                ?.source
                                                ?.processedOrderedItems;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => OrderDetail(
                                                    ordersModelNew:
                                                        ordersList[index],
                                                    processedOrderedItemsList:
                                                        processedOrderedItemsList,
                                                    orderGroupId:
                                                        ordersList[index]
                                                            ?.source
                                                            ?.orderGroupId,
                                                    tabIndex:
                                                        tabIndex.toString())));
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(14.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "ORDER ID:",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12.0),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      ordersList[index]
                                                          ?.source
                                                          ?.orderGroupId,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.0),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      ordersList[index]
                                                                  ?.source
                                                                  ?.paymentMode ==
                                                              "COD"
                                                          ? SvgPicture.asset(
                                                              'images/cash.svg',
                                                              height: 14,
                                                              width: 14,
                                                            )
                                                          : SvgPicture.asset(
                                                              'images/online.svg',
                                                              height: 14,
                                                              width: 14,
                                                            ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        ordersList[index]
                                                            ?.source
                                                            ?.paymentMode,
                                                        style: ordersList[index]
                                                                    ?.source
                                                                    ?.paymentMode ==
                                                                "COD"
                                                            ? TextStyle(
                                                                color:
                                                                    colorDarkYellow,
                                                                fontSize: 14.0)
                                                            : TextStyle(
                                                                color: Colors
                                                                    .lightGreenAccent,
                                                                fontSize: 14.0),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'images/calendar.svg',
                                                    height: 18,
                                                    width: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    getFormatedDate(
                                                        ordersList[index]
                                                            ?.source
                                                            ?.orderedDate),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Spacer(),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  ordersList[index]
                                                              ?.source
                                                              ?.orderStatus !=
                                                          "CANCELLED"
                                                      ? Visibility(
                                                          visible: ordersList[
                                                                  index]
                                                              .source
                                                              .processedOrderedItems[
                                                                  0]
                                                              .invoice,
                                                          child:
                                                              GestureDetector(
                                                            // onTap: () {
                                                            // BottomSheetViewInvoice
                                                            //     mbs =
                                                            //     new BottomSheetViewInvoice(
                                                            //         ordersModel:
                                                            //             ordersList[
                                                            //                 index],
                                                            //         tabIndex:
                                                            //             tabIndex);

                                                            // Future(() =>
                                                            //     showModalBottomSheet(
                                                            //         isScrollControlled:
                                                            //             true,
                                                            //         context:
                                                            //             context,
                                                            //         builder:
                                                            //             (context) {
                                                            //           return mbs;
                                                            //         }));
                                                            // Navigator.push(context, MaterialPageRoute(
                                                            //   builder:(BuildContext context) => PdfPage() ));
                                                            // },
                                                            ////PDF template
                                                            onTap: () async {
                                                              final date =
                                                                  DateTime
                                                                      .now();
                                                              final dueDate = date
                                                                  .add(Duration(
                                                                      days: 7));
                                                              List<InvoiceItem>
                                                                  invoiceList =
                                                                  new List();
                                                              int count = 1;
                                                              // print("hrid:   " + loginModel[index].accountType.toString());
                                                              ordersList[index]
                                                                  ?.source
                                                                  ?.processedOrderedItems[
                                                                      0]
                                                                  .orderedItemsOfVendor
                                                                  .forEach(
                                                                      (element) {
                                                                if (element
                                                                        .itemOrderStatus
                                                                        .currentStatus !=
                                                                    "CANCELLED") {
                                                                  invoiceList
                                                                      .add(
                                                                    InvoiceItem(
                                                                      count:
                                                                          count,
                                                                      description: element.productName.length <=
                                                                              10
                                                                          ? element
                                                                              .productName
                                                                          : element.productName.substring(0, 10) +
                                                                              '...',
                                                                      unit: element
                                                                              .itemCurrentPrice
                                                                              .quantity +
                                                                          " " +
                                                                          element
                                                                              .itemCurrentPrice
                                                                              .unit,
                                                                      mrp: element
                                                                          .itemCurrentPrice
                                                                          .price
                                                                          .toStringAsFixed(
                                                                              2)
                                                                          .toString(),
                                                                      sellingprice: element
                                                                          .itemCurrentPrice
                                                                          .sellingPrice
                                                                          .toStringAsFixed(
                                                                              2)
                                                                          .toString(),
                                                                      quantity:
                                                                          element
                                                                              .quantity,
                                                                      tax: element
                                                                              .taxPerCent +
                                                                          "%",
                                                                      si: element
                                                                          .itemCurrentPrice
                                                                          .salesIncentive
                                                                          .toStringAsFixed(
                                                                              2)
                                                                          .toString(),
                                                                      // vat: 0.19,
                                                                      unitPrice: element
                                                                          .totalAmount
                                                                          .toStringAsFixed(
                                                                              2)
                                                                          .toString(),
                                                                    ),
                                                                  );
                                                                  count =
                                                                      count + 1;
                                                                }
                                                              });

                                                              final invoice =
                                                                  Invoice(
                                                                      companycontact:
                                                                          Companycontact(
                                                                        title:
                                                                            'Conatact',
                                                                        gstin:
                                                                            'GSTIN: 32AAFCH0823E1Z8',
                                                                        phone:
                                                                            '+91 9744338134',
                                                                        mail:
                                                                            'info@highrich.in',
                                                                      ),
                                                                      company:
                                                                          Company(
                                                                        title:
                                                                            'Company Address',
                                                                        name:
                                                                            'Highrich Online Shoppe Pvt. Ltd.',
                                                                        firstaddr:
                                                                            '2nd Floor, Kanimangalam Tower',
                                                                        secondaddr:
                                                                            'Valiyalukkal,Thrissur,Kerala, 680027',
                                                                      ),
                                                                      supplier: Seller(
                                                                          title:
                                                                              'Billed From',
                                                                          name: ordersList[index]
                                                                              ?.source
                                                                              ?.processedOrderedItems[
                                                                                  0]
                                                                              ?.vendor,
                                                                          address: ordersList[index]
                                                                              ?.source
                                                                              ?.processedOrderedItems[
                                                                                  0]
                                                                              ?.vendorAddress
                                                                              ?.addressLine1
                                                                          // paymentInfo: 'https://paypal.me/sarahfieldzz',
                                                                          ),
                                                                      customer:
                                                                          Customer(
                                                                        title:
                                                                            'Billed To',
                                                                        name: ordersList[index]
                                                                            ?.source
                                                                            ?.customerName,
                                                                        address: ordersList[index]
                                                                            ?.source
                                                                            ?.shippingAddress
                                                                            ?.addressLine1,
                                                                        cusno: ordersList[index]
                                                                            ?.source
                                                                            ?.shippingAddress
                                                                            ?.phoneNo,
                                                                      ),
                                                                      info:
                                                                          InvoiceInfo(
                                                                        hrid: ordersList[index]
                                                                            ?.source
                                                                            ?.referralId,
                                                                        indate: getFormatedDate(ordersList[index]
                                                                            ?.source
                                                                            ?.orderedDate),
                                                                        paymode: ordersList[index]
                                                                            ?.source
                                                                            ?.paymentMode,
                                                                        // description: 'sugar',
                                                                        number: ordersList[index]
                                                                            ?.source
                                                                            ?.orderGroupId,
                                                                      ),
                                                                      items:
                                                                          invoiceList,
                                                                      totalPrice:
                                                                          InvoicePrice(
                                                                        // rs: '\₹',
                                                                        deliveryCharge: ordersList[index]
                                                                            ?.source
                                                                            ?.deliveryCharge
                                                                            ?.toStringAsFixed(2)
                                                                            .toString(),
                                                                        totalDiscount: ordersList[index]
                                                                            ?.source
                                                                            ?.totalDiscount
                                                                            ?.toStringAsFixed(2)
                                                                            .toString(),
                                                                        netTotal: ordersList[index]
                                                                            ?.source
                                                                            ?.subTotal
                                                                            ?.toStringAsFixed(2)
                                                                            .toString(),
                                                                        totalAmount: ordersList[index]
                                                                            ?.source
                                                                            ?.totalPrice
                                                                            ?.toStringAsFixed(2)
                                                                            .toString(),
                                                                      ));

                                                              final pdfFile =
                                                                  await PdfInvoiceApi
                                                                      .generate(
                                                                          invoice);

                                                              PdfApi.openFile(
                                                                  pdfFile);
                                                            },
                                                            ////////////////////
                                                            child: Text(
                                                              "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .orange,
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                                  Spacer(),
                                                  SvgPicture.asset(
                                                    'images/right_arrow.svg',
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Visibility(
                                                visible: tabIndex == 1,
                                                child: Row(
                                                  children: [
                                                    Spacer(),
                                                    ButtonTheme(
                                                      minWidth: 120.0,
                                                      child: InkWell(
                                                        onTap: () {
                                                          reorderAPI(ordersList[
                                                                  index]
                                                              .source
                                                              .orderGroupId);
                                                        },
                                                        child: Container(
                                                          color:
                                                              Colors.blueAccent,
                                                          child: Text(
                                                            "Reorder",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 30,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : Container(
                            child: Center(
                              child: Text("No items available"),
                            ),
                          ),
                  ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      key: _scaffoldkey,
    );
  }

  showAlertDialog(BuildContext context, String subscriptionId) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        cancelSubscription(subscriptionId);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Do you want to cancel subscription ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String getFormatedDate(var timeStamp) {
    String formattedDate = "";
    var date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    formattedDate = DateFormat('MMM dd , hh:mm a').format(date);

    return formattedDate;
  }

  //Reorder  api call
  Future<DefaultModel> reorderAPI(String orderGroupId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("userId");
    setState(() {
      isLoading = true;
    });

    var reorderPayLoad = Map<String, dynamic>();
    reorderPayLoad.addAll({
      "orderGroupId": orderGroupId,
      "accountType": "customer",
      "userId": userId,
    });

    Result result = await _apiResponse.reorderAPI(reorderPayLoad);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      DefaultModel response = (result).value;
      if (response.status == "success") {
        DartNotificationCenter.post(
          channel: "cartCount_event",
          options: "getCart",
        );

        DartNotificationCenter.post(channel: 'getCart');
        showSnackBar("Added to cart successfully!");
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

  //My Orders listing api call
  Future<OrdersModel> getMyOrders(int tabIndex, String _sortType) async {
    String filter;
    int orderSize = 0;
    if (tabIndex == 0) {
      filter = "ACTIVE";
    } else if (tabIndex == 1) {
      filter = "PAST";
    } else {}
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("userId");

    setState(() {
      sortType = _sortType;
      isLoading = true;
    });

    var myOrdersReqBody = Map<String, dynamic>();
    myOrdersReqBody.addAll({
      "filter": filter,
      "key": "",
      "offset": offset,
      "size": size,
      "sortBy": "orderedDate",
      "sortType": _sortType,
      "userId": userId,
    });
    print(jsonEncode(myOrdersReqBody));
    Result result = await _apiResponse.getMyOrders(myOrdersReqBody);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      OrdersModel response = (result).value;
      if (response.status == "success") {
        setState(() {
          totalCount = response.count;
          ordersList.addAll(response.orders);

          offset = offset + size;
          size = 20;
          _isPaginationInProgress = false;
        });
        // print(response.orders[0].source.orderGroupId);
      } else {
        // showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      OrdersModel unAuthoedUser = (result).value;
      // showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      //showSnackBar("Failed, please try agian later");
    }
  }

  //Subscription Listing api call
  Future<OrdersModel> getSubscriptonListing() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("userId");

    setState(() {
      isLoading = true;
    });

    var mySubscriptionReqBody = Map<String, dynamic>();
    mySubscriptionReqBody.addAll({
      "offset": offset,
      "size": size,
      "sortBy": "subscribedDate",
      "sortType": "asc",
      "userId": userId,
    });
    print(jsonEncode(mySubscriptionReqBody));
    Result result =
        await _apiResponse.getSubscriptonListing(mySubscriptionReqBody);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      SubscriptionResponseModel response = (result).value;
      if (response.status == "success") {
        setState(() {
          totalCount = response.count;
          offset = offset + size;
          subscriptionList.addAll(response.documents);
          size = 20;
          _isPaginationInProgress = false;
        });
      } else {
        // showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      SubscriptionResponseModel unAuthoedUser = (result).value;
      // showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      //showSnackBar("Failed, please try agian later");
    }
  }

  //Cancel Subscription api call
  Future<DefaultModel> cancelSubscription(String subscriptionId) async {
    setState(() {
      isLoading = true;
    });

    var myOrdersReqBody = Map<String, dynamic>();
    myOrdersReqBody.addAll({
      "subscriptionId": subscriptionId,
    });
    print(jsonEncode(myOrdersReqBody));
    Result result = await _apiResponse.cancelSubscription(myOrdersReqBody);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      DefaultModel response = (result).value;
      if (response.status == "success") {
        tabIndex = 2;
        ordersList.clear();
        subscriptionList.clear();
        offset = 0;
        size = 20;
        Navigator.of(context, rootNavigator: true).pop();
        getSubscriptonListing();
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
}

class ModalBottomSheetSortMyOrders extends StatefulWidget {
  final ValueChanged valueChanged;
  String sortType;

  ModalBottomSheetSortMyOrders({@required this.sortType, this.valueChanged});

  _ModalBottomSheetSortMyOrdersState createState() =>
      _ModalBottomSheetSortMyOrdersState();
}

enum SingingCharacter { desc, asc }

class _ModalBottomSheetSortMyOrdersState
    extends State<ModalBottomSheetSortMyOrders>
    with SingleTickerProviderStateMixin {
  var heightOfModalBottomSheet = 250.0;
  int _currentIndex = 1;
  String sortType;
  SingingCharacter _character;

  Widget build(BuildContext context) {
    sortType = widget.sortType;
    if (sortType == "desc") {
      _character = SingingCharacter.desc;
    } else {
      _character = SingingCharacter.asc;
    }
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        new ListTile(
            title: new Text(
              "Sort By",
            ),
            onTap: () => {}),
        Divider(),
        new RadioListTile(
          groupValue: _character,
          title: Text("Date (Newest First)"),
          value: SingingCharacter.desc,
          onChanged: (val) {
            setState(() {
              _character = val;
              sortType = "desc";
              widget.valueChanged(sortType);
            });
          },
        ),
        new RadioListTile(
          groupValue: _character,
          title: Text("Date (Oldest First)"),
          value: SingingCharacter.asc,
          onChanged: (val) {
            setState(() {
              _character = val;
              sortType = "asc";
              widget.valueChanged(sortType);
            });
          },
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class BottomSheetViewInvoice extends StatefulWidget {
  Orders ordersModel = new Orders();
  int tabIndex;

  BottomSheetViewInvoice({@required this.ordersModel, this.tabIndex});

  _BottomSheetViewInvoiceState createState() => _BottomSheetViewInvoiceState();
}

class _BottomSheetViewInvoiceState extends State<BottomSheetViewInvoice>
    with SingleTickerProviderStateMixin {
  Orders ordersModel = new Orders();
  List<ProcessedOrderedItems> processedOrderedItemsList = new List();
  List<OrderedItemsOfVendor> allOrderList;
  String phone = "";
  int tabIndex;

  Widget build(BuildContext context) {
    ordersModel = widget.ordersModel;
    print(ordersModel.source.totalPrice);
    print(ordersModel.source.subTotal);
    tabIndex = widget.tabIndex;
    processedOrderedItemsList = ordersModel.source.processedOrderedItems;
    if (ordersModel.source.shippingAddress != null) {
      if (ordersModel.source.shippingAddress.phoneNo == null) {
        phone = "";
      } else {
        phone = ordersModel.source.shippingAddress.phoneNo;
      }
    }

    for (int i = 0; i < processedOrderedItemsList.length; i++) {
      allOrderList = processedOrderedItemsList[i].orderedItemsOfVendor;
    }
    return Container(
        color: Colors.white,
        height: 550,
        child: ListView(
          children: [
            new Wrap(
              children: <Widget>[
                new ListTile(
                    title: new Text(
                      "Order Details",
                    ),
                    onTap: () => {}),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 550,
                  margin: EdgeInsets.only(left: 14.0, right: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Order By :",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            ordersModel.source.customerName,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Text(
                            "Contact :",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            phone,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Row(
                        children: [
                          Text(
                            "Order Date:",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            getFormatedDate(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Text(
                            "Invoice ID:",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              ordersModel?.source?.orderGroupId,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Text(
                            "Payment:",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            ordersModel.source.paymentMode,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Delivery Address",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        addressDetails(ordersModel.source.shippingAddress),
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: allOrderList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return myOrderItems(allOrderList[index]);
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Sub Total"),
                          ),
                          Text(
                            "₹ " +
                                ordersModel.source.subTotal.toStringAsFixed(2),
                            style: TextStyle(
                                color: colorButtonOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Delivey Charges"),
                          ),
                          Text(
                            "₹ " +
                                ordersModel.source.deliveryCharge
                                    .toStringAsFixed(2),
                            style: TextStyle(
                                color: colorButtonOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Total"),
                          ),
                          Text(
                            "₹ " +
                                ordersModel.source.totalPrice
                                    .toStringAsFixed(2),
                            style: TextStyle(
                                color: colorButtonOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ));
  }

  Widget myOrderItems(OrderedItemsOfVendor allOrder) {
    return tabIndex == 1 || tabIndex == 0
        ? Visibility(
            visible: allOrder.itemOrderStatus.currentStatus != "CANCELLED",
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    allOrder?.productName,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Text(
                                  "₹ " +
                                      allOrder?.itemCurrentPrice.sellingPrice
                                          .toString(),
                                  style: TextStyle(
                                      color: colorButtonOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Qty: " +
                                    allOrder?.itemCurrentPrice?.quantity +
                                    " " +
                                    allOrder?.itemCurrentPrice?.unit),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ))
        : Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  allOrder?.productName,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              Text(
                                "₹ " +
                                    allOrder?.itemCurrentPrice.sellingPrice
                                        .toString(),
                                style: TextStyle(
                                    color: colorButtonOrange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Qty: " +
                                  allOrder?.itemCurrentPrice?.quantity +
                                  " " +
                                  allOrder?.itemCurrentPrice?.unit),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
  }

  String addressDetails(ShippingAddress shippingAddressModel) {
    String key = "";

    String buildingName = shippingAddressModel?.buildingName;
    String addressLine1 = shippingAddressModel?.addressLine1;
    String addressLine2 = shippingAddressModel?.addressLine2;
    String district = shippingAddressModel?.district;
    String state = shippingAddressModel?.state;
    String pinCode = shippingAddressModel?.pinCode;

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
    if (pinCode != null && pinCode != "") {
      key = key + "," + pinCode;
    }
    return key;
  }

  String getFormatedDate() {
    String formattedDate = "";
    if (ordersModel.source?.orderedDate != null) {
      var date =
          DateTime.fromMillisecondsSinceEpoch(ordersModel.source.orderedDate);
      formattedDate = DateFormat('MMM dd , hh:mm a').format(date);
      print(formattedDate);
    } else {
      formattedDate = "";
    }

    return formattedDate;
  }
}
