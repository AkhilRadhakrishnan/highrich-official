import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highrich/APICredentials/update_status_credential.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/progress_hud.dart';
import 'package:highrich/Screens/search.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/general/shared_pref.dart';
import 'package:highrich/model/MyReturns/my_returns.dart';
import 'package:highrich/model/default_model.dart';
import 'package:highrich/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:highrich/model/MyOrders/orders_model.dart';
import 'package:highrich/Screens/order_detail.dart';

/*
 *  2021 Highrich.in
 */

class MyReturns extends StatefulWidget {
  String apiName;

  MyReturns({@required this.apiName});

  @override
  _MyReturnsPageState createState() => _MyReturnsPageState();
}

class _MyReturnsPageState extends State<MyReturns> {
  bool isLoading = false;
  String sortType = "desc";
  SharedPref sharedPref = SharedPref();
  List<Documents> documentList = new List();
  RemoteDataSource _apiResponse = RemoteDataSource();

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    DartNotificationCenter.subscribe(
        channel: "GET_MY_RETURNS",
        observer: this,
        onNotification: (result) {
          getMyReturns(sortType);
        });
    DartNotificationCenter.post(channel: 'GET_MY_RETURNS');
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
              margin: EdgeInsets.all(6),
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
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(6),
            child: Text("My Returns",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
          ),
          Spacer(),
        ],
      ),
      body: Container(
          padding: EdgeInsets.only(bottom: 20),
          child: Container(
              child: Column(
            children: [
              Container(
                  height: 54,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Spacer(),
                      Container(
                        width: 1,
                        color: Colors.grey.shade200,
                      ),
                      InkWell(
                        onTap: () {
                          Future(() => showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return ModalBottomSheetSortReturns(
                                    sortType: sortType,
                                    valueChanged: (value) {
                                      getMyReturns(value);
                                      Navigator.pop(context);
                                    });
                              }));
                        },
                        child: Container(
                          width: 80,
                          color: Colors.white,
                          child: Center(
                            child: SvgPicture.asset("images/sort.svg"),
                          ),
                        ),
                      )
                    ],
                  )),
              Expanded(
                child: documentList.length > 0
                    ? Container(
                        color: Colors.grey.shade200,
                        child: ListView.builder(
                          itemCount: documentList?.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 180,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                width: 110,
                                                height: 140,
                                                child: documentList[index]
                                                            .source
                                                            .image
                                                            .length >
                                                        0
                                                    ? CachedNetworkImage(
                                                        imageUrl: imageBaseURL +
                                                            documentList[index]
                                                                .source
                                                                .image,
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            "https://images.unsplash.com/photo-1467453678174-768ec283a940?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
                                                      ),
                                              )),
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        documentList[index]
                                                            ?.source
                                                            ?.productName,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "₹ " +
                                                                      documentList[
                                                                              index]
                                                                          .source
                                                                          .itemCurrentPrice
                                                                          .sellingPrice
                                                                          .toStringAsFixed(
                                                                              2)
                                                                          .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .deepOrangeAccent,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 12,
                                                                ),
                                                                Text(
                                                                  "₹ " +
                                                                      documentList[
                                                                              index]
                                                                          .source
                                                                          .itemCurrentPrice
                                                                          .price
                                                                          .toStringAsFixed(
                                                                              2)
                                                                          .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  documentList[
                                                                              index]
                                                                          .source
                                                                          .itemCurrentPrice
                                                                          .quantity +
                                                                      " " +
                                                                      documentList[
                                                                              index]
                                                                          .source
                                                                          .itemCurrentPrice
                                                                          .unit
                                                                          .substring(
                                                                              0,
                                                                              3),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .black87,
                                                                      fontSize:
                                                                          11.0),
                                                                ),
                                                                SizedBox(
                                                                  width: 12,
                                                                ),
                                                                Visibility(
                                                                  visible:
                                                                      checkDiscount(
                                                                          index),
                                                                  child:
                                                                      Container(
                                                                    width: 75,
                                                                    height: 30,
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        // SvgPicture
                                                                        //     .asset(
                                                                        //   'images/OfferBg.svg',
                                                                        //   height:
                                                                        //       30,
                                                                        // ),
                                                                        Center(
                                                                          child:
                                                                              Text(
                                                                            getDiscount(index),
                                                                            style: TextStyle(
                                                                                color: Colors.green,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 11.0),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Spacer(),
                                                              ],
                                                            )
                                                          ],
                                                        )),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    'images/calendar.svg',
                                                                    height: 18,
                                                                    width: 18,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    getFormatedDate(
                                                                        index),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 6,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  documentList[index]
                                                                              ?.source
                                                                              ?.paymentMode ==
                                                                          "COD"
                                                                      ? SvgPicture
                                                                          .asset(
                                                                          'images/cash.svg',
                                                                          height:
                                                                              14,
                                                                          width:
                                                                              14,
                                                                        )
                                                                      : SvgPicture
                                                                          .asset(
                                                                          'images/online.svg',
                                                                          height:
                                                                              14,
                                                                          width:
                                                                              14,
                                                                        ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    documentList[
                                                                            index]
                                                                        ?.source
                                                                        ?.paymentMode,
                                                                    style: documentList[index]?.source?.paymentMode ==
                                                                            "COD"
                                                                        ? TextStyle(
                                                                            color:
                                                                                colorDarkYellow,
                                                                            fontSize:
                                                                                14.0)
                                                                        : TextStyle(
                                                                            color:
                                                                                Colors.lightGreenAccent,
                                                                            fontSize: 14.0),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 6,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  documentList[index]
                                                                              ?.source
                                                                              ?.status ==
                                                                          "ACCEPTED"
                                                                      ? SvgPicture
                                                                          .asset(
                                                                          'images/green_tick.svg',
                                                                          height:
                                                                              14,
                                                                          width:
                                                                              14,
                                                                        )
                                                                      : SvgPicture
                                                                          .asset(
                                                                          'images/red_close.svg',
                                                                          height:
                                                                              14,
                                                                          width:
                                                                              14,
                                                                        ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    "REQUEST " +
                                                                        documentList[index]
                                                                            ?.source
                                                                            ?.status,
                                                                    style: documentList[index]?.source?.status ==
                                                                            "ACCEPTED"
                                                                        ? TextStyle(
                                                                            color: Colors
                                                                                .lightGreenAccent,
                                                                            fontSize:
                                                                                12.0)
                                                                        : TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize: 12.0),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: Colors.black12,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Spacer(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      BottomSheetViewDetails
                                                          mbs =
                                                          new BottomSheetViewDetails(
                                                        sourceMyReturns:
                                                            documentList[index]
                                                                .source,
                                                      );
                                                      Future(() =>
                                                          showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return mbs;
                                                              }));
                                                    },
                                                    child: Text("View Details",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.orange,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16)),
                                                  ),
                                                  Spacer(),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Visibility(
                                            visible: documentList[index]
                                                    .source
                                                    .vendorType ==
                                                "SELLER",
                                            child: Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: GestureDetector(
                                                  onTap:
                                                      documentList[index]
                                                                  .source
                                                                  .status ==
                                                              "ACCEPTED"
                                                          ? () {
                                                              BottomSheetUpdateStatus mbs = new BottomSheetUpdateStatus(
                                                                  sourceMyReturns:
                                                                      documentList[
                                                                              index]
                                                                          .source,
                                                                  id: documentList[
                                                                          index]
                                                                      .id);
                                                              Future(() =>
                                                                  showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return mbs;
                                                                      }));
                                                            }
                                                          : () {
                                                              print(
                                                                  documentList[
                                                                          index]
                                                                      .source
                                                                      .status);
                                                            },
                                                  child: Text(
                                                    "Update Status",
                                                    style: TextStyle(
                                                        color: documentList[
                                                                        index]
                                                                    .source
                                                                    .status ==
                                                                "ACCEPTED"
                                                            ? colorButtonOrange
                                                            : Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        child: Center(
                          child: Text("No items available"),
                        ),
                      ),
              ),
            ],
          ))),
      key: _scaffoldkey,
    );
  }

  String getFormatedDate(int index) {
    String formattedDate = "";
    if (documentList[index]?.source?.orderedDate != null) {
      var date = DateTime.fromMillisecondsSinceEpoch(
          documentList[index]?.source?.orderedDate);
      formattedDate = DateFormat('MMM dd , hh:mm a').format(date);
      print(formattedDate);
    } else {
      formattedDate = "";
    }

    return formattedDate;
  }

