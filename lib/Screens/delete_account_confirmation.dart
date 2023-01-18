import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/general/default_button.dart';
import 'package:highrich/general/shared_pref.dart';
import 'package:highrich/general/size_config.dart';

import 'login.dart';
/*
 *  2021 Highrich.in
 */
class DeleteAccountSuccessPage extends StatefulWidget {
  @override
  _DeleteAccountSuccessPageState createState() => new _DeleteAccountSuccessPageState();
}

class _DeleteAccountSuccessPageState extends State<DeleteAccountSuccessPage> {
  String email;
  String password;
  bool secureText = true;
  bool isLoading = false;
  var _formKey = GlobalKey<FormState>();
  SharedPref sharedPref = SharedPref();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void _toggleSecure() {
    setState(() {
      secureText = !secureText;
    });
  }

  RemoteDataSource _apiResponse = RemoteDataSource();

  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var body = new Form(
      key: _formKey,
      child: Column(
        children: [
          _title(),
          SizedBox(height: getProportionateScreenHeight(10)),
          _description(),
          SizedBox(height: getProportionateScreenHeight(15)),
          BlueButton(
              text: "DELETE ACCOUNT",
              press:()
              {
                Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));
              }
          ),
          SizedBox(height: getProportionateScreenHeight(15)),
          Container(
            width: double.infinity,
            height: 55,
            child: FlatButton(
              onPressed: ()
              {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              },
              child: Text('CANCEL', style: TextStyle(
                color: colorButtonBlue,fontWeight:  FontWeight.w600
              )
              ),
              textColor: colorButtonBlue,
              shape: RoundedRectangleBorder(side: BorderSide(
                  color: colorButtonBlue,
                  width: 1,
                  style: BorderStyle.solid
              ), ),
            ),
          ),

          SizedBox(height: getProportionateScreenHeight(30)),
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
        child: Padding(
          padding: EdgeInsets.only(top: 70, left: 0, right: 0,bottom: 25),
          child: SingleChildScrollView(
            child: Card(
              shadowColor: Colors.grey,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                padding: EdgeInsets.only(top: 25, left: 16, right: 16,bottom: 25),
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


  Container _title() {
    return Container(
      child: Text(
        "Delete Account?",
        style: TextStyle(
            fontFamily: 'Montserrat-Black',
            fontSize: 22.0,
            color: Colors.black,
            fontWeight: FontWeight.w600),
      ),
      alignment: Alignment.centerLeft,
    );
  }
  Container _description() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text("Do you really want to delete your account?", style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w200),),
            ],
          ),
          Row(
            children: [
              Text("This process cannot be undone.",style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w200),),
            ],
          )
        ],
      ),
      alignment: Alignment.centerLeft,
    );
  }



}