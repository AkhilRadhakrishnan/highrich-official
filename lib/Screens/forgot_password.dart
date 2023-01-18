import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/reset_password.dart';
import 'package:highrich/model/default_model.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Network/remote_data_source.dart';
import 'Home/home_screen.dart';
import '../general/constants.dart';
import '../general/default_button.dart';
import '../general/shared_pref.dart';
import '../general/size_config.dart';
/*
 *  2021 Highrich.in
 */
class ForGotPwdPage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;

  const ForGotPwdPage(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  _ForGotPwdPageState createState() => _ForGotPwdPageState();
}

class _ForGotPwdPageState extends State<ForGotPwdPage> {
  String email;
  String password;
  bool secureText = true;
  bool isLoading = false;
  SharedPref sharedPref = SharedPref();
  var _formKey = GlobalKey<FormState>();
  RemoteDataSource _apiResponse = RemoteDataSource();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  Widget build(BuildContext context) {
    SizeConfig().init(context);

    //Body part of forgot password
    var body = new Form(
      key: _formKey,
      child: Column(
        children: [
          forgotPwdTitle(),
          SizedBox(height: getProportionateScreenHeight(40)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          RoundedLoadingButton(
            child: Text('SEND', style: TextStyle(color: Colors.white)),
            controller: _btnController,
            width: MediaQuery.of(context).size.width - 60,
            height: 55,
            color: colorButtonBlue,
           // borderRadius: 2,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                setState(() {
                  isLoading = true;
                });
                Result result = await _apiResponse.forgot_password(email);
                setState(() {
                  isLoading = false;
                  _btnController.stop();
                });

                if (result is SuccessState) {
                  DefaultModel respnse = (result).value;
                  if (respnse.status == "success") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetPasswordPage(
                            emailID: email,
                          ),
                        ));
                    Fluttertoast.showToast(
                        msg: respnse.message,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    // ShowAlert(title: "Success",message:respnse.message,
                    //   press: () async{
                    //     Navigator.of(context).pop();
                    //   },);

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
            },
          ),
          SizedBox(height: getProportionateScreenHeight(70)),
        ],
      ),
    );

    return new Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldkey,
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
            child: Text("Forgot Password",
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
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width - 60,
            padding: EdgeInsets.only(top: 100, left: 0, right: 0, bottom: 0),
            //  child: isLoading ? bodyProgress : body
            child: body,
          ),
        ),
      ),
    );
  }

  //Forgot password titile
  Container forgotPwdTitle() {
    return Container(
      child: Text(
        "Enter registered email address",
        style: TextStyle(
            fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w700),
      ),
      alignment: Alignment.centerLeft,
    );
  }

  //Email
  Container buildEmailFormField() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        onSaved: (newValue) => email = newValue,
        onChanged: (value) {
          return null;
        },
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              RoundedButtonDelayStop();
            });
            return "Enter your email";
          } else if (!emailValidatorRegExp.hasMatch(value)) {
            setState(() {
              RoundedButtonDelayStop();
            });
            return "Enter valid email";
          }
          return null;
        },
        decoration: InputDecoration(
          //  labelText: "Email",
          hintText: "Email *",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
      //   height: 80,
    );
  }

//Timer to stop button
  void RoundedButtonDelayStop() async {
    Timer(Duration(seconds: 1), () {
      _btnController.stop();
    });
  }

//Display snack bar
  //Display snack bar
  void showSnackBar(String message) {
    final snackBarContent = SnackBar(
     // padding: EdgeInsets.only(bottom:16.0),
      content: Text(message),
      action: SnackBarAction(
          label: 'OK',
          onPressed: _scaffoldkey.currentState.hideCurrentSnackBar),
    );
    _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }
}
