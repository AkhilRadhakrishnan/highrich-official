import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/edit_address.dart';
import 'package:highrich/Screens/progress_hud.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/model/Address/address_list_model.dart';
import 'package:highrich/model/default_model.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'add_address.dart';
import 'package:http/http.dart' as http;

/*
 *  2021 Highrich.in
 */
class AddressPage extends StatefulWidget {
  final bool hideStatus;
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;

  const AddressPage(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class _AddressPageState extends State<AddressPage> {
  int itemListingFlag = 0;
  bool isLoading = false;
  PersistentTabController _controller;
  List<Address> addressList = new List();
  RemoteDataSource _apiResponse = RemoteDataSource();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getAddress();
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
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: itemListingFlag == 1
          ? Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: addressList.length,
                    itemBuilder: (_, indexAddress) {
                      return _buildBoxCategory(indexAddress);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: Container(
                      color: Color(0xFFE0E0E0),
                      child: TextButton(
                        // textColor: Colors.grey,
                        // splashColor: Colors.grey,
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddAddressPage()),
                          );
                          if (result != null) {
                            if (result == true) {
                              getAddress();
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child:
                                  SvgPicture.asset("images/ic_add_orange.svg"),
                            ),
                            Text(
                              "Add new address",
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
                  SizedBox(
                    height: 20,
                  )
                ],
              )),
            )
          : itemListingFlag == 2
              ? Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: SvgPicture.asset("images/no_adrz.svg")),
                      SizedBox(
                        height: 20,
                      ),
                      Center(child: Text("There is no address at the moment")),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: Container(
                          color: Color(0xFFE0E0E0),
                          child: TextButton(
                            // textColor: Colors.grey,
                            // splashColor: Colors.grey,
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddAddressPage()),
                              );
                              if (result != null) {
                                if (result == true) {
                                  getAddress();
                                }
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: SvgPicture.asset(
                                      "images/ic_add_orange.svg"),
                                ),
                                Text(
                                  "Add new address",
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
                    ],
                  ),
                )
              : Container(),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: GestureDetector(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(6),
                child: Icon(
                  Icons.keyboard_backspace,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(6),
            child: Text("Address",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
          ),
          Spacer(),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: body,
      ),
      key: _scaffoldkey,
    );
  }

  Widget _buildBoxCategory(int indexAddress) => Container(
        margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  addressList[indexAddress]?.ownerName,
                  style: (TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    setDefaultAddress(addressList[indexAddress]?.id);
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    child: addressList[indexAddress]?.primary ?? false
                        ? SvgPicture.asset("images/green_tick.svg")
                        : SvgPicture.asset("images/radio_not_selected.svg"),
                  ),
                )
              ],
            ),
            Text(
              addressDetails(indexAddress),
              textAlign: TextAlign.left,
              style: (TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              addressList[indexAddress]?.pinCode,
              textAlign: TextAlign.left,
              style: (TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
            ),
            SizedBox(
              height: 6,
            ),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: SvgPicture.asset("images/phone_black.svg"),
                  ),
                  TextSpan(text: "     "),
                  TextSpan(
                      text: addressList[indexAddress]?.phoneNo,
                      style: new TextStyle(color: Colors.black)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: SvgPicture.asset("images/email_black.svg"),
                  ),
                  TextSpan(text: "     "),
                  TextSpan(
                      text: addressList[indexAddress]?.emailId,
                      style: new TextStyle(color: Colors.black)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: addressList[indexAddress].addressType == "Home"
                  ? Colors.blue
                  : addressList[indexAddress].addressType == "Office"
                      ? Colors.green
                      : Colors.orange,
              child: Row(
                children: [
                  Container(
                      height: 30,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Center(
                          child: addressList[indexAddress].addressType == "Home"
                              ? Text(
                                  'Home',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0),
                                )
                              : addressList[indexAddress].addressType ==
                                      "Office"
                                  ? Text(
                                      'Office',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0),
                                    )
                                  : Text(
                                      addressList[indexAddress].addressType,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0),
                                    ),
                        ),
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        String pageFrom = "address";
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditAddresspage(
                                    addressModel: addressList[indexAddress],
                                    pageFrom: pageFrom)));
                      },
                      child: Text("EDIT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600))),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.white,
                  ),
                  TextButton(
                      onPressed: () {
                        showAlertDialog(context, indexAddress);
                      },
                      child: Text("REMOVE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600))),
                ],
              ),
            )
          ],
        ),
      );

  showAlertDialog(BuildContext context, int indexAddress) {
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
        Navigator.of(context, rootNavigator: true).pop();
        deleteAddress(addressList[indexAddress].id, indexAddress, context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text("Are you sure you want to delete this address"),
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

  //Display snack bar
  void showSnackBar(String message) {
    final snackBarContent = SnackBar(
      //padding: EdgeInsets.only(bottom:16.0),
      content: Text(" " + message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarContent);
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

  //Default adrz api call
  Future<DefaultModel> setDefaultAddress(String addressId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("userId");
    setState(() {
      isLoading = true;
    });
    Result result = await _apiResponse.setDefaultAddress(userId, addressId);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      DefaultModel response = (result).value;
      if (response.status == "success") {
        showSnackBar("Default address changed successfully");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("addressId", addressId);
        setState(() {
          for (int j = 0; j < addressList.length; j++) {
            if (addressList[j].id == addressId) {
              addressList[j].primary = true;
            } else {
              addressList[j].primary = false;
            }
          }
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

  Future<String> deleteAddress(
      String addressId, int index, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString("userId");
    String token = preferences.getString("token");
    final apiUrl = baseURL + "user/address/delete";
    Map jsonMap = {
      'addressId': addressId,
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
        print(addressList.length);

        setState(() {
          addressList.removeAt(index);
        });

        print(addressList.length);
      } else {}

      return resp;
    }
  }
}
