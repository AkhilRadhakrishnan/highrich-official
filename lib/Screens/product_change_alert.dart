import 'package:flutter/material.dart';

class ProductChangeAlert extends StatelessWidget {
  const ProductChangeAlert({Key key}) : super(key: key);

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
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.error_outline),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Please check quantity and and selling price for variations in cart",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black26,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.orange),
                      child: Text("OK",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
