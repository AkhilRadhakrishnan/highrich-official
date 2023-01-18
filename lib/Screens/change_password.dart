import 'dart:async';

import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/resetpwd_success_paage.dart';
import 'package:highrich/general/constants.dart';

import 'package:highrich/general/custom_dialog.dart';

import 'package:highrich/general/shared_pref.dart';
import 'package:highrich/general/size_config.dart';
import 'package:highrich/model/default_model.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home/home_screen.dart';
/*
 *  2021 Highrich.in
 */
class ChangePasswordPage extends StatefulWidget {
  var emailID;

  ChangePasswordPage({Key key, @required this.emailID}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => new _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ChangePasswordPage> {
  String otp;
  String email;
  FocusScopeNode node;
  bool isLoading = false;
  bool secureText = true;
  bool secureTextNew = true;
  bool secureTextConfirm = true;
  SharedPref sharedPref = SharedPref();
  var _formKey = GlobalKey<FormState>();
  RemoteDataSource _apiResponse = RemoteDataSource();
  String newPassword, confrimPassword, currentPassword;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  @override
  // TODO: implement widget
  void _toggleSecure() {
    setState(() {
      secureText = !secureText;
    });
  }
  void _toggleSecureNew() {
    setState(() {
      secureTextNew = !secureTextNew;
    });
  }
  void _toggleSecureConfirm() {
    setState(() {
      secureTextConfirm = !secureTextConfirm;
    });
  }

  Widget build(BuildContext context) {
    node = FocusScope.of(context);

    SizeConfig().init(context);
    email = widget.emailID;

    var body = new Form(
      key: _formKey,
      child: Column(
        children: [
          pageTitle(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildCurrentPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildConfirmPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          RoundedLoadingButton(
              child: Text('CHANGE PASSWORD',
                  style: TextStyle(color: Colors.white)),
              controller: _btnController,
              width: MediaQuery.of(context).size.width - 60,
              height: 55,
              color: colorButtonBlue,
              //borderRadius: 2,
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                final userId = preferences.getString("userId");
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setState(() {
                    isLoading = true;
                  });
                  Result result = await _apiResponse.change_password(email,
                      currentPassword, newPassword, confrimPassword, userId);
                  setState(() {
                    isLoading = false;
                    _btnController.stop();
                  });
                  if (result is SuccessState) {
                    DefaultModel respnse = (result).value;
                    if (respnse.status == "success") {
                      Fluttertoast.showToast(
                          msg: "Password changed successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pop(context);
                    } else {
                      showSnackBar(respnse.message);
                    }
                  } else if (result is UnAuthoredState) {
                    DefaultModel unAuthoedUser = (result).value;
                    print(unAuthoedUser.message);
                    showSnackBar("Failed, please try agian later");
                  } else if (result is ErrorState) {
                    String errorMessage = (result).msg;
                    showSnackBar("Failed, please try agian later");
                  }
                }
              }),
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
            padding: EdgeInsets.only(top: 30, left: 0, right: 0, bottom: 25),
            child: SingleChildScrollView(
              child: Card(
                shadowColor: Colors.grey,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  padding:
                      EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 25),
                  //  child: isLoading ? bodyProgress : body
                  child: body,
                ),
              ),
            ),
          ),
        ),
        key: _scaffoldkey);
  }

  Container pageTitle() {
    return Container(
      child: Text(
        "Change Password",
        style: TextStyle(
            fontSize: 22.0, color: Colors.black, fontWeight: FontWeight.w800),
      ),
      alignment: Alignment.centerLeft,
    );
  }

  Container buildCurrentPasswordFormField() {
    return Container(
      child: TextFormField(
        obscureText: secureText,
        onSaved: (newValue) => currentPassword = newValue,
        onChanged: (value) {
          currentPassword = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            RoundedButtonDelayStop();
            return kPassNullError;
          } else if (value.length <= 8) {
            RoundedButtonDelayStop();
            return kShortPassError;
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        decoration: InputDecoration(
          // labelText: "Password",
          hintText: "Current Password *",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          suffixIcon: IconButton(
            icon: Icon(secureText ? Icons.visibility_off : Icons.visibility),
            color: Theme.of(context).accentColor,
            iconSize: 20,
            alignment: Alignment.center,
            onPressed: _toggleSecure,
          ),
        ),
      ),
      //  height: 80,
    );
  }

  Container buildPasswordFormField() {
    return Container(
      child: TextFormField(
        obscureText: secureTextNew,
        onSaved: (newValue) => newPassword = newValue,
        onChanged: (value) {
          newPassword = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return;
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        decoration: InputDecoration(
          // labelText: "Password",
          hintText: "New Password *",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          suffixIcon: IconButton(
            icon: Icon(secureTextNew ? Icons.visibility_off : Icons.visibility),
            color: Theme.of(context).accentColor,
            iconSize: 20,
            alignment: Alignment.center,
            onPressed: _toggleSecureNew,
          ),
        ),
      ),
      //  height: 80,
    );
  }

  Container buildConfirmPasswordFormField() {
    return Container(
      child: TextFormField(
        obscureText: secureTextConfirm,
        onChanged: (value) {
          confrimPassword = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            RoundedButtonDelayStop();
            return "confirm password";
          } else if (value != newPassword) {
            RoundedButtonDelayStop();
            print(newPassword);
            return kMatchPassError;
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        decoration: InputDecoration(
          // labelText: "Password",
          hintText: "Confirm Password *",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          suffixIcon: IconButton(
            icon: Icon(secureTextConfirm ? Icons.visibility_off : Icons.visibility),
            color: Theme.of(context).accentColor,
            iconSize: 20,
            alignment: Alignment.center,
            onPressed: _toggleSecureConfirm,
          ),
        ),
      ),
      //  height: 80,
    );
  }

  //Timer to stop button
  void RoundedButtonDelayStop() async {
    Timer(Duration(seconds: 1), () {
      _btnController.stop();
    });
  }

//Display snack bar
  void showSnackBar(String message) {
    final snackBarContent = SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: 'OK',
          onPressed: _scaffoldkey.currentState.hideCurrentSnackBar),
    );
    _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }
}
