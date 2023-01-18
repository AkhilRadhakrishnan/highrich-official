import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/material.dart';
import 'package:highrich/Screens/Home/cart.dart';
import 'package:highrich/Screens/login.dart';
import 'package:highrich/general/shared_pref.dart';
/*
 *  2021 Highrich.in
 */
class CartMainScreen extends StatefulWidget {
  @override
  _CartMainScreenState createState() => _CartMainScreenState();
}

class _CartMainScreenState extends State<CartMainScreen> {

  String token = '';
  bool isHaveToken;

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
    DartNotificationCenter.subscribe(channel: 'LOGIN', observer: this, onNotification: (result) {
      loadSharedPrefs();
    });
  }

  Future<void> loadSharedPrefs() async {
    await SharedPref.shared.getToken().then((value) {
      token = value;
      if (token != null && token != ("null") && token != "") {
        setState(() {
          isHaveToken = true;
        });
      } else {
        setState(() {
          isHaveToken = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isHaveToken == null? Container(): isHaveToken ? CartPage(deleteNoDeliverableBtnFlag: false,):CartPage(deleteNoDeliverableBtnFlag: false,),
    );
  }
}
