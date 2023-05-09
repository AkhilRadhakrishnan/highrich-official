import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/general/size_config.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

/*
 *  2021 Highrich.in
 */
class OrangeButton extends StatelessWidget {
  const OrangeButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      color: colorButtonOrange,
      child: TextButton(
        //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: press,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class BlueButton extends StatelessWidget {
  const BlueButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      color: colorButtonBlue,
      child: TextButton(
        //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: press,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class OrangeStrokeButton extends StatelessWidget {
  const OrangeStrokeButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.white,
      child: InkWell(
        onTap: press,
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: colorButtonOrange,
                  width: 1,
                  style: BorderStyle.solid)),

          child: Text(text,
              style: TextStyle(
                  color: colorButtonOrange, fontWeight: FontWeight.w600)),
          //textColor: colorButtonOrange,
        ),
      ),
    );
  }
}

class GreyButton extends StatelessWidget {
  final String text;
  final Function press;

  const GreyButton({Key key, this.text, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      color: Colors.grey,
      child: TextButton(
        //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: press,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

final RoundedLoadingButtonController _btnController =
    new RoundedLoadingButtonController();

class roundedButton extends StatelessWidget {
  const roundedButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            )),
        controller: _btnController,
        width: MediaQuery.of(context).size.width - 60,
        height: 55,
        color: colorButtonBlue,
        //  borderRadius: 2,

        onPressed: press);
  }
}

class ShowAlert extends StatelessWidget {
  final String title;
  final String message;
  final Function press;
  const ShowAlert({Key key, this.title, this.message, this.press})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(message),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
