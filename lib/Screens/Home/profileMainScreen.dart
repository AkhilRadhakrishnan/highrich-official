import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/material.dart';
import 'package:highrich/Screens/Home/cart.dart';
import 'package:highrich/Screens/Home/profile.dart';
import 'package:highrich/Screens/login.dart';
import 'package:highrich/general/shared_pref.dart';

class ProfileMainScreen extends StatefulWidget {
  @override
  _ProfileMainScreenState createState() => _ProfileMainScreenState();
}

class _ProfileMainScreenState extends State<ProfileMainScreen> {
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
      child: isHaveToken == null? Container(): isHaveToken ? ProfilePage(): LoginPage(),
    );
  }
}
