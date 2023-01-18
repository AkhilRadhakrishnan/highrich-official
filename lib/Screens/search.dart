import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:highrich/APICredentials/ProductListing/getContentProductsCredentials.dart';
import 'package:highrich/APICredentials/ProductListing/productlistingcredentials.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/product_listing.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/model/Search/search_suggestion.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:get/get.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:speech_to_text/speech_recognition_result.dart';

/*
 *  2021 Highrich.in
 */
class Searchpage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;

  const Searchpage(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  _SearchpageState createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  bool _hideNavBar;
  String categoryId;
  int categoryLevel;
  String lengthMain;
  String valueMain;
  String searchKey = "";
  PersistentTabController _controller;
  final myController = TextEditingController();
  RemoteDataSource _apiResponse = RemoteDataSource();
  List<Documents> searchSuggestionDocumentList = new List();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  _showModalBottomSheet(context) {
    // bool available = true;

    // showModalBottomSheet(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Scaffold(
    //         floatingActionButtonLocation:
    //             FloatingActionButtonLocation.centerFloat,
    //         floatingActionButton: AvatarGlow(
    //           animate: _isListening,
    //           glowColor: Theme.of(context).primaryColor,
    //           endRadius: 75.0,
    //           duration: const Duration(milliseconds: 2000),
    //           repeatPauseDuration: const Duration(milliseconds: 100),
    //           repeat: true,
    //           child: FloatingActionButton(
    //             onPressed: _listen,
    //             child: Icon(_isListening ? Icons.mic : Icons.mic_none),
    //             // onPressed: () {
    //             // setState(() => _isListening = false);
    //             // _speech.stop();
    //             // print("STOPPPPP");
    //             // print("VALUE: " + _isListening.toString());
    //             // if (!_isListening) {
    //             // bool available = true;
    //             //   print(available
    //             //       .toString()); // bool available = await _speech.initialize(
    //             //   //   onStatus: (val) => print('onStatus: $val'),
    //             //   //   onError: (val) => print('onError: $val'),
    //             //   // );
    //             // if (available = true) {
    //             // setState(() => _isListening = true);
    //             // _speech.listen(
    //             //   onResult: (val) => setState(() {
    //             //     _text = val.recognizedWords;
    //             //     // myController.text = _text;
    //             //     // myController.text = _text;
    //             //     searchSuggestion(_text);
    //             //   }),
    //             // );
    //             // }
    //             // }

    //             // else {
    //             //   setState(() => _isListening = false);
    //             //   _speech.stop();
    //             // }
    //             // },
    //             // child: Icon(_isListening ? Icons.mic : Icons.mic_none),},
    //           ),
    //         ),
    //         body: SingleChildScrollView(
    //           reverse: true,
    //           child: Container(
    //               padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
    //               child: Column(
    //                 children: [
    //                   // Text(_isListening ? "Listening..." : "Talk.."),
    //                   Text(_text),
    //                 ],
    //               )),
    //         ));
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    var body = new Container(
        margin: EdgeInsets.only(top: 30),
        color: Colors.white,
        child: Column(
          children: [
            Card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Icon(
                      Icons.search,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      child: TextFormField(
                        controller: myController,
                        readOnly: false,
                        autofocus: true,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          final pinCode = preferences.getString("pinCode");

                          GetContentProductsCredentials
                              getContentProductsCredentials =
                              new GetContentProductsCredentials();
                          ProductListingCredentials productListingCredentials =
                              new ProductListingCredentials();
                          productListingCredentials.key = value;
                          productListingCredentials.offset = 0;
                          productListingCredentials.size = 20;
                          productListingCredentials.hasRangeAndSort = false;
                          productListingCredentials.forMobileApp = true;
                          List<String> categoryIdList = new List();

                          categoryIdList.add(categoryId);
                          FilterCredentials filterCredentials =
                              new FilterCredentials();
                          TermCredentials termCredentials = TermCredentials();
                          List<String> pincodeList = new List();
                          if (pinCode != null &&
                              pinCode != ("null") &&
                              pinCode != ("")) {
                            pincodeList.add(pinCode);
                            pincodeList.add("All India");
                            termCredentials.serviceLocations = pincodeList;
                          }

                          filterCredentials.term = termCredentials;

                          RangeFilter rangeFilter = new RangeFilter();
                          OutOfStockProduct outOfStockProduct =
                              new OutOfStockProduct();
                          outOfStockProduct.gte = "1";

                          rangeFilter.outOfStock = outOfStockProduct;

                          filterCredentials.range = rangeFilter;

                          productListingCredentials.filter = filterCredentials;
                          // Navigator.pop(context);
                          if (valueMain == "0") {
                            showToast("Invalid search");
                            print("YESSS");
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductListing(
                                      apiName: "productListing",
                                      getContentProductsCredentials:
                                          getContentProductsCredentials,
                                      productListingCredentials:
                                          productListingCredentials,
                                      categoryName: value,
                                      from: "Searchpage"),
                                ));
                          }

                          // process
                        },
                        style: TextStyle(fontFamily: 'Montserrat-Black'),
                        keyboardType: TextInputType.text,
                        //  onSaved: (newValue) => text = newValue,
                        onChanged: (value) {
                          final validCharacters = RegExp(
                              r'^[^<>{}\"/|;:.,~!?@#$%^=&*\\]\\\\()\\[¿§«»ω⊙¤°℃℉€¥£¢¡®©_+]*$');
                          if (value.contains(validCharacters)) {
                            if (value.length > 3) {
                              showToast("Invalid search");
                            }
                          } else {
                            searchSuggestion(value);
                          }
                        },

                        decoration: InputDecoration(
                          //  labelText: "Email",
                          hintText: "Search",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  myController.text.length >= 0
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                            ),
                            onPressed: () {
                              setState(() {
                                searchSuggestionDocumentList.clear();
                              });
                              myController.text.length > 0
                                  ? myController.clear()
                                  : Navigator.pop(context);
                            },
                          ),
                        )
                      : Container(),
                  _text.length == 0 || myController.text.length == 0
                      ? IconButton(
                          onPressed: _listen
                          ,
                          icon: Icon(Icons.mic,
                          color: _isListening == true ? Colors.blue : Colors.black
                          ),
                        )
                      : Container()
                  // IconButton(
                  //   icon: Icon(Icons.mic),
                  //   onPressed: () async {
                  //     _showModalBottomSheet(context);
                  //     // setState(() => _isListening = true);
                  //     // _speech.listen(
                  //     //   onResult: (val) => setState(() {
                  //     //     _text = val.recognizedWords;
                  //     //     // myController.text = _text;
                  //     //     // myController.text = _text;
                  //     //     searchSuggestion(_text);
                  //     //   }),
                  //     // ); // _text = "sug";
                  //     // print(_text);
                  //     // myController.text = _text;
                  //     // searchSuggestion(_text);
                  //     // if (!_isListening) {
                  //     //   bool available = await _speech.initialize(
                  //     //     onStatus: (val) => print('onStatus: $val'),
                  //     //     onError: (val) => print('onError: $val'),
                  //     //   );
                  //     //   if (available) {
                  //     //     setState(() => _isListening = true);
                  //     //     _speech.listen(
                  //     //       onResult: (val) => setState(() {
                  //     //         _text = val.recognizedWords;
                  //     //         myController.text = _text;
                  //     //         myController.text = _text;
                  //     //         searchSuggestion(_text);
                  //     //       }),
                  //     //     );
                  //     //   }
                  //     // } else {
                  //     //   setState(() => _isListening = false);
                  //     //   _speech.stop();
                  //     // }
                  //   },
                  // ),
                ],
              ),
            ),
            searchSuggestionDocumentList.length > 0
                ? Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchSuggestionDocumentList.length,
                      itemBuilder: (_, index) {
                        return searchSuggestionBox(index);
                      },
                    ),
                  )
                : Container()
          ],
        ));
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: body,
      key: _scaffoldkey,
    );
  }

  Widget searchSuggestionBox(int index) => Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: InkWell(
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            final pinCode = preferences.getString("pinCode");

            GetContentProductsCredentials getContentProductsCredentials =
                new GetContentProductsCredentials();
            ProductListingCredentials productListingCredentials =
                new ProductListingCredentials();
            productListingCredentials.key =
                searchSuggestionDocumentList[index]?.name;
            productListingCredentials.offset = 0;
            productListingCredentials.size = 20;
            productListingCredentials.hasRangeAndSort = false;
            productListingCredentials.forMobileApp = true;
            List<String> categoryIdList = new List();

            categoryIdList.add(categoryId);
            FilterCredentials filterCredentials = new FilterCredentials();
            TermCredentials termCredentials = TermCredentials();

            List<String> pincodeList = new List();
            if (pinCode != null && pinCode != ("null") && pinCode != ("")) {
              pincodeList.add(pinCode);
              pincodeList.add("All India");
              termCredentials.serviceLocations = pincodeList;
            }

            filterCredentials.term = termCredentials;
            RangeFilter rangeFilter = new RangeFilter();

            OutOfStockProduct outOfStockProduct = new OutOfStockProduct();
            outOfStockProduct.gte = "1";

            rangeFilter.outOfStock = outOfStockProduct;

            filterCredentials.range = rangeFilter;
            productListingCredentials.filter = filterCredentials;
            // Navigator.pop(context);
            if (valueMain == "0") {
              print("YESSS");
              showToast("Invalid search");
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductListing(
                        apiName: "productListing",
                        getContentProductsCredentials:
                            getContentProductsCredentials,
                        productListingCredentials: productListingCredentials,
                        categoryName: searchSuggestionDocumentList[index]?.name,
                        from: "Searchpage"),
                  ));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    searchSuggestionDocumentList[index]?.name,
                    style: (TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey)),
                  )),
                ],
              ),
              searchSuggestionDocumentList[index]?.currentCategory != null
                  ? Row(
                      children: [
                        Text(
                          "in ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          searchSuggestionDocumentList[index]?.currentCategory,
                          style: (TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepOrange)),
                        ),
                      ],
                    )
                  : Row()
            ],
          ),
        ),
      );

  //Address listing api call
  Future<SearchSuggestionModel> searchSuggestion(
      String keySearchSuggestion) async {
    lengthMain = keySearchSuggestion.length.toString();
    String value = keySearchSuggestion.replaceAll(new RegExp('[\\W_\/]+'), '');
    valueMain = value.length.toString();
    print("HELOOOOOOOOOOO" + value);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final pinCode = preferences.getString("pinCode");
    searchSuggestionDocumentList.clear();
    var searchSuggestionMap = Map<String, dynamic>();
    searchSuggestionMap.addAll({
      "offset": 0,
      "size": 20,
      "key": keySearchSuggestion,
      "pinCode": pinCode,
    });

    Result result = await _apiResponse.searchSuggestion(searchSuggestionMap);

    if (result is SuccessState) {
      SearchSuggestionModel response = (result).value;
      if (response.status == "success") {
        setState(() {
          searchSuggestionDocumentList = response.documents;
        });
      } else {
        setState(() {
          searchSuggestionDocumentList.clear();
        });
        // showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      SearchSuggestionModel unAuthoedUser = (result).value;
      // showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      //showSnackBar("Failed, please try agian later");
    }
  }

  void _listen() async {
    
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => showToast(val.toString()),
      );
      try {
if (available) {
        print("object");
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print("HELLOOOO");
            myController.text = _text;
            searchSuggestion(_text);
            _isListening = false;
            // if (val.hasConfidenceRating && val.confidence > 0) {
            //   _confidence = val.confidence;
            // }
          })
        );
      } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
      }catch(err) {
        showToast(err.toString());
      }
      
  }
}}
