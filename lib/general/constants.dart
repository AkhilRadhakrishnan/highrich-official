
/*
 *  2021 Highrich.in
 */

import 'dart:io';
import 'dart:ui';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highrich/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

 const colorBlue = Color(0xFF3E6DF3);
 const colorButtonBlue = Color(0xFF3e6df3);
const colorOrange = Color(0xFFFF5B15);
const colorButtonOrange = Color(0xFFff5b15);
const colorDarkYellow = Color(0xFFf5b247);
const teleBottomLineColor = Colors.black12;
const liteGray = Color(0xFFEDEDED);
const gray_bg = Color(0xFFEEEEEE);
const temp = Colors.grey;
const colorCyan = Color(0xFF55EFB7);




// Form Error
final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final phoneRegex = RegExp("[0-9]");
final nameRegex = RegExp("[a-zA-Z]");
const String kEmailNullError = "Enter your email";
const String kInvalidEmailError = "Enter Valid Email";
const String kPassNullError = "Enter your password";
const String kConfirmPassNullError = "confirm your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Enter your name";
const String kPhoneNumberNullError = "Enter your phone number";
const String kAddressNullError = "Enter your address";
const String kPhoneNumberValidError = "Enter a valid phone number";
const String kPinCodeNullError = "Enter your pin code";
const String kPinCodeValidError = "Enter a valid pin code";
const String kNameValidError = "Enter a valid name";



const String baseURL=api_url;
const String imageBaseURL=s3_url;

const String defaultPincode="";

showToast(String message)
{
 Fluttertoast.showToast(
     msg:message,
     toastLength: Toast.LENGTH_SHORT,
     gravity: ToastGravity.CENTER,
     timeInSecForIosWeb: 1,
     backgroundColor: Colors.black,
     textColor: Colors.white,
     fontSize: 16.0);
}


checkInternetConnection() async{
 try {
  final result = await InternetAddress.lookup('google.com');
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
   print('connected');
   return true;
  }
  else
   {
    return false;
   }
 } on SocketException catch (_) {
  print('not connected');
  return false;
 }
}

const stateSuggestions = [
  "ANDAMAN AND NICOBAR ISLANDS",
"ANDHRA PRADESH",
"ARUNACHAL PRADESH",
"ASSAM",
"BIHAR",
"CHANDIGARH",
"CHATTISGARH",
"DAMAN & DIU",
"DELHI",
"GOA",
"GUJARAT",
"HIMACHAL PRADESH",
"JAMMU & KASHMIR",
"JHARKHAND",
"KARNATAKA",
"KERALA",
"LAKSHADWEEP",
"LADAKH",
"MADHYA PRADESH",
"MAHARASHTRA",
"MANIPUR",
"MEGHALAYA",
"MIZORAM",
"NAGALAND",
"ODISHA",
"PONDICHERRY",
"PUNJAB",
"RAJASTHAN",
"SIKKIM",
"TAMIL NADU",
"TELANGANA",
"TRIPURA",
"UTTAR PRADESH",
"UTTARAKHAND",
"WEST BENGAL"

];