//To show discount
  bool checkDiscount(int index) {
    bool discountFlag = false;

    String discount =
        documentList[index].source.itemCurrentPrice.discount.toString();
    if (discount != null) {
      discountFlag = true;
    } else {
      discountFlag = false;
    }

    return discountFlag;
  }

  //To show discount
  String getDiscount(int index) {
    String key;

    key = documentList[index]
            .source
            .itemCurrentPrice
            .discount
            .toStringAsFixed(2)
            .toString() +
        "% off";

    return key;
  }

  //My Returns listing api call
  Future<MyRetunsModel> getMyReturns(String sort) async {
    setState(() {
      sortType = sort;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("userId");
    print("11111--" + sortType + "---111");
    setState(() {
      isLoading = true;
    });

    var myreturnsReqBody = Map<String, dynamic>();
    myreturnsReqBody.addAll({
      "key": "",
      "sortBy": "requestedDate",
      "sortType": sort,
      "userId": userId,
    });

    Result result = await _apiResponse.getMyReturns(myreturnsReqBody);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      MyRetunsModel response = (result).value;
      if (response?.status == "success") {
        setState(() {
          documentList = response?.documents;
        });
      } else {
        // showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      MyRetunsModel unAuthoedUser = (result).value;
      // showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      //showSnackBar("Failed, please try agian later");
    }
  }
}

class ModalBottomSheetSortReturns extends StatefulWidget {
  final ValueChanged valueChanged;
  String sortType;

  ModalBottomSheetSortReturns({@required this.sortType, this.valueChanged});

  _ModalBottomSheetSortState createState() => _ModalBottomSheetSortState();
}

enum SingingCharacter { desc, asc }

class _ModalBottomSheetSortState extends State<ModalBottomSheetSortReturns>
    with SingleTickerProviderStateMixin {
  var heightOfModalBottomSheet = 250.0;

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
              print("..." + sortType + ".....");
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
              print("..." + sortType + ".....");
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

class BottomSheetViewDetails extends StatefulWidget {
  SourceMyReturns sourceMyReturns = new SourceMyReturns();

  BottomSheetViewDetails({@required this.sourceMyReturns});

  _BottomSheetViewDetailsState createState() => _BottomSheetViewDetailsState();
}

class _BottomSheetViewDetailsState extends State<BottomSheetViewDetails>
    with SingleTickerProviderStateMixin {
  SourceMyReturns sourceMyReturns = new SourceMyReturns();
  String buildingName = "";
  String addressLine1 = "";
  String addressLine2 = "";
  String district = "";
  String pinCode = "";
  bool isBuildingName = false;
  bool isAddressLine1 = false;
  bool isAddressLine2 = false;
  bool isDistrict = false;
  bool isPinCode = false;
  bool isPickUpaddress = false;

  Widget build(BuildContext context) {
    var heightOfModalBottomSheet = 550;
    sourceMyReturns = widget.sourceMyReturns;
    if (sourceMyReturns.shippedAddress != null) {
      isPickUpaddress = true;
      if (sourceMyReturns.shippedAddress.buildingName != null) {
        buildingName = sourceMyReturns.shippedAddress.buildingName;
        isBuildingName = true;
      }
      if (sourceMyReturns.shippedAddress.addressLine1 != null) {
        addressLine1 = sourceMyReturns.shippedAddress.addressLine1;
        isAddressLine1 = true;
      }
      if (sourceMyReturns.shippedAddress.addressLine2 != null) {
        addressLine2 = sourceMyReturns.shippedAddress.addressLine2;
        isAddressLine2 = true;
      }
      if (sourceMyReturns.shippedAddress.district != null) {
        district = sourceMyReturns.shippedAddress.district;
        isDistrict = true;
      }
      if (sourceMyReturns.shippedAddress.pinCode != null) {
        pinCode = sourceMyReturns.shippedAddress.pinCode;
        isPinCode = true;
      }
    }

    return Container(
      color: Colors.white,
      height: 550,
      child: new Wrap(
        children: <Widget>[
          new ListTile(
              title: new Text(
                "Return Details",
              ),
              onTap: () => {}),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 550,
            margin: EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "OrderID: ",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      sourceMyReturns.orderId,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.normal),
                    ))
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Sold-By: ",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      sourceMyReturns.vendor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.normal),
                    ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12.0),
                    height: 120,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Container(
                          width: 110,
                          height: 200,
                          child: Padding(
                              padding: EdgeInsets.all(12),
                              child: sourceMyReturns.image.length > 0
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          imageBaseURL + sourceMyReturns.image,
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl:
                                          "https://images.unsplash.com/photo-1467453678174-768ec283a940?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
                                    )),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, left: 8.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        sourceMyReturns.productName,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Spacer(),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "₹ " +
                                              sourceMyReturns
                                                  .itemCurrentPrice.sellingPrice
                                                  .toStringAsFixed(2)
                                                  .toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepOrangeAccent,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                          sourceMyReturns
                                                  .itemCurrentPrice.quantity +
                                              " " +
                                              sourceMyReturns
                                                  .itemCurrentPrice.unit,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          sourceMyReturns.quantity.toString() +
                                              " Nos.",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "Our agent will contact you soon.",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Pick-Up Address",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Visibility(
                  visible: !isPickUpaddress,
                  child: Text(
                    "No Address Found",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                ),
                Visibility(
                  visible: isBuildingName,
                  child: Text(
                    buildingName,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                ),
                Visibility(
                  visible: isAddressLine1,
                  child: Text(
                    addressLine1,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                ),
                Visibility(
                  visible: isAddressLine2,
                  child: Text(
                    addressLine2,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                ),
                Visibility(
                  visible: isDistrict,
                  child: Text(
                    district,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                ),
                Visibility(
                  visible: isPinCode,
                  child: Text(
                    pinCode,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Comments",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                sourceMyReturns?.status == "ACCEPTED"
                    ? Text(
                        "We have accepted your request!",
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.normal),
                      )
                    : Text(
                        "Request pending",
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.normal),
                      ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class BottomSheetUpdateStatus extends StatefulWidget {
  SourceMyReturns sourceMyReturns = new SourceMyReturns();
  String id;

  BottomSheetUpdateStatus({@required this.sourceMyReturns, this.id});

  _BottomSheetUpdateStatusState createState() =>
      _BottomSheetUpdateStatusState();
}

class _BottomSheetUpdateStatusState extends State<BottomSheetUpdateStatus>
    with SingleTickerProviderStateMixin {
  SourceMyReturns sourceMyReturns = new SourceMyReturns();
  FocusScopeNode node;
  bool defaultAccountFLag = false;
  bool isLoading = false;
  String id;
  var _formKey = GlobalKey<FormState>();
  RemoteDataSource _apiResponse = RemoteDataSource();
  TextEditingController accountHoldernameController =
      new TextEditingController();
  TextEditingController bankNameController = new TextEditingController();
  TextEditingController branchController = new TextEditingController();
  TextEditingController accountNumberController = new TextEditingController();
  TextEditingController ifscController = new TextEditingController();
  TextEditingController trackingLinkCOntroller = new TextEditingController();
  TextEditingController trackingIdCOntroller = new TextEditingController();
  bool firstLoading = true;

  Widget build(BuildContext context) {
    if (firstLoading) {
      sourceMyReturns = widget.sourceMyReturns;
      print("IFSCCODE");
      firstLoading = false;

      if (sourceMyReturns.shipmentTracker != null) {
        trackingIdCOntroller.text = sourceMyReturns.shipmentTracker.trackingId;
        trackingLinkCOntroller.text =
            sourceMyReturns.shipmentTracker.trackingLink;
      }
      if (sourceMyReturns.account != null) {
        accountHoldernameController.text =
            sourceMyReturns.account.accountHolderName;
        bankNameController.text = sourceMyReturns.account.bankName;
        branchController.text = sourceMyReturns.account.branch;
        accountNumberController.text = sourceMyReturns.account.accountNumber;
        ifscController.text = sourceMyReturns.account.iFSCCode;
      }
    }
    id = widget.id;

    return Stack(children: [
      Form(
          key: _formKey,
          child: Container(
            height: 550,
            child: ListView(
              children: [
                Container(
                  color: Colors.white,
                  child: new Wrap(
                    children: <Widget>[
                      new ListTile(
                          title: new Text(
                            "Return Details",
                          ),
                          onTap: () => {}),
                      Divider(),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "OrderID",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    sourceMyReturns.orderId,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: const EdgeInsets.only(right: 12.0),
                                height: 120,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 110,
                                      height: 200,
                                      child: Padding(
                                          padding: EdgeInsets.all(12),
                                          child: sourceMyReturns.image.length >
                                                  0
                                              ? CachedNetworkImage(
                                                  imageUrl: imageBaseURL +
                                                      sourceMyReturns.image,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl:
                                                      "https://images.unsplash.com/photo-1467453678174-768ec283a940?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
                                                )),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, left: 8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    sourceMyReturns.productName,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                // Spacer(),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "₹ " +
                                                          sourceMyReturns
                                                              .itemCurrentPrice
                                                              .sellingPrice
                                                              .toStringAsFixed(
                                                                  2)
                                                              .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .deepOrangeAccent,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Text(
                                                      sourceMyReturns
                                                              .itemCurrentPrice
                                                              .quantity +
                                                          " " +
                                                          sourceMyReturns
                                                              .itemCurrentPrice
                                                              .unit,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      sourceMyReturns.quantity
                                                              .toString() +
                                                          " Nos.",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .grey.shade500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Tracking ID",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  height: 50,
                                  child: TextField(
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-Black',
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: trackingIdCOntroller,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    decoration: InputDecoration(
                                      //  labelText: "Email",
                                      hintText: "Tracking ID",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      isDense: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(2),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(2),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Tracking Link",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 50,
                                  child: TextField(
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-Black',
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: trackingLinkCOntroller,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    decoration: InputDecoration(
                                      //  labelText: "Email",
                                      hintText: "Tracking Link",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      isDense: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(2),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(2),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                sourceMyReturns?.paymentMode == "COD"
                                    ? Container(
                                        child: Column(children: [
                                          Row(
                                            children: [Text("Account Details")],
                                          ),
                                          RichText(
                                            text: new TextSpan(
                                              text:
                                                  'Refunds are made directly to the specified account ',
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                new TextSpan(
                                                    text:
                                                        ' (All fields are mandatory)',
                                                    style: TextStyle(
                                                        color: Colors.orange)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Account Holder's Name *",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: TextFormField(
                                              style: TextStyle(
                                                fontFamily: 'Montserrat-Black',
                                              ),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return "enter account holders's name";
                                                }
                                                return null;
                                              },
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp("[a-zA-Z ' ']"))
                                              ],
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onEditingComplete: () =>
                                                  node.nextFocus(),
                                              controller:
                                                  accountHoldernameController,
                                              decoration: InputDecoration(
                                                //  labelText: "Email",
                                                hintText:
                                                    "Account Holder's Name",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                isDense: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Bank Name *",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: TextFormField(
                                              style: TextStyle(
                                                fontFamily: 'Montserrat-Black',
                                              ),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return "enter bank name";
                                                }
                                                return null;
                                              },
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              controller: bankNameController,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp("[a-zA-Z ' ']"))
                                              ],
                                              onEditingComplete: () =>
                                                  node.nextFocus(),
                                              decoration: InputDecoration(
                                                //  labelText: "Email",
                                                hintText: "Bank Name",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                isDense: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Branch *",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: TextFormField(
                                              style: TextStyle(
                                                fontFamily: 'Montserrat-Black',
                                              ),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return "enter branch name";
                                                }
                                                return null;
                                              },
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp("[a-zA-Z ' ']"))
                                              ],
                                              controller: branchController,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onEditingComplete: () =>
                                                  node.nextFocus(),
                                              decoration: InputDecoration(
                                                //  labelText: "Email",
                                                hintText: "Branch",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                isDense: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Account Number *",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: TextFormField(
                                              style: TextStyle(
                                                fontFamily: 'Montserrat-Black',
                                              ),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return "enter account number";
                                                }
                                                return null;
                                              },
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                new FilteringTextInputFormatter
                                                    .allow(RegExp("[0-9]")),
                                              ],
                                              controller:
                                                  accountNumberController,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onEditingComplete: () =>
                                                  node.nextFocus(),
                                              decoration: InputDecoration(
                                                //  labelText: "Email",
                                                hintText: "Account Number",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                isDense: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "IFSC *",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: TextFormField(
                                              style: TextStyle(
                                                fontFamily: 'Montserrat-Black',
                                              ),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return "enter IFSC code";
                                                }
                                                return null;
                                              },
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        "[a-zA-Z0-9 ' ']"))
                                              ],
                                              controller: ifscController,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onEditingComplete: () =>
                                                  node.nextFocus(),
                                              decoration: InputDecoration(
                                                //  labelText: "Email",
                                                hintText: "IFSC",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                isDense: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTileTheme(
                                            contentPadding: EdgeInsets.all(0),
                                            child: CheckboxListTile(
                                              title: Text(
                                                "Set this as my default account",
                                                maxLines: 1,
                                              ),
                                              value: defaultAccountFLag,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  defaultAccountFLag = newValue;
                                                });
                                              },
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading, //  <-- leading Checkbox
                                            ),
                                          ),
                                        ]),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        // set up the buttons
                                        String holdersName =
                                            accountHoldernameController.text;
                                        String bankName =
                                            bankNameController.text;
                                        String branchName =
                                            branchController.text;
                                        String accountNumber =
                                            accountNumberController.text;
                                        String ifscCde = ifscController.text;
                                        String trackingId =
                                            trackingIdCOntroller.text;
                                        String trackingLink =
                                            trackingLinkCOntroller.text;
                                        Widget cancelButton = TextButton(
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                color: colorButtonOrange,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                        );
                                        Widget continueButton = TextButton(
                                          child: Text("Yes",
                                              style: TextStyle(
                                                  color: colorButtonOrange,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            if (sourceMyReturns?.paymentMode ==
                                                "COD") {
                                              UpdateStatusModel
                                                  updateStatusModel =
                                                  new UpdateStatusModel();
                                              updateStatusModel
                                                  .isNewBankAccount = true;
                                              updateStatusModel
                                                  .isPrimaryAccount = true;
                                              updateStatusModel.id = id;

                                              ShipmentTrackerCredential
                                                  shipmentTrackerCredential =
                                                  new ShipmentTrackerCredential();
                                              shipmentTrackerCredential
                                                  .trackingId = trackingId;
                                              shipmentTrackerCredential
                                                  .trackingLink = trackingLink;
                                              updateStatusModel
                                                      .shipmentTracker =
                                                  shipmentTrackerCredential;

                                              AccountCredential
                                                  accountCredential =
                                                  new AccountCredential();
                                              accountCredential
                                                      .accountHolderName =
                                                  holdersName;
                                              accountCredential.bankName =
                                                  bankName;
                                              accountCredential.ifscCode =
                                                  ifscCde;
                                              accountCredential.accountNumber =
                                                  accountNumber;
                                              accountCredential.branch =
                                                  branchName;
                                              updateStatusModel.account =
                                                  accountCredential;
                                              updateStatus(updateStatusModel);
                                            } else {
                                              UpdateStatusModel
                                                  updateStatusModel =
                                                  new UpdateStatusModel();
                                              updateStatusModel
                                                  .isNewBankAccount = true;
                                              updateStatusModel
                                                  .isPrimaryAccount = true;
                                              updateStatusModel.id = id;

                                              ShipmentTrackerCredential
                                                  shipmentTrackerCredential =
                                                  new ShipmentTrackerCredential();
                                              shipmentTrackerCredential
                                                  .trackingId = trackingId;
                                              shipmentTrackerCredential
                                                  .trackingLink = trackingLink;
                                              updateStatusModel
                                                      .shipmentTracker =
                                                  shipmentTrackerCredential;

                                              updateStatus(updateStatusModel);
                                            }
                                          },
                                        );
                                        // set up the AlertDialog
                                        AlertDialog alert = AlertDialog(
                                          content: Text(
                                              "Do you want to save changes"),
                                          actions: [
                                            cancelButton,
                                            continueButton,
                                          ],
                                        );

                                        // show the dialog
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alert;
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      color: Colors.deepOrange,
                                      child: new Text(
                                        "Save Changes",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
      isLoading
          ? Positioned(
              top: 250,
              left: MediaQuery.of(context).size.width * 0.4,
              child: Center(
                child: Container(
                    height: 35,
                    width: 35,
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                    )),
              ) // or optionaly wrap the child in FractionalTranslation
              )
          : Positioned(
              top: 0,
              left: 0,
              child: Container(
                height: 0,
                width: 0,
              ) // or optionaly wrap the child in FractionalTranslation
              )
    ]);
  }

  Future<DefaultModel> updateStatus(UpdateStatusModel updateStatusModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("userId");
    setState(() {
      isLoading = true;
    });

    Result result = await _apiResponse.updateStatus(updateStatusModel);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      DefaultModel response = (result).value;
      if (response.status == "success") {
        Widget continueButton = TextButton(
          child: Text(
            "Ok",
            style: TextStyle(
                color: colorButtonOrange,
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
          onPressed: () {
            DartNotificationCenter.post(channel: 'GET_MY_RETURNS');
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pop(context);
          },
        );
        AlertDialog alert = AlertDialog(
          content: Text("Update status successfully"),
          actions: [
            continueButton,
          ],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      } else {
        Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_SHORT,
        );

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
