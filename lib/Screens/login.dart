import 'dart:async';

import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:highrich/Screens/Home/cart.dart';
import 'package:highrich/Screens/Home/home_screen.dart';
import 'package:highrich/Screens/Home/profile.dart';
import 'package:highrich/Screens/forgot_password.dart';
import 'package:highrich/Screens/product_detail_page.dart';
import 'package:highrich/Screens/signup.dart';
import 'package:highrich/general/app_config.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/model/LogInModel.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Network/remote_data_source.dart';
import '../Network/result.dart';
import '../general/default_button.dart';
import '../general/shared_pref.dart';
import '../general/size_config.dart';
import 'Home/bottomNavScreen.dart';

class LoginPage extends StatefulWidget {
  String fromPage;
  String product_id;
  LoginPage({@required this.fromPage, this.product_id});

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String fromPage;
  String password;
  String product_id;
  FocusScopeNode node;
  bool secureText = true;
  bool isLoading = false;
  SharedPref sharedPref = SharedPref();
  var _formKey = GlobalKey<FormState>();

  void _toggleSecure() {
    setState(() {
      secureText = !secureText;
    });
  }

  RemoteDataSource _apiResponse = RemoteDataSource();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  void initState() {
    loadSharedPrefs();
    super.initState();
    fromPage = widget.fromPage;
    product_id = widget.product_id;
    DartNotificationCenter.subscribe(
        channel: 'LOGIN',
        observer: this,
        onNotification: (result) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
  }

  Future<void> loadSharedPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    email = preferences.getString("userName");
    password = preferences.getString("password");

    if (email != null && email != ("null")) {
      userNameController.text = email;
    }
    if (password != null && password != ("null")) {
      passwordController.text = password;
    }
  }

  Widget build(BuildContext context) {
    node = FocusScope.of(context);

    SizeConfig().init(context);

    var body = new Form(
      key: _formKey,
      child: Column(
        children: [
          logInTitle(),
          SizedBox(height: getProportionateScreenHeight(40)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          forgotPasswordField(),
          SizedBox(height: getProportionateScreenHeight(30)),

          RoundedLoadingButton(
              child: Text('LOGIN', style: TextStyle(color: Colors.white)),
              controller: _btnController,
              width: MediaQuery.of(context).size.width - 60,
              height: 55,
              color: colorButtonBlue,
              //  borderRadius: 2,
              onPressed: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                bool checkConnection =
                    await DataConnectionChecker().hasConnection;
                if (checkConnection == true) {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() {
                      isLoading = true;
                    });

                    Result result = await _apiResponse.login(email, password);
                    setState(() {
                      isLoading = false;
                      _btnController.stop();
                    });
                    if (result is SuccessState) {
                      LogInModel user = (result).value;
                      if (user.status == "success") {
                        if (user.type == "NEW") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage(
                                        user.highRichId,
                                      )));
                        } else {
                          DartNotificationCenter.post(channel: 'LOGIN');
                          AppConfig.isAuthorized = true;
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool("LOGIN", true);
                          prefs.setString("token", user.token);
                          prefs.setString("userId", user.userId);
                          //prefs.setString("pinCode", user.pinCode);
                          prefs.setString("userName", email);
                          prefs.setString("password", password);

                          //prefs.setString("highrichID", user.highRichId);

                          // print(user.token);
                          // await SharedPref.shared.setToken(user.token);
                          int count = await prefs.getInt("guestCartCount");
                          if (count != null) {
                            int guestCartCount =
                                await prefs.getInt("guestCartCount");
                            if (guestCartCount > 0) {
                              DartNotificationCenter.post(
                                  channel: 'GET_ALL_CART');
                            }
                          } else {
                            DartNotificationCenter.post(channel: 'getCart');
                          }
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context, user.token);
                            print("pOP");
                          } else {
                            print("PdOP");
                            print("CAN'T POP SCREEN");
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) =>
                                        new BottomNavScreen()));
                          }
                        }
                      } else {
                        _showAlert("Sorry", user.message);
                      }
                    } else if (result is UnAuthoredState) {
                      LogInModel unAuthoedUser = (result).value;
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
              }),
          SizedBox(height: getProportionateScreenHeight(30)),
          signUp(), //sign_up
          SizedBox(height: getProportionateScreenHeight(70)),
        ],
      ),
    );
//Timer to stop button

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
              child: Card(
                shadowColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width - 60,
                  padding:
                      EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 25),
                  //  child: isLoading ? bodyProgress : body
                  child: body,
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
        "Login",
        style: TextStyle(
            fontFamily: 'Montserrat-Medium',
            fontSize: 25.0,
            color: Colors.black,
            fontWeight: FontWeight.bold),
      ),
      alignment: Alignment.centerLeft,
    );
  }

  Container buildEmailFormField() {
    return Container(
      child: TextFormField(
        style: TextStyle(fontFamily: 'Montserrat-Black'),
        keyboardType: TextInputType.emailAddress,
        controller: userNameController,
        onSaved: (newValue) => email = newValue,
        onChanged: (value) {
          return null;
        },
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              RoundedButtonDelayStop();
            });
            return "enter your email";
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        decoration: InputDecoration(
          //  labelText: "Email",
          hintText: "Email / Highrich ID*",
          hintStyle: TextStyle(color: Colors.grey),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2.0),
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
      //   height: 80,
    );
  }

  Container buildPasswordFormField() {
    return Container(
      child: TextFormField(
        style: TextStyle(fontFamily: 'Montserrat-Black'),
        obscureText: secureText,
        controller: passwordController,
        onSaved: (newValue) => password = newValue,
        onChanged: (value) {
          return null;
        },
        validator: (value) {
          if (value.isEmpty) {
            return "enter password";
            setState(() {
              RoundedButtonDelayStop();
            });
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        decoration: InputDecoration(
          // labelText: "Password",
          hintText: "Password *",
          hintStyle: TextStyle(color: Colors.grey),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2.0),
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

  void RoundedButtonDelayStop() async {
    Timer(Duration(seconds: 1), () {
      _btnController.stop();
    });
  }

  Container forgotPasswordField() {
    return Container(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ForGotPwdPage()));
          },

          // onTap: () => Navigator.pushNamed(
          //     context, ForgotPasswordScreen.routeName),
          child: InkWell(
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Montserrat-Black',
                  fontWeight: FontWeight.w600),
            ),
          ),
        )); //forgot_password
  }

  Container signUp() {
    return Container(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              print('Sign Up');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpPage("")));
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
                      text: 'New to ',
                      style: new TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600)),
                  new TextSpan(
                      text: 'Highrich?',
                      style: new TextStyle(
                          color: colorOrange, fontWeight: FontWeight.w600)),
                  new TextSpan(
                      text: ' REGISTER',
                      style: new TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600)),
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
