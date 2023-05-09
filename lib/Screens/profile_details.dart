import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/Home/profile.dart';
import 'package:highrich/Screens/change_password.dart';
import 'package:highrich/Screens/progress_hud.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/general/default_button.dart';
import 'package:highrich/model/Profile/image_upload_Model.dart';
import 'package:highrich/model/Profile/profile_model.dart';
import 'package:highrich/model/default_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart' as async;
import 'package:path/path.dart' as path;

/*
 *  2021 Highrich.in
 */
class ProfileDetailsPage extends StatefulWidget {
  Profile profileDataModel = new Profile();

  ProfileDetailsPage(@required this.profileDataModel);

  @override
  _ProfileDetailsPageState createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  File _imageFile;
  int version = 0;
  String phone = "";
  String email = "";
  String userName = "";
  String userCode = "";
  String referaID = "";
  String address = "";
  String pinCode = "";
  bool isLoading = false;
  String profilePicUrl = "";
  bool makeChangesPin = false;
  bool makeChangesName = false;
  bool makeChangesPhone = false;
  bool makeChangesEmail = false;
  final picker = ImagePicker();
  PersistentTabController _controller;
  var _formKey = GlobalKey<FormState>();
  Profile profileDataModel = new Profile();
  RemoteDataSource _apiResponse = RemoteDataSource();
  String nameUser = "", numberPhone = "", codePin = "", email_Edit = "";
  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerReferalID = new TextEditingController();
  TextEditingController controllerPhone = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPnCode = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    profileDataModel = widget.profileDataModel;
    version = profileDataModel?.version;
    userName = profileDataModel?.source?.name;
    userCode = profileDataModel?.source?.userCode;
    referaID = profileDataModel?.source?.referralId;
    phone = profileDataModel?.source?.mobile;
    if (phone.contains("91")) {
      var parts = phone.split('91');
      phone = parts.sublist(1).join('91').trim();
    }
    email = profileDataModel?.source?.email;
    pinCode = profileDataModel?.source?.pinCode;
    if (profileDataModel?.source?.image != null) {
      profilePicUrl = imageBaseURL + profileDataModel?.source?.image[0];
    }

    controllerName.text = userName;
    nameUser = userName;
    controllerReferalID.text = referaID;
    controllerPhone.text = phone;
    numberPhone = phone;

    controllerEmail.text = email;
    email_Edit = email;
    controllerPnCode.text = pinCode;
    codePin = pinCode;
    DartNotificationCenter.subscribe(
      channel: 'DIALOG_PROFILE',
      observer: this,
      onNotification: (options) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
  }

