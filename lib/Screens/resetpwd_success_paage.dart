import 'dart:async';

import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:highrich/Screens/Home/home_screen.dart';
import 'package:highrich/Screens/login.dart';
import 'package:highrich/general/constants.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Network/remote_data_source.dart';
import '../general/default_button.dart';
import '../general/shared_pref.dart';
import '../general/size_config.dart';
/*
 *  2021 Highrich.in
 */
class ResetPasswordSuccessPage extends StatefulWidget {
  @override
  _ResetPasswordSuccessPageState createState() => new _ResetPasswordSuccessPageState();
}

class _ResetPasswordSuccessPageState extends State<ResetPasswordSuccessPage> {
  String email;
  String password;
  bool secureText = true;
  bool isLoading = false;
  SharedPref sharedPref = SharedPref();
  var _formKey = GlobalKey<FormState>();
  RemoteDataSource _apiResponse = RemoteDataSource();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
  void _toggleSecure() {
    setState(() {
      secureText = !secureText;
    });
  }
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var body = new Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          logo(),
          SizedBox(height: getProportionateScreenHeight(20)),
          pageTitle(),
          SizedBox(height: getProportionateScreenHeight(20)),
          RoundedLoadingButton(
              child: Text('CONTINU TO LOGIN', style: TextStyle(color: Colors.white)),
              controller: _btnController,
              width: MediaQuery.of(context).size.width - 60,
              height: 55,
              color: colorButtonBlue,
             // borderRadius: 2,
              onPressed: ()
              {
                _btnController.success();
                Timer(Duration(seconds: 1), () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool("LOGIN", false);
                  prefs.setString("token", "");
                  prefs.setString("userId", "");
                  prefs.setString("pinCode", "");
                  DartNotificationCenter.unregisterChannel(channel: 'LOGIN');
                  DartNotificationCenter.unregisterChannel(channel: 'cartCount_event');
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(

                          builder: (BuildContext context) => LoginPage(fromPage: null)), (Route<dynamic> route) => false);

                });

              }
          ),

          SizedBox(height: getProportionateScreenHeight(50)),
        ],
      ),
    );

    return new Scaffold(
      backgroundColor: Colors.white,
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
      body: Container(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 80, left: 0, right: 0,bottom: 25),
          child: SingleChildScrollView(
            child: Card(
              shadowColor: Colors.grey,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                padding: EdgeInsets.only(top: 25, left: 18, right: 18,bottom: 25),
                //  child: isLoading ? bodyProgress : body
                child: body,
              ),
            ),
          ),
        ),
      ),
      key:_scaffoldkey
    );
  }


  Container logo() {
    return Container(
      child: SvgPicture.asset("images/success_img.svg"),

      alignment: Alignment.center,
    );
  }

  //Page Title
  Container pageTitle() {
    return Container(
      child: Text(
        "Password Reset Successfully!",
        style: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
            fontWeight: FontWeight.w700),
      ),
      alignment: Alignment.center,
    );
  }

}