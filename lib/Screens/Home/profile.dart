import 'dart:convert';

import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/Home/bottomNavScreen.dart';
import 'package:highrich/Screens/address.dart';
import 'package:highrich/Screens/contactus.dart';
import 'package:highrich/Screens/delete_account.dart';
import 'package:highrich/Screens/my_orders.dart';
import 'package:highrich/Screens/profile_details.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/model/HomeModel/app_update_model.dart';
import 'package:highrich/model/Profile/profile_model.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../my_returns.dart';
import '../progress_hud.dart';

class ProfilePage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;

  ProfilePage(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _hideNavBar;
  String userName = "";
  String userCode = "";
  String profilePicUrl = "";
  bool isLoading = false;
  PersistentTabController _controller;
  Profile profileDataModel = new Profile();
  RemoteDataSource _apiResponse = RemoteDataSource();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getProfile();
    DartNotificationCenter.subscribe(
        channel: 'LOGIN',
        observer: this,
        onNotification: (result) {
          getProfile();
        });
    super.initState();
  }

  // void _launchURL() async {
  //   const url = 'https://highrich.net';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    var body = new ListView(
      children: [
        Stack(
          children: [
            orangeBG(),
            Positioned(
              child: Card(
                  margin:
                      const EdgeInsets.only(top: 80.0, left: 20, right: 20.0),
                  elevation: 3,
                  child: Container(
                    width: screenSize.width * 0.9,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(),
                              flex: 1,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 20, 0),
                                        child: Text(
                                          userName,
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 20, 0),
                                        child: Text(
                                          userCode,
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 35,
                            top: 10,
                            right: 35,
                            bottom: 30,
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //add what you want to do on tap
                                  //for navigating to new screen use this
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileDetailsPage(
                                                  profileDataModel)));
                                },
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    SvgPicture.asset(
                                        "images/ic_profile_orange.svg"),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text("Profile Details")
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              GestureDetector(
                                onTap: () {
                                  //add what you want to do on tap
                                  //for navigating to new screen use this
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyOrders(
                                                tabIndex: 0,
                                              )));
                                },
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    SvgPicture.asset(
                                        "images/ic_myorders_orange.svg"),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text("My Orders")
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              GestureDetector(
                                onTap: () {
                                  //add what you want to do on tap
                                  //for navigating to new screen use this
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyReturns()));
                                },
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    SvgPicture.asset(
                                        "images/ic_myreturns_orange.svg"),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text("My Returns")
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              GestureDetector(
                                onTap: () {
                                  //add what you want to do on tap
                                  //for navigating to new screen use this
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddressPage()));
                                },
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    SvgPicture.asset(
                                        "images/ic_address_orange.svg"),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text("Address")
                                  ],
                                ),
                              ),
                              //  SizedBox(
                              //   height: 18,
                              // ),
                              // GestureDetector(
                              //   onTap: () {
                              //     //add what you want to do on tap
                              //     //for navigating to new screen use this
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => MyOrders(tabIndex: 0,)));
                              //   },
                              //   child: Row(
                              //     //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              //     children: [
                              //       SvgPicture.asset(
                              //           "images/ic_address_orange.svg"),
                              //       SizedBox(
                              //         width: 16,
                              //       ),
                              //       Text("Wallet")
                              //     ],
                              //   ),
                              // ),
                              SizedBox(
                                height: 18,
                              ),
                              GestureDetector(
                                onTap: () {
                                  //add what you want to do on tap
                                  //for navigating to new screen use this
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ContactUspage()));
                                },
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    SvgPicture.asset(
                                        "images/ic_phone_orange.svg"),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text("Contact Us")
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              GestureDetector(
                                onTap: () {
                                  launch("https://highrich.net");
                                  //add what you want to do on tap
                                  //for navigating to new screen use this
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             ContactUspage()));
                                },
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    SvgPicture.asset(
                                        "images/ic_myorders_orange.svg"),
                                    // Icon(Icons.accessibility_new_outlined, color: Colors.orange),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text("Become an Affiliate")
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: 18,
                              // ),
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 DeleteAccountPage()));
                              //   },
                              //   child: Row(
                              //     //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              //     children: [
                              //       SvgPicture.asset(
                              //           "images/ic_deactivate_account.svg"),
                              //       SizedBox(
                              //         width: 16,
                              //       ),
                              //       Text("Deactivate Account")
                              //     ],
                              //   ),
                              // ),
                              SizedBox(
                                height: 18,
                              ),
                              GestureDetector(
                                onTap: () {
                                  //add what you want to do on tap
                                  //for navigating to new screen use this
                                  showAlertDialog(context);
                                },
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    SvgPicture.asset(
                                        "images/ic_logout_orange.svg"),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text("Logout")
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              GestureDetector(
                                onTap: () {
                                  //add what you want to do on tap
                                  //for navigating to new screen use this
                                  showDeleteAlertDialog(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    SvgPicture.asset(
                                        "images/ic_deactivate_account.svg"),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text("Delete Account")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            Positioned(
              top: 30,
              left: screenSize.width / 8,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: gray_bg,
                backgroundImage: NetworkImage(profilePicUrl),
              ),
            )
          ],
        ),
      ],
    );
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.orange,
      ),
      body: body,
      key: _scaffoldkey,
    );
  }

  //Profile listing api call
  Future<ProfileModel> getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("userId");
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    var myOrdersReqBody = Map<String, dynamic>();
    myOrdersReqBody.addAll({
      "userId": userId,
      "accountType": "customer",
    });
    print(jsonEncode(myOrdersReqBody));
    Result result = await _apiResponse.getProfile(myOrdersReqBody);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    if (result is SuccessState) {
      ProfileModel response = (result).value;
      if (response.status == "success") {
        print(response.message);
        setState(() {
          profileDataModel = response?.profile;
          userName = profileDataModel?.source?.name;
          userCode = profileDataModel?.source?.userCode;
          if (profileDataModel?.source?.image?.length > 0) {
            profilePicUrl = imageBaseURL + profileDataModel?.source?.image[0];
          }
        });
      } else {}
    } else if (result is UnAuthoredState) {
      ProfileModel unAuthoedUser = (result).value;
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

  Future<void> deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId');
    Result result = await _apiResponse
        .deleteAccount({"userId": userId, "userCode": userCode});
    if (result is SuccessState) {
      AppUpdateModel appUpdate = (result).value;
      if (appUpdate.status == "success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("LOGIN", false);
        prefs.setString("token", "");
        prefs.setString("userId", "");
        prefs.setString("pinCode", "");
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => new BottomNavScreen()));
      } else {
        showSnackBar("Failed, please try again later");
      }
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

  showDeleteAlertDialog(BuildContext context) {
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
        deleteAccount();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Account"),
      content: Text("Are you sure you want to delete your account ?"),
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
}

showAlertDialog(BuildContext context) {
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
      _LogOut(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Logout"),
    content: Text("Are you sure you want to logout ?"),
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

Container orangeBG() {
  return Container(
    color: Colors.orange,
    height: 110,
  );
}

Container divider() {
  return Container(
      margin: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
      child: Divider(
        color: Colors.grey.shade200,
      ));
}

_LogOut(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("LOGIN", false);
  prefs.setString("token", "");
  prefs.setString("userId", "");
  prefs.setString("pinCode", "");
  // DartNotificationCenter.unregisterChannel(channel: 'LOGIN');
  // DartNotificationCenter.unregisterChannel(channel: 'cartCount_event');
  // DartNotificationCenter.unregisterChannel(channel: 'getCart');
  Navigator.of(context, rootNavigator: true).pop();
  Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(builder: (context) => new BottomNavScreen()));
}

class Menu {
  static const String Home = 'Home';
  static const String Profile = 'Profile';
  static const String Cart = 'Cart';

  static const List<String> choices = <String>[Home, Profile, Cart];
}
