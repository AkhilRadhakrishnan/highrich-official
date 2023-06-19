import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPinCodeFromList extends StatelessWidget {
  final String pinCode;
  const SetPinCodeFromList({Key key, this.pinCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.white,
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Product not available at pincode",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Nearest available pincode : ",
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black26,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      pinCode,
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  "Do you want to change to this pincode?",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black26,
                      fontWeight: FontWeight.normal),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("No")),
                    TextButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("pinCode", pinCode);
                          Navigator.of(context).pop("pincode");
                        },
                        child: Text("Yes")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
