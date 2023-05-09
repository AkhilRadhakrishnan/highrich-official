import 'package:country_code_picker/country_code_picker.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/address.dart';
import 'package:highrich/Screens/progress_hud.dart';
import 'package:highrich/general/default_button.dart';
import 'package:highrich/model/Address/address_list_model.dart';
import 'package:highrich/model/Address/district_suggestion_model.dart';
import 'package:highrich/model/default_model.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home/home_screen.dart';
import 'Home/profile.dart';
import '../general/constants.dart';
import '../general/shared_pref.dart';
import 'delivery_address.dart';

/*
 *  2021 Highrich.in
 */
enum SingingCharacter { HOME, OFFICE, OTHERS }

class AddAddressPage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  String pageFrom;
  AddAddressPage(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false,
      this.pageFrom})
      : super(key: key);

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  int id = 1;
  String state;
  String userId;
  String primary;
  String phoneNo;
  String emailId;
  String pinCode;
  String password;
  String district;
  String pageFrom;
  String ownerName;
  bool _hideNavBar;
  String otherType;
  String addressLine1;
  String addressLine2;
  String addressType;
  String buildingName;
  String _dropDownValue;
  String _dropDownValueDist;
  List<String> districts = new List();
  bool dropDownDisabled = true;
  bool clearDrop = false;
  int _radioValue1 = -1;
  bool secureText = true;
  bool isLoading = false;
  String alternatePhoneNo;
  String countryCode = "91";
  String countryCodesec = "91";
  bool setasPrimaryAdrz = false;
  String radioButtonItem = 'Home';
  bool otherTypeVisibility = false;
  PersistentTabController _controller;
  var reqBody = Map<String, dynamic>();
  SharedPref sharedPref = SharedPref();
  var _formKey = GlobalKey<FormState>();
  RemoteDataSource _apiResponse = RemoteDataSource();
  SingingCharacter _character = SingingCharacter.HOME;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    pageFrom = widget.pageFrom;
    _loadUserId();
    super.initState();
  }

  _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = (prefs.getString('userId') ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
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
                    Navigator.pop(context, false);
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
              child: Text("Add new Address",
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
                              onSaved: (newValue) => otherType = newValue,
                              textCapitalization: TextCapitalization.words,
                              onChanged: (value) {
                                radioButtonItem = value;
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
                        text: "Save Address",
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if (_dropDownValue == null ||
                                _dropDownValueDist == null) {
                              showToast("Empty State or District");
                            } else {
                              reqBody.addAll({
                                "accountType": "customer",
                                "addressLine1": addressLine1,
                                "addressLine2": addressLine2,
                                "addressType": radioButtonItem,
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
                              print(reqBody);
                              setState(() {
                                isLoading = true;
                              });
                              Result result =
                                  await _apiResponse.addAddress(reqBody);
                              setState(() {
                                isLoading = false;
                              });
                              if (result is SuccessState) {
                                DefaultModel user = result.value;
                                print(user.status);
                                if (user.status == "success") {
                                  String message = user.message;
                                  String hk = message;
                                  if (pageFrom == "subscribe") {
                                    DartNotificationCenter.post(
                                        channel: 'SUBSCRIBE_ADDRESS');
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pop(context, true);
                                  }
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

  //Display snack bar
  void showSnackBar(String message) {
    final snackBarContent = SnackBar(
      // padding: EdgeInsets.only(bottom:16.0),
      content: Text(message),
      action: SnackBarAction(
          label: 'OK',
          onPressed: () => ScaffoldMessenger.of(context)
              .hideCurrentSnackBar(reason: SnackBarClosedReason.hide)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarContent);
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
            onSaved: (newValue) => ownerName = newValue,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ' ']"))
            ],
            onChanged: (value) {
              return null;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "Enter your name";
              }
              return null;
            },
            textCapitalization: TextCapitalization.words,
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
                  onSaved: (newValue) => phoneNo = newValue,
                  maxLength: 10,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(phoneRegex),
                  ],
                  onChanged: (value) {
                    return null;
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
          //Secondary Phone
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
                  onSaved: (newValue) => alternatePhoneNo = newValue,
                  maxLength: 10,
                  inputFormatters: <TextInputFormatter>[
                    new FilteringTextInputFormatter.allow(phoneRegex),
                  ],
                  onChanged: (value) {
                    return null;
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
            onSaved: (newValue) => emailId = newValue,
            onChanged: (value) {
              return null;
            },
            validator: (value) {
              if (value.isNotEmpty) {
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
            onSaved: (newValue) => buildingName = newValue,
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {
              return null;
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
            onSaved: (newValue) => addressLine1 = newValue,
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {
              return null;
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
            onSaved: (newValue) => addressLine2 = newValue,
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {
              return null;
            },
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
                borderRadius: BorderRadius.circular(2)),
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
                  if (clearDrop == true) {
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

                      for (int i = 0; i < districtModel.documents.length; i++) {
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
          SizedBox(
            height: 10,
          ),
          //Distrit
          dropDownDisabled == false
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(2)),
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
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(2)),
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
          //Distrit
          // TextFormField(
          //   keyboardType: TextInputType.text,
          //   onSaved: (newValue) => district = newValue,
          //   textCapitalization: TextCapitalization.words,
          //   inputFormatters: [new WhitelistingTextInputFormatter(nameRegex),],
          //   onChanged: (value) {
          //     return null;
          //   },
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
          // SizedBox(
          //   height: 10.0,
          // ),
          // //State
          // TextFormField(
          //   keyboardType: TextInputType.text,
          //   onSaved: (newValue) => state = newValue,
          //   textCapitalization: TextCapitalization.words,
          //   inputFormatters: [new WhitelistingTextInputFormatter(nameRegex),],
          //   onChanged: (value) {
          //     return null;
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
            onSaved: (newValue) => pinCode = newValue,
            inputFormatters: <TextInputFormatter>[
              new FilteringTextInputFormatter.allow(phoneRegex),
            ],
            onChanged: (value) {
              return null;
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
                  id = 1;
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
                      groupValue: id,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItem = 'Home';
                          id = 1;
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
                  id = 2;
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
                      groupValue: id,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItem = 'Office';
                          id = 2;
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
                  id = 3;
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
                      groupValue: id,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItem = 'other';
                          id = 3;
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