  @override
  Widget _uiSetup(BuildContext context) {
    final node = FocusScope.of(context);
    Size screenSize = MediaQuery.of(context).size;
    var body = Form(
        key: _formKey,
        child: new ListView(
          children: [
            Stack(
              children: [
                orangeBG(),
                Positioned(
                  child: Card(
                      margin: const EdgeInsets.only(
                          top: 80.0, left: 20, right: 20.0),
                      elevation: 3,
                      child: Container(
                        width: screenSize.width * 0.9,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(),
                                  flex: 1,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      customerName(profileDataModel),
                                      customerID(profileDataModel),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            divider(),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                top: 10,
                                right: 16,
                                bottom: 30,
                              ),
                              child: Column(
                                children: [
                                  TextFormField(
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-Black'),
                                    keyboardType: TextInputType.name,
                                    enabled: false,
                                    controller:
                                        new TextEditingController.fromValue(
                                            TextEditingValue(
                                                text: controllerName.text,
                                                selection: TextSelection
                                                    .fromPosition(TextPosition(
                                                        offset: controllerName
                                                                .text.length ??
                                                            0)))),
                                    onChanged: (value) {
                                      controllerName.text = value;
                                      if (nameUser == value) {
                                        makeChangesName = false;
                                      } else {
                                        makeChangesName = true;
                                      }
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Enter your name";
                                      }
                                      return null;
                                    },
                                    textCapitalization:
                                        TextCapitalization.words,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[a-zA-Z ' ']"))
                                    ],
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    decoration: InputDecoration(
                                      labelText: "Name *",
                                      labelStyle: TextStyle(color: Colors.grey),
                                      // hintText: "Name",
                                      contentPadding: new EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      hintStyle: TextStyle(color: gray_bg),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      isDense: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        borderSide: BorderSide(
                                          color: gray_bg,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(2),
                                        borderSide: BorderSide(
                                          color: gray_bg,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(2),
                                        borderSide: BorderSide(
                                          color: gray_bg,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-Black'),
                                    enabled: false,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    controller: controllerReferalID,
                                    decoration: InputDecoration(
                                      labelText: "Highrich ID",

                                      labelStyle: TextStyle(color: Colors.grey),
                                      // hintText: "Name",
                                      // suffixIcon: IconButton(
                                      //   icon: Icon(
                                      //     Icons.content_copy,
                                      //     color: Colors.black,
                                      //   ),
                                      // ),
                                      contentPadding: new EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      hintStyle: TextStyle(color: gray_bg),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      isDense: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        borderSide: BorderSide(
                                          color: gray_bg,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(2),
                                        borderSide: BorderSide(
                                          color: gray_bg,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(2),
                                        borderSide: BorderSide(
                                          color: gray_bg,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    //Center Row contents vertically,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: CountryCodePicker(
                                          onChanged: print,
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
                                        style: TextStyle(
                                            fontFamily: 'Montserrat-Black'),
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        maxLength: 10,
                                        onEditingComplete: () =>
                                            node.nextFocus(),
                                        controller: controllerPhone,
                                        inputFormatters: <TextInputFormatter>[
                                          new FilteringTextInputFormatter.allow(
                                              phoneRegex),
                                        ],
                                        onChanged: (value) {
                                          if (numberPhone == value) {
                                            makeChangesPhone = false;
                                          } else {
                                            makeChangesPhone = true;
                                          }
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Enter your Phone Number";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Phone Number *",
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          // hintText: "Name",
                                          contentPadding:
                                              new EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 10.0),
                                          hintStyle: TextStyle(color: gray_bg),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          isDense: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            borderSide: BorderSide(
                                              color: gray_bg,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            borderSide: BorderSide(
                                              color: gray_bg,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            borderSide: BorderSide(
                                              color: gray_bg,
                                            ),
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-Black'),
                                    keyboardType: TextInputType.emailAddress,
                                    enabled: true,
                                    //  onSaved: (newValue) => email = newValue,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    controller: controllerEmail,
                                    onChanged: (value) {
                                      if (email_Edit == value) {
                                        makeChangesEmail = false;
                                      } else {
                                        makeChangesEmail = true;
                                      }
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return kEmailNullError;
                                      } else if (!emailValidatorRegExp
                                          .hasMatch(value)) {
                                        return kInvalidEmailError;
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Email *",
                                      labelStyle: TextStyle(color: Colors.grey),
                                      // hintText: "Name",
                                      contentPadding: new EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      hintStyle: TextStyle(color: gray_bg),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      isDense: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        borderSide: BorderSide(
                                          color: gray_bg,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(2),
                                        borderSide: BorderSide(
                                          color: gray_bg,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(2),
                                        borderSide: BorderSide(
                                          color: gray_bg,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-Black'),
                                    keyboardType: TextInputType.name,
                                    //  onSaved: (newValue) => email = newValue,
                                    controller: controllerPnCode,
                                    inputFormatters: <TextInputFormatter>[
                                      new FilteringTextInputFormatter.allow(
                                          phoneRegex),
                                    ],
                                    maxLength: 6,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    onChanged: (value) {
                                      if (codePin == value) {
                                        makeChangesPin = false;
                                      } else {
                                        makeChangesPin = true;
                                      }
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Enter your Pin code";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Pin Code *",
                                      labelStyle: TextStyle(color: Colors.grey),
                                      // hintText: "Name",
                                      contentPadding: new EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      hintStyle: TextStyle(color: gray_bg),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      isDense: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        borderSide: BorderSide(
                                          color: gray_bg,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(2),
                                        borderSide: BorderSide(
                                          color: gray_bg,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(2),
                                        borderSide: BorderSide(
                                          color: gray_bg,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  OrangeButton(
                                      text: "Save Details",
                                      press: () {
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          if (controllerPhone.text != null) {
                                            if (controllerPhone.text.length ==
                                                10) {
                                              if (controllerPnCode.text !=
                                                  null) {
                                                if (controllerPnCode
                                                        .text.length ==
                                                    6) {
                                                  updateProfile();
                                                } else {
                                                  showToast(kPinCodeValidError);
                                                }
                                              } else {
                                                showToast(kPinCodeNullError);
                                              }
                                            } else {
                                              showToast(kPhoneNumberValidError);
                                            }
                                          } else {
                                            showToast(kPhoneNumberNullError);
                                          }
                                        }
                                      }),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Visibility(
                                    visible: makeChangesName ||
                                        makeChangesPhone ||
                                        makeChangesPin ||
                                        makeChangesEmail,
                                    child: OrangeStrokeButton(
                                        text: "Discard Changes",
                                        press: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      ProfileDetailsPage(
                                                          profileDataModel)));
                                        }),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  OrangeStrokeButton(
                                      text: "Change Password",
                                      press: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangePasswordPage(
                                                        emailID: email)));
                                      }),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                ),
                Positioned(
                  top: 30,
                  left: screenSize.width / 8,
                  child: GestureDetector(
                    onTap: () {
                      Future(() => showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return ModalBottomSheetSort(valueChanged: (value) {
                              getImage(value);
                            });
                          }));
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: gray_bg,
                      backgroundImage: NetworkImage(profilePicUrl),
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_backspace,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text("Profile Details",
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: body,
      ),
      key: _scaffoldkey,
    );
  }

  Future getImage(String source) async {
    var pickedFile;
    if (source == "gallery") {
      if (Platform.isAndroid
          ? await Permission.storage.isPermanentlyDenied
          : await Permission.photos.isPermanentlyDenied) {
        openAppSettings();
      } else {
        if (Platform.isAndroid
            ? await Permission.storage.request().isGranted
            : await Permission.photos.request().isGranted) {
          pickedFile = await picker.getImage(
            source: ImageSource.gallery,
            imageQuality: 10,
          );
        } else {
          Platform.isAndroid
              ? await Permission.storage.request()
              : await Permission.photos.request();
        }
      }
    } else {
      if (await Permission.camera.isPermanentlyDenied) {
        openAppSettings();
      } else {
        if (await Permission.camera.request().isGranted) {
          pickedFile = await picker.getImage(
            source: ImageSource.camera,
            imageQuality: 10,
          );
        } else {
          await Permission.camera.request();
        }
      }
    }
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        print(_imageFile);
        uploadProfileImage(_imageFile);
      } else {
        print('No image selected.');
      }
    });
  }

  //update Profile Image API
  Future uploadProfileImage(File _imageFile) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("userId");
    final token = preferences.getString("token");
    Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final url = baseURL + "customer/" + userId + "/profile-image-upload";
    var stream =
        http.ByteStream(async.DelegatingStream.typed(_imageFile.openRead()));
    var length = await _imageFile.length();
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: path.basename(_imageFile.path));
    print(multipartFile);
    //contentType: new MediaType('image', 'png'));
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        ImageUploadModel uploadProfilepicModel =
            imageUploadModelFromJson(value);

        if (uploadProfilepicModel.status == "success") {
          setState(() {
            profilePicUrl = imageBaseURL + uploadProfilepicModel.documents;
          });
          _handleClickMe(context, "Image uploaded successfully");
        } else {
          // showSnackBar("Failed, please try agian later");
        }
      }
      if (response.statusCode == 401) {
        print("401");
      } else {
        print("401");
        return Result.error('Something went wrong. Please try again');
      }
    });
  }

  //update Profile Details API
  Future<DefaultModel> updateProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("userId");
    setState(() {
      isLoading = true;
    });

    var profileReqBody = Map<String, dynamic>();
    profileReqBody.addAll({
      "accountType": "customer",
      "id": userId,
      "mobile": controllerPhone.text,
      "email": controllerEmail.text,
      "name": controllerName.text,
      "pinCode": controllerPnCode.text,
      "version": version,
    });
    print(jsonEncode(profileReqBody));
    Result result = await _apiResponse.updateProfile(profileReqBody);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      DefaultModel response = (result).value;
      if (response.status == "success") {
        //  Fluttertoast.showToast(msg: response.message);
        _handleClickMe(context, response.message);
      } else {
        // showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      DefaultModel unAuthoedUser = (result).value;
      // showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      //showSnackBar("Failed, please try agian later");
    }
  }
}

Future<void> _handleClickMe(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Success'),
        content: Text("Profile updated successfully!"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pop(context);
              //   Navigator.pop(context);
              DartNotificationCenter.post(
                channel: "DIALOG_PROFILE",
                options: "DIALOG_PROFILE",
              );
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
        ],
      );
    },
  );
}

String addressDetails(List<Address> addressList) {
  String key = "";
  Address addressModel = Address();
  for (int i = 0; i < addressList.length; i++) {
    if (addressList[i].primary == true) {
      addressModel = addressList[i];
    }
  }
  String buildingName = addressModel?.buildingName;
  String addressLine1 = addressModel?.addressLine1;
  String addressLine2 = addressModel?.addressLine2;
  String district = addressModel?.district;
  String state = addressModel?.state;
  String pinCode = addressModel?.pinCode;
  if (pinCode != null && pinCode != "") {
    key = pinCode;
  }
  return key;
}

Row customerID(Profile profileDataModel) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: Text(
          profileDataModel?.source?.userCode,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      )
    ],
  );
}

Row customerName(Profile profileDataModel) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
        child: Text(
          profileDataModel?.source?.name,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}

Container orangeBG() {
  return Container(
    color: Colors.orange,
    height: 130,
  );
}

Container divider() {
  return Container(
      margin: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
      child: Divider(
        color: Colors.grey.shade200,
      ));
}

class Menu {
  static const String Home = 'Home';
  static const String Profile = 'Profile';
  static const String Cart = 'Cart';

  static const List<String> choices = <String>[Home, Profile, Cart];
}

class ModalBottomSheetSort extends StatefulWidget {
  final ValueChanged valueChanged;

  ModalBottomSheetSort({@required this.valueChanged});

  @override
  _ModalBottomSheetSortState createState() => _ModalBottomSheetSortState();
}

class _ModalBottomSheetSortState extends State<ModalBottomSheetSort>
    with SingleTickerProviderStateMixin {
  String chooseType = "gallery";

  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(
      shrinkWrap: true,
      children: <Widget>[
        new ListTile(
            title: new Text(
              "Choose",
            ),
            onTap: () => {}),
        Divider(),
        new ListTile(
            title: new Text(
              "Camera",
            ),
            leading: Icon(Icons.camera_alt),
            onTap: () {
              Navigator.of(context).pop();
              chooseType = "camera";
              widget.valueChanged(chooseType);
            }),
        new ListTile(
            title: new Text(
              "Gallery",
            ),
            leading: Icon(Icons.image),
            onTap: () {
              Navigator.of(context).pop();
              chooseType = "gallery";
              widget.valueChanged(chooseType);
            }),
      ],
    ));
  }
}
