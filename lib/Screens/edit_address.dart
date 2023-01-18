import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/product_detail_page.dart';
import 'package:highrich/Screens/progress_hud.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/general/default_button.dart';
import 'package:highrich/general/shared_pref.dart';
import 'package:highrich/model/Address/address_list_model.dart';
import 'package:highrich/model/Address/district_suggestion_model.dart';
import 'package:highrich/model/default_model.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_address.dart';
import 'address.dart';
/*
 *  2021 Highrich.in
 */
class EditAddresspage extends StatefulWidget {
  Address addressModel = new Address();
  String pageFrom;
  EditAddresspage({@required this.addressModel,this.pageFrom});

  @override
  _EditAddresspagepageState createState() => _EditAddresspagepageState();
}

class _EditAddresspagepageState extends State<EditAddresspage> {
  String other;
  String state;
  String userId;
  String primary;
  String emailId;
  String phoneNo;
  String pinCode;
  String district;
  String password;
  int radioId = 1;
  String otherType;
  String ownerName;
  bool _hideNavBar;
  String addressType;
  String buildingName;
  String addressLine1;
  String addressLine2;
  String _dropDownValue;
  String _dropDownValueDist;
  bool secureText = true;
  bool isLoading = false;
  String alternatePhoneNo;
  List<String> districts = new List();
  bool dropDownDisabled= true;
  bool clearDrop = false;
  String countryCode = "91";
  String countryCodesec = "91";
  bool setasPrimaryAdrz = false;
  String radioButtonItem = 'Home';
  bool otherTypeVisibility = false;
  Address addressModel = new Address();
  SharedPref sharedPref = SharedPref();
  var reqBody = Map<String, dynamic>();
  var _formKey = GlobalKey<FormState>();
  RemoteDataSource _apiResponse = RemoteDataSource();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String pageFrom;
  Future<void> initState() {
    super.initState();
    addressModel = widget.addressModel;
    pageFrom=widget.pageFrom;
    radioButtonItem = addressModel.addressType;
    if (radioButtonItem == "Home") {
      otherTypeVisibility = false;
      radioId = 1;
    } else if (radioButtonItem == "Office") {
      otherTypeVisibility = false;
      radioId = 2;
    } else {
      otherTypeVisibility = true;
      radioId = 3;
    }
    if (addressModel.ownerName != null) {
      ownerName = addressModel.ownerName;
    } else {
      ownerName = "";
    }
    if (addressModel.emailId != null) {
      emailId = addressModel.emailId;
    } else {
      emailId = "";
    }
    if (addressModel.addressLine1 != null) {
      addressLine1 = addressModel.addressLine1;
    } else {
      addressLine1 = "";
    }
    if (addressModel.addressLine2 != null) {
      addressLine2 = addressModel.addressLine2;
    } else {
      addressLine2 = "";
    }
    if (addressModel.buildingName != null) {
      buildingName = addressModel.buildingName;
    } else {
      buildingName = "";
    }
    if (addressModel.district != null) {
      _dropDownValueDist = addressModel.district;
    } else {
      district = "";
    }
    if (addressModel.phoneNo != null) {
      phoneNo = addressModel.phoneNo;
      if (phoneNo.contains("91")) {
        var parts = phoneNo.split('91');
        phoneNo = parts.sublist(1).join('91').trim();
      }
    } else {
      phoneNo = "";
    }
    if (addressModel.alternatePhoneNo != null) {
      alternatePhoneNo = addressModel.alternatePhoneNo;
      if (alternatePhoneNo.contains("91")) {
        var parts = alternatePhoneNo.split('91');
        alternatePhoneNo = parts.sublist(1).join('91').trim();
      }
    } else {
      alternatePhoneNo = "";
    }
    if (addressModel.pinCode != null) {
      pinCode = addressModel.pinCode;
    } else {
      pinCode = "";
    }
    if (addressModel.state != null) {
      _dropDownValue = addressModel.state;
    } else {
      state = "";
    }

    setasPrimaryAdrz = addressModel.primary ?? false;
    _loadUserId();
    print(radioButtonItem);
  }

