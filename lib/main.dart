import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:highrich/Screens/Home/bottomNavScreen.dart';
import 'package:highrich/Screens/appUpdate_screen.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:new_version/new_version.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/api.dart';
import 'package:highrich/model/HomeModel/app_update_model.dart';
import 'package:http/src/client.dart';
import 'package:highrich/constants.dart';

/*
 *  2021 Highrich.in
 */

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat-Black',
          unselectedWidgetColor: Colors.grey,
        ),
        home: Inital()
        // AppUpdate(),
        );
  }
}

class Inital extends StatefulWidget {
  @override
  _InitalState createState() => _InitalState();
}

class _InitalState extends State<Inital> {
  bool updateAvailable;
  RemoteDataSource _apiResponse = RemoteDataSource();

  @override
  void initState() {
    checkUpdateAvailable();
    // TODO: implement initState
    super.initState();
  }

  void checkUpdateAvailable() async {
    Result result = await _apiResponse
        .appUpdate({"appType": appType, "appVersion": appVersion});
    if (result is SuccessState) {
      AppUpdateModel appUpdate = (result).value;
      if (appUpdate.status == "success") {
        setState(() {
          updateAvailable = true;
        });
      } else {
        setState(() {
          updateAvailable = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Montserrat-Black', unselectedWidgetColor: Colors.grey),
      home: updateAvailable == null
          ? Container(
              color: Colors.white,
            )
          : updateAvailable == true
              ? AppUpdate()
              : MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  void initState() {
    // checkInternetConnection();

    super.initState();
    DartNotificationCenter.registerChannel(channel: 'LOGIN');
    DartNotificationCenter.registerChannel(channel: 'cartCount_event');
    DartNotificationCenter.registerChannel(channel: 'CARTCOUNT_MODEL');
    DartNotificationCenter.registerChannel(channel: 'getCart');
    DartNotificationCenter.registerChannel(channel: 'GET_CART_NON_DELIVERABLE');
    DartNotificationCenter.registerChannel(channel: 'DELIVERY_ADDRESS');
    DartNotificationCenter.registerChannel(channel: 'NONDELIVERABLE');
    DartNotificationCenter.registerChannel(channel: 'DIALOG_PROFILE');
    DartNotificationCenter.registerChannel(channel: 'GET_ALL_CART');
    DartNotificationCenter.registerChannel(channel: 'UPDATE_PIN_CODE');
    DartNotificationCenter.registerChannel(channel: 'SUBSCRIBE_ADDRESS');
    DartNotificationCenter.registerChannel(channel: 'GET_MY_RETURNS');
    DartNotificationCenter.registerChannel(channel: 'NON_DELIVERABLE_BUTTON');
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: "com.app.highrich",
      // context: context,
      // dialogText: "Please update your app in order to use",
      // dialogTitle: "New update is here",
      // updateText: "Update Now",
      // dismissText: "Exit",
      // dismissAction: () {
      //   SystemNavigator.pop();
      // }
    );
    final status = await newVersion.getVersionStatus();
    if (status.localVersion != status.storeVersion) {
      newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogText: "Please update your app in order to use",
          dialogTitle: "New update is here",
          updateButtonText: "Update Now",
          dismissButtonText: "Exit",
          dismissAction: () {
            SystemNavigator.pop();
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavScreen();
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
