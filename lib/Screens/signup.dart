import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:highrich/Screens/Home/cart.dart';
import 'package:highrich/Screens/Home/profile.dart';
import 'package:highrich/Screens/login.dart';
import 'package:highrich/model/default_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libphonenumber/libphonenumber.dart';
import '../Network/remote_data_source.dart';
import '../Network/result.dart';
import 'Home/bottomNavScreen.dart';
import 'Home/home_screen.dart';
import '../general/constants.dart';
import '../general/default_button.dart';
import '../general/shared_pref.dart';
import '../general/size_config.dart';
import 'package:highrich/general/globals.dart' as globals;

/*
 *  2021 Highrich.in
 */
class SignUpPage extends StatefulWidget {
  String highRichId;
  SignUpPage(this.highRichId);
  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email;
  String refId;
  String pinCode;
  String password;
  String fullName;
  String highRichId;
  String phoneNumber;
  FocusScopeNode node;
  String countryCode = "91";
  String confirmPassword;
  bool isLoading = false;
  bool passwordVisiblity = true;
  bool confirmPasswordVisiblity = true;
  var _formKey = GlobalKey<FormState>();
  SharedPref sharedPref = SharedPref();
  var reqBody = Map<String, dynamic>();
  RemoteDataSource _apiResponse = RemoteDataSource();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void _toggleSecure() {
    setState(() {
      passwordVisiblity = !passwordVisiblity;
    });
  }

  void _toggleSecureConfirm() {
    setState(() {
      confirmPasswordVisiblity = !confirmPasswordVisiblity;
    });
  }

