import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/Home/cartMainScreen.dart';
import 'package:highrich/Screens/Home/category.dart';
import 'package:highrich/Screens/Home/home_screen.dart';
import 'package:highrich/Screens/Home/profileMainScreen.dart';
import 'package:highrich/general/app_config.dart';
import 'package:highrich/general/globals.dart' as globals;
import 'package:highrich/general/shared_pref.dart';
import 'package:highrich/model/CartModel/cart_count_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 *  2021 Highrich.in
 */
class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  String token;
  int _cartCount = 0;
  bool isLoading = false;
  DateTime currentBackPressTime;
  RemoteDataSource _apiResponse = RemoteDataSource();
  final CupertinoTabController _controller = CupertinoTabController();
  final GlobalKey<NavigatorState> homeNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> cartNavkey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> profileNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> categoriesnavKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    loadSharedPrefs();
    getAuthorizationStatus();
    super.initState();

    DartNotificationCenter.subscribe(
        channel: "cartCount_event",
        observer: this,
        onNotification: (result) {
          print("cartCount_event");
          loadSharedPrefs().then((value) {
            if (token != null && token != ("null") && token != "") {
              getCartCount();
            } else {
              getGuestCartCount();
            }
          });
        });
  }

  //For getting cart count of Guest user
  getGuestCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(mounted) {
      setState(() {
      if (prefs.getInt("guestCartCount") != null) {
        _cartCount = prefs.getInt("guestCartCount");
      } else {
        _cartCount = 0;
      }
    });
    }
  }

  getAuthorizationStatus()async{
     await SharedPref.shared.getLogin().then((value) {
       AppConfig.isAuthorized = value;
     });
  }

  Future<void> loadSharedPrefs() async {
    token = await SharedPref.shared.getToken();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: CupertinoTabScaffold(
          controller: _controller,
          tabBar: CupertinoTabBar(
            currentIndex: globals.currentIndexBottomNav,
            onTap: (index) async {
              bool checkConnection =
                  await DataConnectionChecker().hasConnection;
              if (checkConnection == true) {
                setState(() {
                  globals.currentIndexBottomNav = index;
                  _controller.index = index;
                });
              } else {
                _showAlert("No internet connection",
                    "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.");
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset('images/ic_home.svg'),
                activeIcon: SvgPicture.asset('images/ic_home_selected.svg'),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('images/ic_category.svg'),
                activeIcon: SvgPicture.asset('images/category_orange.svg'),
              ),
              BottomNavigationBarItem(
                icon: Stack(children: <Widget>[
                  Container(
                    height: 70,
                    width: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset('images/ic_cart.svg'),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    top: 1,
                    child: _cartCount != null && _cartCount != 0
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: new Text(
                              _cartCount?.toString(),
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(),
                  )
                ]),
                activeIcon: Stack(children: <Widget>[
                  Container(
                    height: 70,
                    width: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset('images/cart_orange.svg'),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    top: 1,
                    child: _cartCount != null && _cartCount != 0
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: new Text(
                              _cartCount.toString(),
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(),
                  )
                ]),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('images/ic_profile.svg'),
                activeIcon:
                    SvgPicture.asset('images/profile_bottom_orange.svg'),
              ),
            ],
          ),
          tabBuilder: (context, index) {
            if (index == 0) {
              return CupertinoTabView(
                navigatorKey: homeNavKey,
                builder: (BuildContext context) => HomePage(),
              );
            } else if (index == 1) {
              return CupertinoTabView(
                navigatorKey: categoriesnavKey,
                builder: (BuildContext context) => CategoryPage(),
              );
            } else if (index == 2) {
              return CupertinoTabView(
                navigatorKey: cartNavkey,
                builder: (BuildContext context) => CartMainScreen(),
              );
            } else {
              return CupertinoTabView(
                navigatorKey: profileNavKey,
                builder: (BuildContext context) => ProfileMainScreen(),
              );
            }
          },
        ),
        onWillPop: () async {
          DateTime now = DateTime.now();
          if (globals.currentIndexBottomNav == 0) {
            if (await homeNavKey.currentState.maybePop()) {
              return Future.value(false);
            } else {
              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime) > Duration(seconds: 2)) {
                currentBackPressTime = now;
                Fluttertoast.showToast(msg: "Please tap again to exit app");
                return Future.value(false);
              }
              return Future.value(true);
            }
          } else {
            switch (globals.currentIndexBottomNav) {
              case 1:
                if (await categoriesnavKey.currentState.maybePop()) {
                  return Future.value(false);
                } else {
                  setState(() {
                    globals.currentIndexBottomNav = 0;
                    _controller.index = 0;
                  });
                  return Future.value(false);
                }
                break;
              case 2:
                if (await cartNavkey.currentState.maybePop()) {
                  return Future.value(false);
                } else {
                  setState(() {
                    globals.currentIndexBottomNav = 0;
                    _controller.index = 0;
                  });
                  return Future.value(false);
                }
                break;
              case 3:
                if (await profileNavKey.currentState.maybePop()) {
                  return Future.value(false);
                } else {
                  setState(() {
                    globals.currentIndexBottomNav = 0;
                    _controller.index = 0;
                  });
                  return Future.value(false);
                }
                break;
            }
            return Future.value(true);
          }
        });
  }

  //Cart Count API Call
  Future<CartCountModel> getCartCount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    String userId = preferences.getString("userId");

    Result result = await _apiResponse.getCartCount(userId);

    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      CartCountModel cartCountModel = (result).value;
      if (cartCountModel.status == "success") {
        setState(() {
          print("CART COUT IS : " + cartCountModel.cartCount.toString());
          _cartCount = cartCountModel?.cartCount;
        });
        DartNotificationCenter.post(
          channel: "CARTCOUNT_MODEL",
          options: cartCountModel,
        );
      } else {
        // showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      CartCountModel unAuthoedUser = (result).value;
      // showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      // showSnackBar("Failed, please try agian later");
    }
  }
}
