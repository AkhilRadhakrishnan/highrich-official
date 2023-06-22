import 'package:flutter/material.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/model/check_deliverylocation_model.dart';

class SetPinCodeFromList extends StatelessWidget {
  final String pinCode;
  final String enteredPinCode;
   SetPinCodeFromList({Key key, this.pinCode,this.enteredPinCode}) : super(key: key);

  RemoteDataSource _apiResponse = RemoteDataSource();
  bool availability;

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
                          checkDeliveryLocation(context,enteredPinCode);
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
  Future<CheckDeliveryLocationModel> checkDeliveryLocation(
      BuildContext context, String pinCodeCheckAvailability) async {
    Result result =
    await _apiResponse.checkDeliveryLocation(pinCodeCheckAvailability);

    if (result is SuccessState) {
      CheckDeliveryLocationModel checkAvailabilityModel = (result).value;
      if (checkAvailabilityModel.status == "success") {
        availability = checkAvailabilityModel.availability;
        if (availability == true) {
          Timer(Duration(seconds: 1), () {
            print("Yeah, this line is printed after 3 seconds");
            DartNotificationCenter.post(
              channel: "UPDATE_PIN_CODE",
              options: checkAvailabilityModel.pinCode,
            );
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("pinCode", checkAvailabilityModel.pinCode);
          Navigator.pop(context, [checkAvailabilityModel.pinCode]);
        } else {
          Fluttertoast.showToast(
              msg: checkAvailabilityModel.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: checkAvailabilityModel.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else if (result is UnAuthoredState) {
      Fluttertoast.showToast(
          msg: "Failed, please try agian later",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (result is ErrorState) {
      Fluttertoast.showToast(
          msg: "Failed, please try agian later",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
