import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:highrich/constants.dart';

class AppUpdate extends StatefulWidget {
  @override
  _AppUpdateState createState() => _AppUpdateState();
}

class _AppUpdateState extends State<AppUpdate> {
  _updatePlayStore() async {
    const url = playstore;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child: Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: SvgPicture.asset(
                "images/logo_highrich.svg",
                height: 50.0,
                width: 10.0,
              ),
            ),
          ),
          SizedBox(height: 10),
          Image.asset(
            "images/updateimage.jpg",
            height: 380,
            width: 380,
          ),
          Text(
            "UPDATE",
            style: TextStyle(
              color: Colors.blue[800],
              fontSize: 24,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 380,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: 50,
            child: Text(
              "App update available..Please update your app inorder to continue..",
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton.icon(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("pinCode", "");
                _updatePlayStore();
                // Respond to button press
              },
              icon: Icon(Icons.settings, size: 18),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Text(
                  'Update App ',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    ));
  }
}