  _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = (prefs.getString('userId') ?? '');
    });
  }

  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: GestureDetector(
                onTap: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                },
                child: Container(
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
              child: Text("Edit Address",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w600)),
            ),
            Spacer(),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  children: [
                    _addressTextFields(context),
                    SizedBox(
                      height: 10.0,
                    ),
                    _addressType(context),
                    SizedBox(
                      height: 10.0,
                    ),
                    otherTypeVisibility
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 18.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: new TextEditingController.fromValue(
                                  TextEditingValue(
                                      text: addressModel?.addressType ?? "",
                                      selection: TextSelection.fromPosition(
                                          TextPosition(
                                              offset: addressModel
                                                      ?.addressType?.length ??
                                                  0)))),
                              textCapitalization: TextCapitalization.words,
                              onSaved: (newValue) => radioButtonItem = newValue,
                              onChanged: (value) {
                                return null;
                              },
                              decoration: InputDecoration(
                                //  labelText: "Email",
                                hintText: "Type",
                                helperText:
                                    "Please specify the type of address",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide: const BorderSide(
                                      color: Colors.orangeAccent, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 1.0,
                          ),
                    SizedBox(
                      height: 10.0,
                    ),
                    CheckboxListTile(
                      title: Text("Set as default address"),
                      value: setasPrimaryAdrz,
                      onChanged: (newValue) {
                        setState(() {
                          setasPrimaryAdrz = newValue;
                          print("STASSJSJJ");
                          print(setasPrimaryAdrz);
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: BlueButton(
                        text: "Update Address",
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if(_dropDownValue == null || _dropDownValueDist == null) {
                              showToast("Empty State or District");
                            } else {
                               reqBody.addAll({
                              "id": addressModel.id,
                              "accountType": "customer",
                              "addressLine1": addressLine1,
                              "addressLine2": addressLine2,
                              "addressType": radioButtonItem,
                              "alternatePhoneNo": "1234567899",
                              "buildingName": buildingName,
                              "district": _dropDownValueDist,
                              "emailId": emailId,
                              "ownerName": ownerName,
                              "phoneNo": phoneNo,
                              "alternatePhoneNo": alternatePhoneNo,
                              "pinCode": pinCode,
                              "primary": setasPrimaryAdrz,
                              "state": _dropDownValue,
                              "userId": userId,
                            });
                            print("**********************************");
                            print(reqBody);
                            setState(() {
                              isLoading = true;
                            });
                            Result result =
                                await _apiResponse.updateAddress(reqBody);
                            setState(() {
                              isLoading = false;
                            });
                            if (result is SuccessState) {
                              DefaultModel user = result.value;
                              print(user.status);
                              if (user.status == "success") {
                                String message = user.message;
                                String hk = message;
                                if(pageFrom=="subscribe"){
                                  DartNotificationCenter.post(channel: 'SUBSCRIBE_ADDRESS');
                                  Navigator.pop(context);
                                }
                                if(pageFrom=="address"){
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddressPage()));
                                }

                                // _showAlert("Signup Success", user.message);
                              } else {
                                //_showAlert("Sorry", user.message);
                              }
                            } else if (result is UnAuthoredState) {
                              DefaultModel unAuthoedUser = (result).value;
                              print(unAuthoedUser.message);
                              // return _showAlert('Sorry', unAuthoedUser.message);
                            } else if (result is ErrorState) {
                              String errorMessage = (result).msg;
                              //  return _showAlert('Sorry', errorMessage);
                            }
                            }
                           
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        key: _scaffoldkey);
  }

  Padding _addressTextFields(BuildContext context) {
    final node = FocusScope.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
      child: Column(
        children: [
          //Name
          TextFormField(
            keyboardType: TextInputType.name,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ' ']"))],
            controller: new TextEditingController.fromValue(TextEditingValue(
                text: ownerName,
                selection: TextSelection.fromPosition(
                    TextPosition(offset: ownerName.length ?? 0)))),
            textCapitalization: TextCapitalization.words,
            onSaved: (newValue) => ownerName = newValue,
            onChanged: (value) {
              ownerName = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "Enter your name";
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              //  labelText: "Email",
              hintText: "Name *",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          //Phone
          Row(
            //Center Row contents vertically,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CountryCodePicker(
                  onChanged: (value) {
                    countryCode = "91";
                  },
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: '+91',
                  favorite: ['+91', 'IN'],
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                ),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    new FilteringTextInputFormatter.allow(phoneRegex),
                  ],
                  maxLength: 10,
                  controller: new TextEditingController.fromValue(
                      TextEditingValue(
                          text: phoneNo,
                          selection: TextSelection.fromPosition(
                              TextPosition(offset: phoneNo.length ?? 0)))),
                  onSaved: (newValue) => phoneNo = newValue,
                  onChanged: (value) {
                    phoneNo = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return kPhoneNumberNullError;
                    } else if (!phoneRegex.hasMatch(value)) {
                      return kPhoneNumberValidError;
                    } else if (value.length < 10) {
                      return kPhoneNumberValidError;
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  decoration: InputDecoration(
                    //  labelText: "Email",
                    hintText: "Phone *",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          //SecPhone
          Row(
            //Center Row contents vertically,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CountryCodePicker(
                  onChanged: (value) {
                    countryCodesec = "91";
                  },
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: '+91',
                  favorite: ['+91', 'IN'],
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                ),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    new FilteringTextInputFormatter.allow(phoneRegex),
                  ],
                  maxLength: 10,
                  controller: new TextEditingController.fromValue(
                      TextEditingValue(
                          text: alternatePhoneNo,
                          selection: TextSelection.fromPosition(TextPosition(
                              offset: alternatePhoneNo.length ?? 0)))),
                  onSaved: (newValue) => alternatePhoneNo = newValue,
                  onChanged: (value) {
                    alternatePhoneNo = value;
                  },
                  validator: (value) {
                    if (value.isNotEmpty) {
                      if (!phoneRegex.hasMatch(value)) {
                        return kPhoneNumberValidError;
                      } else if (value.length < 10) {
                        return kPhoneNumberValidError;
                      }
                      return null;
                    }
                  },
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  decoration: InputDecoration(
                    //  labelText: "Email",
                    hintText: "Phone",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          //Email
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: new TextEditingController.fromValue(TextEditingValue(
                text: emailId,
                selection: TextSelection.fromPosition(
                    TextPosition(offset: emailId.length ?? 0)))),
            onSaved: (newValue) => emailId = newValue,
            onChanged: (value) {
              emailId = value;
            },
            validator: (value) {
              if(value.isNotEmpty) {
                if (!emailValidatorRegExp.hasMatch(value)) {
                  return "Enter Valid Email";
                }
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              //  labelText: "Email",
              hintText: "Email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          //Building Name/number
          TextFormField(
            keyboardType: TextInputType.text,
            controller: new TextEditingController.fromValue(TextEditingValue(
                text: buildingName,
                selection: TextSelection.fromPosition(
                    TextPosition(offset: buildingName.length ?? 0)))),
            textCapitalization: TextCapitalization.words,
            onSaved: (newValue) => buildingName = newValue,
            onChanged: (value) {
              buildingName = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "Enter your building name/number";
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              //  labelText: "Email",
              hintText: "Building Name/number *",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          //Address Line 1
          TextFormField(
            keyboardType: TextInputType.text,
            controller: new TextEditingController.fromValue(TextEditingValue(
                text: addressLine1,
                selection: TextSelection.fromPosition(
                    TextPosition(offset: addressLine1.length ?? 0)))),
            textCapitalization: TextCapitalization.words,
            onSaved: (newValue) => addressLine1 = newValue,
            onChanged: (value) {
              addressLine1 = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "Enter address line 1";
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              //  labelText: "Email",
              hintText: "Address Line 1 *",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          // //Address Line 2
          TextFormField(
            keyboardType: TextInputType.text,
            controller: new TextEditingController.fromValue(TextEditingValue(
                text: addressLine2,
                selection: TextSelection.fromPosition(
                    TextPosition(offset: addressLine2.length ?? 0)))),
            textCapitalization: TextCapitalization.words,
            onSaved: (newValue) => addressLine2 = newValue,
            onChanged: (value) {
              addressLine2 = value;
            },
            // validator: (value) {
            //   if (value.isEmpty) {
            //     return "enter your address line 2";
            //   }
            //   return null;
            // },
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              //  labelText: "Email",
              hintText: "Address Line 2",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          //State
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
           decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(2)
            ),

                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                hint: _dropDownValue == null
                    ? Text('State *')
                    : Text(
                        _dropDownValue,
                        style: TextStyle(color: Colors.black),
                      ),
                isExpanded: true,
                iconSize: 30.0,
                style: TextStyle(color: Colors.black),
                items: stateSuggestions.map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  },
                ).toList(),
                onChanged: (val) async {
                  print(val);
                  setState(() {
                    clearDrop = true;
                  });
                  if(clearDrop == true) {
                    _dropDownValueDist = null;
                  }
                  var statesPayload = Map<String, dynamic>();
                  statesPayload.addAll({
                    "states": [val.toString()],
                  });
                  print(statesPayload);
                  Result result = await _apiResponse.districtSuggestion({
                    "states": [val]
                  });
                                
                  if (result is SuccessState) {
                    DistrictModel districtModel = (result).value;
                    if (districtModel.status == "success") {
                      districts.clear();
                      setState(() {
                          dropDownDisabled = false;
                      });
                       
                       for(int i = 0; i < districtModel.documents.length ; i ++) {
                         var distr = districtModel.documents[i];
                         Districts dist = distr;
                         districts.addAll(dist.source.districts);
                       }
                    } else {
                      setState(() {
                          dropDownDisabled = true;
                      });
                    }
                  
                  } else if (result is ErrorState) {
                    String errorMessage = (result).msg;
                    //  return _showAlert('Sorry', errorMessage);
                  }
                  setState(
                    () {
                      _dropDownValue = val;
                    },
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 10,),
          //Distrit
          dropDownDisabled == false ? 
           Container(
             padding: EdgeInsets.symmetric(horizontal: 10.0),
           decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(2)
            ),
             child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                hint: _dropDownValueDist == null
                    ? Text('District *')
                    : Text(
                        clearDrop == true ? "" : _dropDownValueDist,
                        style: TextStyle(color: Colors.black),
                      ),
                isExpanded: true,
                iconSize: 30.0,
                style: TextStyle(color: Colors.black),
                items: districts.map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  print(val);
                  setState(
                    () {
                      clearDrop = false;
                      _dropDownValueDist = val;
                    },
                  );
                },
          ),
             ),
           ) 
           :  Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.grey),
                   borderRadius: BorderRadius.circular(2)
                 ),
                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                  hint: _dropDownValueDist == null
                    ? Text('District *')
                    : Text(
                        _dropDownValueDist,
                        style: TextStyle(color: Colors.black),
                      ),
              isExpanded: true,
              iconSize: 30.0,
              style: TextStyle(color: Colors.black),
              items: [].map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  },
              ).toList(),
              onChanged: (_) {},
          ),
                ),
           ),
           
          // TextFormField(
          //   keyboardType: TextInputType.text,
          //   inputFormatters: [
          //     new WhitelistingTextInputFormatter(nameRegex),
          //   ],
          //   controller: new TextEditingController.fromValue(TextEditingValue(
          //       text: district,
          //       selection: TextSelection.fromPosition(
          //           TextPosition(offset: district.length ?? 0)))),
          //   textCapitalization: TextCapitalization.words,
          //   onSaved: (newValue) => district = newValue,
          //   onChanged: (value) {
          //     district = value;
          //   },
          //   // validator: (value) {
          //   //   if (value.isEmpty) {
          //   //     return "enter district";
          //   //   }
          //   //   return null;
          //   // },
          //   textInputAction: TextInputAction.next,
          //   onEditingComplete: () => node.nextFocus(),
          //   decoration: InputDecoration(
          //     //  labelText: "Email",
          //     hintText: "District",
          //     floatingLabelBehavior: FloatingLabelBehavior.always,
          //     isDense: true,
          //     border:
          //         OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
          //     focusedBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(2),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 10.0,
          ),
          // TextFormField(
          //   keyboardType: TextInputType.text,
          //   inputFormatters: [
          //     new WhitelistingTextInputFormatter(nameRegex),
          //   ],
          //   controller: new TextEditingController.fromValue(TextEditingValue(
          //       text: state,
          //       selection: TextSelection.fromPosition(
          //           TextPosition(offset: state.length ?? 0)))),
          //   textCapitalization: TextCapitalization.words,
          //   onSaved: (newValue) => state = newValue,
          //   onChanged: (value) {
          //     state = value;
          //   },
          //   validator: (value) {
          //     if (value.isEmpty) {
          //       return "Enter state";
          //     }
          //     return null;
          //   },
          //   textInputAction: TextInputAction.next,
          //   onEditingComplete: () => node.nextFocus(),
          //   decoration: InputDecoration(
          //     //  labelText: "Email",
          //     hintText: "State *",
          //     floatingLabelBehavior: FloatingLabelBehavior.always,
          //     isDense: true,
          //     border:
          //         OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
          //     focusedBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(2),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 10.0,
          ),
          //PinCode
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              new FilteringTextInputFormatter.allow(phoneRegex),
            ],
            controller: new TextEditingController.fromValue(TextEditingValue(
                text: pinCode,
                selection: TextSelection.fromPosition(
                    TextPosition(offset: pinCode.length ?? 0)))),
            onSaved: (newValue) => pinCode = newValue,
            onChanged: (value) {
              pinCode = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return kPinCodeNullError;
              } else if (value.length < 6) {
                return kPinCodeValidError;
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            maxLength: 6,
            decoration: InputDecoration(
              //  labelText: "Email",
              hintText: "PIN Code *",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _addressType(BuildContext context) {
    return Column(
      children: [
        //Name

        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text("Type of Address", textAlign: TextAlign.start)),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  radioButtonItem = 'Home';
                  radioId = 1;
                  otherTypeVisibility = false;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: Radio(
                      value: 1,
                      groupValue: radioId,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItem = 'Home';
                          radioId = 1;
                          otherTypeVisibility = false;
                        });
                      },
                    ),
                  ),
                  Text(
                    'HOME',
                    style: new TextStyle(fontSize: 15.0),
                  ),
                ],
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  radioButtonItem = 'Office';
                  radioId = 2;
                  otherTypeVisibility = false;
                });
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: Radio(
                      value: 2,
                      groupValue: radioId,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItem = 'Office';
                          radioId = 2;
                          otherTypeVisibility = false;
                        });
                      },
                    ),
                  ),
                  Text(
                    'OFFICE',
                    style: new TextStyle(
                      fontSize: 15.0,
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  radioButtonItem = 'other';
                  radioId = 3;
                  otherTypeVisibility = true;
                });
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: Radio(
                      value: 3,
                      groupValue: radioId,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItem = 'other';
                          radioId = 3;
                          otherTypeVisibility = true;
                        });
                      },
                    ),
                  ),
                  Text(
                    'OTHER',
                    style: new TextStyle(fontSize: 15.0),
                  ),
                ],
              ),
            ),
            Spacer()
          ],
        ),
      ],
    );
  }
}