  @override
  void initState() {
    super.initState();
    highRichId = widget.highRichId;
    DartNotificationCenter.subscribe(
        channel: 'LOGIN',
        observer: this,
        onNotification: (result) {
          if (globals.currentIndexBottomNav == 3) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => CartPage()),
                (Route<dynamic> route) => false);
          } else if (globals.currentIndexBottomNav == 2) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => ProfilePage()),
                (Route<dynamic> route) => false);
          }

          // setState(() {
          //   globals.currentIndexBottomNav=3;
          // });
          //
        });
  }

  Widget build(BuildContext context) {
    node = FocusScope.of(context);
    SizeConfig().init(context);

    var body = new Form(
      key: _formKey,
      child: Column(
        children: [
          logInTitle(),
          SizedBox(height: getProportionateScreenHeight(14)),
          buildFullNameFormField(),
          SizedBox(height: getProportionateScreenHeight(11)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(11)),
          Row(
            //Center Row contents vertically,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CountryCodePicker(
                  onChanged: (value) {
                    countryCode = "91";
                  },
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: '+91',
                  favorite: ['+91', 'IN'],
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                ),
              ),
              Expanded(
                child: buildPhoneNumberFormField(),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(11)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(11)),
          buildConfirmPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(11)),
          buildRefIdFormField(),
          SizedBox(height: getProportionateScreenHeight(11)),
          buildPinCodeFormField(),
          SizedBox(height: getProportionateScreenHeight(26)),
          BlueButton(
            text: "SIGN UP",
            press: () async {
              bool checkConnection =
                  await DataConnectionChecker().hasConnection;
              if (checkConnection == true) {
                print("password is ${password},$confirmPassword,$email");
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  phoneNumber = countryCode + phoneNumber;
                  reqBody.addAll({
                    "name": fullName,
                    "email": email,
                    "mobile": phoneNumber,
                    "password": confirmPassword,
                    "pinCode": pinCode,
                    "affiliateId": refId,
                    "accountType": "customer"
                    // "highRichId": highRichId
                  });
                  setState(() {
                    isLoading = true;
                  });
                  json.encode(reqBody);
                  Result result = await _apiResponse.signup(reqBody);
                  setState(() {
                    isLoading = false;
                  });
                  if (result is SuccessState) {
                    DefaultModel user = result.value;
                    print(user.status);
                    if (user.status == "success") {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => LoginPage()),
                          (Route<dynamic> route) => false);
                      // _showAlert("Signup Success", user.message);
                    } else {
                      _showAlert("Sorry", user.message);
                    }
                  } else if (result is UnAuthoredState) {
                    DefaultModel unAuthoedUser = (result).value;
                    print(unAuthoedUser.message);
                    return _showAlert('Sorry', unAuthoedUser.message);
                  } else if (result is ErrorState) {
                    String errorMessage = (result).msg;
                    return _showAlert('Sorry', errorMessage);
                  }
                }
              } else {
                _showAlert("No internet connection",
                    "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.");
              }
            },
          ),
          SizedBox(height: getProportionateScreenHeight(26)),
          signIn(), //sign_up
          SizedBox(height: getProportionateScreenHeight(10)),
        ],
      ),
    );

    return new Scaffold(
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
        body: SafeArea(
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: isLoading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 14.0),
                      child: Column(
                        children: [
                          Card(
                            // margin: EdgeInsets.only(top: 5),
                            color: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 60,
                              padding: EdgeInsets.only(
                                  top: 25, left: 25, right: 25, bottom: 25),
                              //  child: isLoading ? bodyProgress : body
                              child: body,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
            ),
          ),
        ),
        key: _scaffoldkey);
  }

  Container logInTitle() {
    return Container(
      child: Text(
        "Sign Up",
        style: TextStyle(
            fontFamily: 'Montserrat-Black',
            fontSize: 25.0,
            color: Colors.black,
            fontWeight: FontWeight.w700),
      ),
      alignment: Alignment.centerLeft,
    );
  }

  Container buildFullNameFormField() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.text,
        style: TextStyle(fontFamily: 'Montserrat-Black'),
        onChanged: (value) {
          fullName = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return kNamelNullError;
          } else if (!nameRegex.hasMatch(value)) {
            return kNameValidError;
          } else {
            return null;
          }
        },
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ' ']"))
        ],
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        decoration: InputDecoration(
          hintText: "Full Name *",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      //   height: 80,
    );
  }

  Container buildEmailFormField() {
    return Container(
      child: TextFormField(
        style: TextStyle(fontFamily: 'Montserrat-Black'),
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          email = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return kEmailNullError;
          } else if (!emailValidatorRegExp.hasMatch(value)) {
            return kInvalidEmailError;
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        decoration: InputDecoration(
          hintText: "Email ID *",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      //   height: 80,
    );
  }

  Container buildPhoneNumberFormField() {
    return Container(
      child: TextFormField(
        style: TextStyle(fontFamily: 'Montserrat-Black'),
        keyboardType: TextInputType.phone,
        maxLength: 10,
        onChanged: (value) {
          phoneNumber = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return kPhoneNumberNullError;
          } else if (!phoneRegex.hasMatch(value)) {
            return kPhoneNumberValidError;
          } else if (value.length < 10) {
            return kPhoneNumberValidError;
          }
          return null;
        },
        inputFormatters: <TextInputFormatter>[
          new FilteringTextInputFormatter.allow(phoneRegex),
        ],
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        decoration: InputDecoration(
          hintText: "Phone Number *",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      //   height: 80,
    );
  }

  Container buildPasswordFormField() {
    return Container(
      child: TextFormField(
        style: TextStyle(fontFamily: 'Montserrat-Black'),
        obscureText: passwordVisiblity,
        onChanged: (value) {
          password = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return kPassNullError;
          } else if (value.length <= 8) {
            return kShortPassError;
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        decoration: InputDecoration(
          hintText: "Password *",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisiblity ? Icons.visibility_off : Icons.visibility,
              color: Colors.black,
            ),
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

  Container buildConfirmPasswordFormField() {
    return Container(
      child: TextFormField(
        style: TextStyle(fontFamily: 'Montserrat-Black'),
        obscureText: confirmPasswordVisiblity,
        onChanged: (value) {
          confirmPassword = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return kConfirmPassNullError;
          } else if (value != password) {
            print(password);
            return kMatchPassError;
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        decoration: InputDecoration(
          hintText: "Confirm Password *",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              confirmPasswordVisiblity
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.black,
            ),
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

  Container buildRefIdFormField() {
    return Container(
      child: TextFormField(
        style: TextStyle(fontFamily: 'Montserrat-Black'),
        keyboardType: TextInputType.phone,
        onChanged: (value) {
          refId = value;
        },
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        decoration: InputDecoration(
          hintText: "Referral ID",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      //   height: 80,
    );
  }

  Container buildPinCodeFormField() {
    return Container(
      child: TextFormField(
        style: TextStyle(fontFamily: 'Montserrat-Black'),
        validator: (value) {
          if (value.isEmpty) {
            return kPinCodeNullError;
          } else if (value.length < 6) {
            return kPinCodeValidError;
          }
          return null;
        },
        maxLength: 6,
        onChanged: (value) {
          pinCode = value;
        },
        inputFormatters: <TextInputFormatter>[
          new FilteringTextInputFormatter.allow(phoneRegex),
        ],
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "PIN Code *",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      //   height: 80,
    );
  }

  Container signIn() {
    return Container(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
            // onTap: () => Navigator.pushNamed(
            //     context, ForgotPasswordScreen.routeName),
            child: RichText(
              text: new TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: new TextStyle(
                  fontSize: 14.0,
                ),
                children: <TextSpan>[
                  new TextSpan(
                      text: 'Already in ',
                      style: new TextStyle(color: Colors.black)),
                  new TextSpan(
                      text: 'Highrich?',
                      style: new TextStyle(color: colorOrange)),
                  new TextSpan(
                      text: ' LOGIN',
                      style: new TextStyle(color: Colors.black)),
                ],
              ),
            )));
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
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (title == "Signup Success") {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()),
                      (Route<dynamic> route) => false);
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
