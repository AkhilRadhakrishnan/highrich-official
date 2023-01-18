import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/general/default_button.dart';
import 'package:highrich/general/shared_pref.dart';
import 'package:highrich/general/size_config.dart';

import 'delete_account_confirmation.dart';
/*
 *  2021 Highrich.in
 */
class DeleteAccountPage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;

  const DeleteAccountPage(
      {Key key,
        this.menuScreenContext,
        this.onScreenHideButtonPressed,
        this.hideStatus = false})
      : super(key: key);

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  String email;
  String password;
  bool secureText = true;
  bool isLoading = false;
  var _formKey = GlobalKey<FormState>();
  SharedPref sharedPref = SharedPref();

  void _toggleSecure() {
    setState(() {
      secureText = !secureText;
    });
  }
  RemoteDataSource _apiResponse = RemoteDataSource();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var body = new Form(
      key: _formKey,
      child: Column(
        children: [
          forgotPwdTitle(),
          SizedBox(height: getProportionateScreenHeight(40)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          BlueButton(
              text: "SEND",
              press:()
              {
                Navigator.push(context,MaterialPageRoute(builder: (context) => DeleteAccountSuccessPage()));
              }
          ),
          SizedBox(height: getProportionateScreenHeight(70)),
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
            child:
            GestureDetector(
              onTap: (){
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              },
              child:Container(
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
            child: Text("Delete Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.0,
                    color:Colors.black,
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
            padding:
            EdgeInsets.only(top: 80, left: 0, right: 0, bottom: 0),
            //  child: isLoading ? bodyProgress : body
            child: body,
          ),

        ),
      ),
      key: _scaffoldkey,
    );
  }

  Container forgotPwdTitle() {
    return Container(
      child: Text(
        "Enter registered email address",
        style: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
            fontWeight: FontWeight.w700),
      ),
      alignment: Alignment.centerLeft,
    );
  }

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
            return "enter your email";
          } else if (!emailValidatorRegExp.hasMatch(value)) {
            return "enter valid email";
          }
          return null;
        },
        decoration: InputDecoration(
          //  labelText: "Email",
          hintText: "Email",
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
}