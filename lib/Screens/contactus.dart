import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:highrich/Screens/product_listing.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/general/default_button.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/style.dart';

/*
 *  2021 Highrich.in
 */

class ContactUspage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;

  const ContactUspage(
      {Key key,
        this.menuScreenContext,
        this.onScreenHideButtonPressed,
        this.hideStatus = false})
      : super(key: key);

  @override
  _ContactUspageState createState() => _ContactUspageState();
}

class _ContactUspageState extends State<ContactUspage> {
  bool _hideNavBar;
  PersistentTabController _controller;
  var _formKey = GlobalKey<FormState>();
  String yourName,email,subject,message;
  @override
  Widget build(BuildContext context) {


    var body = new Form(
      key: _formKey,
      child: new Container(
          margin: EdgeInsets.only(top:20,left: 16.0,right: 16.0),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset("images/logo_highrich.svg", height: 50.0,
                    width: 50.0,),
                  SizedBox(height: 20),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(height: 10),
                    Text(
                      "HEAD OFFICE :",
                      textAlign: TextAlign.left,
                      style: (TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                    ),
                    Text(
                      "2nd Floor, Kanimangalam Tower, Main Road,",
                      style: (TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey)),
                    ),
                    Text(
                      "Valiyalukkal",
                      textAlign: TextAlign.left,
                      style: (TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey)),
                    ),
                    Text(
                      "Thrissur, Kerala, 680027",
                      textAlign: TextAlign.left,
                      style: (TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey)),
                    ),
                    SizedBox(height: 16),

                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: SvgPicture.asset("images/phone_black.svg"),
                          ),
                          TextSpan(text: "     "),
                          TextSpan(
                              text: "+ 919744338134",
                              style: new TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: SvgPicture.asset("images/email_black.svg"),
                          ),
                          TextSpan(text: "     "),
                          TextSpan(
                              text: "info@highrich.in",
                              style: new TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "For Queries / Suggestions/ Complaints:",
                      textAlign: TextAlign.left,
                      style: (TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                    ),
                    SizedBox(height: 14),
                    Text("Malayalam",
                    style: (TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),),
                    SizedBox(height: 14),
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: SvgPicture.asset("images/phone_black.svg"),
                          ),
                          TextSpan(text: "   "),
                          TextSpan(
                              text: "+91 9544500023, +91 9544500025, +91 9544500024 ",
                              style: new TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    SizedBox(height: 14),
                    Text("Hindi / English",
                    style: (TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),),
                    SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: SvgPicture.asset("images/phone_black.svg"),
                          ),
                          TextSpan(text: "   "),
                          TextSpan(
                              text: "+91 7559900081 , +91 9744338134, +91 9744338138",
                              style: new TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "For Enquires - Franchise(Agreement):",
                      textAlign: TextAlign.left,
                      style: (TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                    ),
                    SizedBox(height: 14),
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: SvgPicture.asset("images/phone_black.svg"),
                          ),
                          TextSpan(text: "   "),
                          TextSpan(
                              text: "+91 7356183049 ",
                              style: new TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      "For Smart Rich Queries (National & International)- Franchise:",
                      textAlign: TextAlign.left,
                      style: (TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                    ),
                    SizedBox(height: 14),
                    Text("Chief Operating Officer (COO)",
                    style: (TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),),
                    SizedBox(height: 14),
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: SvgPicture.asset("images/phone_black.svg"),
                          ),
                          TextSpan(text: "   "),
                          TextSpan(
                              text: "+91 6238014065",
                              style: new TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    // TextFormField(
                    //   style: TextStyle(fontFamily: 'Montserrat-Black'),
                    //   keyboardType: TextInputType.text,
                    //   inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ' ']"))],
                    //   //onSaved: (newValue) => email = newValue,
                    //   onChanged: (value) {
                    //     yourName= value;
                    //   },
                    //   validator: (value) {
                    //     if (value.isEmpty) {

                    //       return "Please enter your name";
                    //     }
                    //     return null;
                    //   },
                    //   decoration: InputDecoration(
                    //     //  labelText: "Email",
                    //     hintText: "Your Name",
                    //     hintStyle: TextStyle(color: Colors.grey),
                    //     floatingLabelBehavior: FloatingLabelBehavior.always,
                    //     isDense: true,

                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(2.0),
                    //       borderSide: BorderSide(
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //     border:  OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(2), borderSide: BorderSide(
                    //       color: Colors.grey,
                    //     ),
                    //     ),
                    //     focusedBorder:OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(2),
                    //       borderSide: BorderSide(
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 16),
                    // TextFormField(
                    //   style: TextStyle(fontFamily: 'Montserrat-Black'),
                    //   keyboardType: TextInputType.emailAddress,
                    //   //   onSaved: (newValue) => email = newValue,
                    //   onChanged: (value) {
                    //     email=value;
                    //   },
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return "Please enter your email";
                    //     } else if (!emailValidatorRegExp.hasMatch(value)) {
                    //       return "Please enter a valid email";
                    //     }
                    //     return null;
                    //   },
                    //   decoration: InputDecoration(
                    //     //  labelText: "Email",
                    //     hintText: "Email",
                    //     hintStyle: TextStyle(color: Colors.grey),
                    //     floatingLabelBehavior: FloatingLabelBehavior.always,
                    //     isDense: true,
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(2.0),
                    //       borderSide: BorderSide(
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //     border:  OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(2), borderSide: BorderSide(
                    //       color: Colors.grey,
                    //     ),
                    //     ),
                    //     focusedBorder:OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(2),
                    //       borderSide: BorderSide(
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 16),
                    // TextFormField(
                    //   style: TextStyle(fontFamily: 'Montserrat-Black'),
                    //   keyboardType: TextInputType.emailAddress,
                    //   //   onSaved: (newValue) => email = newValue,
                    //   onChanged: (value) {
                    //     subject= value;
                    //   },
                    //   validator: (value) {
                    //     if (value.isEmpty) {

                    //       return "Please enter subject";
                    //     }
                    //     return null;
                    //   },
                    //   decoration: InputDecoration(
                    //     //  labelText: "Email",
                    //     hintText: "Subject",
                    //     hintStyle: TextStyle(color: Colors.grey),
                    //     floatingLabelBehavior: FloatingLabelBehavior.always,
                    //     isDense: true,
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(2.0),
                    //       borderSide: BorderSide(
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //     border:  OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(2), borderSide: BorderSide(
                    //       color: Colors.grey,
                    //     ),
                    //     ),
                    //     focusedBorder:OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(2),
                    //       borderSide: BorderSide(
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 16),
                    // TextFormField(
                    //   style: TextStyle(fontFamily: 'Montserrat-Black'),
                    //   keyboardType: TextInputType.emailAddress,
                    //   //   onSaved: (newValue) => email = newValue,
                    //   onChanged: (value) {
                    //     message= value;
                    //   },
                    //   validator: (value) {
                    //     if (value.isEmpty) {

                    //       return "Please enter message";
                    //     }
                    //     return null;
                    //   },
                    //   decoration: InputDecoration(
                    //     //  labelText: "Email",
                    //     hintText: "Message",
                    //     hintStyle: TextStyle(color: Colors.grey),
                    //     floatingLabelBehavior: FloatingLabelBehavior.always,
                    //     isDense: true,
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(2.0),
                    //       borderSide: BorderSide(
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //     border:  OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(2), borderSide: BorderSide(
                    //       color: Colors.grey,
                    //     ),
                    //     ),
                    //     focusedBorder:OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(2),
                    //       borderSide: BorderSide(
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 30),
                    // BlueButton(
                    //     text: "SEND",
                    //     press:()
                    //     {
                    //       if (_formKey.currentState.validate()) {
                    //         _formKey.currentState.save();


                    //       }

                    //     }
                    // ),
                    SizedBox(height: 60),
                    // GestureDetector(
                    //   child: Image.asset("images/hr_map.png"),
                    //   onTap: (){
                        
                    //   },)
                  ]),
                ]
            ),
          )),
    );
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
              child:
              GestureDetector(
                onTap: (){
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                },
                child:Container(
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
              child: Text("Contact Us",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14.0,
                      color:Colors.black,
                      fontWeight: FontWeight.w600)),
            ),
            Spacer(),

          ],
        ),
        body: body);
  }


}
