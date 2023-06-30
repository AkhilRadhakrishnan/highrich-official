import 'dart:async';

import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/general/default_button.dart';
import 'package:highrich/model/check_deliverylocation_model.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 *  2021 Highrich.in
 */
class SetPincodeFromProductDialog extends StatelessWidget {
  final List<String> serviceLocations;
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  RemoteDataSource _apiResponse = RemoteDataSource();
  bool availability;

  SetPincodeFromProductDialog({
    Key key,
    this.message,
    this.serviceLocations,
  }) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  String pinCode;

  _loadPinCodeInDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pinCode = (prefs.getString('pinCode') ?? '');
    if (pinCode == defaultPincode) {
      pinCode = "";
    }
  }

  Widget dialogContent(BuildContext context) {
    final node = FocusScope.of(context);
    TextEditingController controllerPnCode = new TextEditingController();
    controllerPnCode.text = pinCode;
    _loadPinCodeInDialog();
    return WillPopScope(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 0.0, right: 0.0),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 0.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // SizedBox(
                      //   height: 12.0,
                      // ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () async {
                              if (pinCode != null &&
                                  pinCode != ("null") &&
                                  pinCode != ("")) {
                                Navigator.pop(context);
                              } else {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString("pinCode", defaultPincode);
                                Navigator.pop(context);
                              }
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      new Text("Your Delivery Pincode",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 4,
                      ),
                      new Text(
                          "Enter your pincode to check availability and faster delivery options",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black26,
                              fontWeight: FontWeight.normal)),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        style: TextStyle(
                            fontFamily: 'Montserrat-Black',
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        //  onSaved: (newValue) => email = newValue,
                        controller: controllerPnCode,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.go,
                        onEditingComplete: () => node.nextFocus(),
                        decoration: InputDecoration(
                          hintText: "Pin Code",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      RoundedLoadingButton(
                          child:
                              Text('GO', style: TextStyle(color: Colors.white)),
                          controller: _btnController,
                          width: MediaQuery.of(context).size.width - 60,
                          height: 50,
                          color: colorButtonBlue,
                          //  borderRadius: 2,
                          onPressed: () async {
                            if (controllerPnCode.text.length == 6) {
                              if (controllerPnCode.text != null &&
                                  controllerPnCode.text != ("null") &&
                                  controllerPnCode.text != ("")) {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    "pinCode", controllerPnCode.text.trim());
                                final res = await checkDeliveryLocationFromList(
                                    context,
                                    controllerPnCode.text,
                                    serviceLocations);
                                print(res);
                                if (res != null) {
                                  if (res == controllerPnCode.text.trim()) {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString("pinCode", res);
                                    Navigator.of(context).pop("pincode");
                                  } else {
                                    Navigator.of(context).pop(
                                        [res, controllerPnCode.text.trim()]);
                                  }
                                } else {
                                  Navigator.of(context).pop();
                                }
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please enter a valid pincode",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              RoundedButtonDelayStop();
                            }
                          }),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onWillPop: () async {
          if (pinCode != null && pinCode != ("null") && pinCode != ("")) {
            Navigator.pop(context);
          } else {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("pinCode", defaultPincode);
            Navigator.pop(context);
          }
        });
  }

  //Timer to stop button
  void RoundedButtonDelayStop() async {
    Timer(Duration(seconds: 1), () {
      _btnController.stop();
    });
  }

  int findNearestValue(List<int> numbers, int target) {
    int nearest = numbers[0];
    int difference = (numbers[0] - target).abs();
    for (int i = 1; i < numbers.length; i++) {
      int currentDifference = (numbers[i] - target).abs();
      if (currentDifference < difference) {
        nearest = numbers[i];
        difference = currentDifference;
      }
    }
    return nearest;
  }

  Future<String> checkDeliveryLocationFromList(BuildContext context,
      String pinCodeCheckAvailability, List<String> locations) async {
    if (locations == null || locations.isEmpty) {
      return null;
    } else if (locations[0] != null && locations[0] == "All India") {
      return pinCodeCheckAvailability.trim();
    } else {
      List<int> intStringPincodes = locations.map(int.parse).toList();
      int value = int.parse(pinCodeCheckAvailability);
      int nearestValue = findNearestValue(intStringPincodes, value);
      return nearestValue.toString();
    }
  }

  Future<CheckDeliveryLocationModel> checkDeliveryLocation(
      BuildContext context, String pinCodeCheckAvailability) async {
    RoundedButtonDelayStop();
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

          // Navigator.pop(context);
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
