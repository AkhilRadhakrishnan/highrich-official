import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgressHUD extends StatefulWidget {

  final Widget child;
  bool inAsyncCall = false;
  final double opacity;
  final Color color;
  final Animation<Color> valueColor;

  ProgressHUD({
    Key key,
    @required this.child,
    @required this.inAsyncCall,
    this.opacity = 0.1,
    this.color = Colors.grey,
    this.valueColor,
  }) : super(key: key);

  @override
  ProgressHudState createState() => ProgressHudState();


}

class ProgressHudState extends State<ProgressHUD>  {

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = new List<Widget>();
    widgetList.add(widget.child);

    if (widget.inAsyncCall) {
      final modal = new Stack(
        children: [
          new Opacity(
            opacity: widget.opacity,
            child: ModalBarrier(dismissible: false, color: widget.color),
          ),
          new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitFadingFour(color: Colors.orange,size: 40,),
                  // Text("double tap to close",style: TextStyle(color: Colors.grey[200],fontSize: 14,
                  //   shadows: [
                  //     Shadow(
                  //       color: Colors.grey[200].withOpacity(0.5),
                  //       blurRadius: 20,
                  //     ),
                  //   ],),)
                ],
              )
          ),
          // new GestureDetector(
          //   onDoubleTap: () {
          //     print("ProgressHUD double Tap");
          //     setState(() {
          //       widget.inAsyncCall = false;
          //     });
          //   },
          // ),
        ],
      );
      widgetList.add(modal);
    }
    return Scaffold(
      body: Stack(
        children: widgetList,
      ),
    );
  }
}