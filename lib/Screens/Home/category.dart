import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:highrich/APICredentials/ProductListing/getContentProductsCredentials.dart';
import 'package:highrich/APICredentials/ProductListing/productlistingcredentials.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/pincodeDialog.dart';
import 'package:highrich/Screens/product_listing.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/model/category_model.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:highrich/Screens/fastMoving_screen.dart';

import '../product_detail_page.dart';
import '../progress_hud.dart';
import '../search.dart';
import 'cart.dart';
import 'home_screen.dart';
/*
 *  2021 Highrich.in
 */
class CategoryPage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;

  CategoryPage(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String key = "";
  String product_id;
  String categoryId;
  int categoryLevel;
  String pinCode = "";
  bool fitlerAPI = true;
  bool isLoading = false;
  PersistentTabController _controller;
  List<SubCategoryLevelMinusOne> categoryList = new List();
  RemoteDataSource _apiResponse = RemoteDataSource();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadPinCode();
    getCategory();
  }

  _loadPinCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pinCode = (prefs.getString('pinCode') ?? '');
    });
  }

  Future<void> _showAlert(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
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
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
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

  Widget _uiSetup(BuildContext context) {
    var body = new Container(
        color: gray_bg,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 30,
                color: gray_bg,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text("Select Category",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          fontSize: 18.0)),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 60,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    return new ExpansionTile(
                      title: FlatButton(
                        child: Row(
                          children: [
                             Container(
                  height: 50, 
                  width: 50, 
                  decoration: BoxDecoration(
                    image: DecorationImage(image:  categoryList[index].image != null? 
                    NetworkImage(imageBaseURL + categoryList[index].image): NetworkImage(""), fit: BoxFit.contain),
                  ),
                  ),
                            // CircleAvatar(
                            //   radius: 31,
                            //   backgroundColor: Color(0xFFE0E0E0),
                            //   child: CircleAvatar(
                            //       radius: 40,
                            //       backgroundColor: gray_bg,
                            //       backgroundImage: categoryList[index].image != null
                            //           ? NetworkImage(imageBaseURL +
                            //               categoryList[index].image)
                            //           : NetworkImage("")),
                            // ),
                            SizedBox(width: 15,),
                            Text(
                              categoryList[index].categoryName,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          bool checkConnection =
                              await DataConnectionChecker().hasConnection;
                          if (checkConnection == true) {
                            List<String> pincodeList = new List();

                            GetContentProductsCredentials
                                getContentProductsCredentials =
                                new GetContentProductsCredentials();
                            ProductListingCredentials
                                productListingCredentials =
                                new ProductListingCredentials();
                            productListingCredentials.key = categoryList[index].categoryName;
                            productListingCredentials.offset = 0;
                            productListingCredentials.size = 20;
                            productListingCredentials.sortBy = "price";
                            productListingCredentials.sortType = "asc";
                            productListingCredentials.hasRangeAndSort = false;
                            productListingCredentials.forMobileApp = true;
                            List<String> categoryIdList = new List();
                            categoryIdList.add(categoryList[index].id);
                            FilterCredentials filterCredentials =
                                new FilterCredentials();
                            TermCredentials term = new TermCredentials();

                            term.categoryId = categoryIdList;
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            final pinCode = preferences.getString("pinCode");
                            if (pinCode != null &&
                                pinCode != ("null") &&
                                pinCode != ("")) {
                              pincodeList.add(pinCode);
                              pincodeList.add("All India");
                              term.serviceLocations = pincodeList;
                            }
                            
                            RangeFilter rangeFilter = new RangeFilter();

                            OutOfStockProduct outOfStockProduct=new OutOfStockProduct();
                            outOfStockProduct.gte="1";
                            rangeFilter.outOfStock=outOfStockProduct;
                            filterCredentials.term = term;
                            filterCredentials.range=rangeFilter;
                            productListingCredentials.filter =
                                filterCredentials;

                            if (categoryList[index].id != null ||
                                categoryList[index].id != "" ||
                                categoryList[index].id != ("null")) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FastMoving(categoryId: categoryList[index].id, pinCode: pinCode,),
                                    // ProductListing(
                                    //   apiName: "productListing",
                                    //   getContentProductsCredentials:
                                    //       getContentProductsCredentials,
                                    //   productListingCredentials:
                                    //       productListingCredentials,
                                    //   categoryName:
                                    //       categoryList[index].categoryName,
                                    //   categoryId: categoryList[index].id,
                                    // ),
                                  ));
                            }
                          } else {
                            _showAlert("No internet connection",
                                "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.");
                          }
                        },
                      ),
                      children: <Widget>[
                        new Column(
                          children: buildExpandableContentCategoryZero(
                              categoryList[index]),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ));
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(6),
              child: SvgPicture.asset("images/logo_highrich.svg"),
            ),
          ),
          Spacer(),
          Center(
              child: GestureDetector(
            onTap: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) =>
                      pinCodeDialog(message: "Please wait")).then((value) {
                setState(() {
                  pinCode = value[0];
                });
              });
            },
            child:Text(pinCode!=defaultPincode?pinCode:"",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.w700)),
          )),
          Container(
            margin: EdgeInsets.only(right: 4),
            child: IconButton(
              icon: Icon(
                Icons.my_location,
                color: Colors.blue,
              ),
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) =>
                        pinCodeDialog(message: "Please wait")).then((value) {
                  setState(() {
                    pinCode = value[0];
                  });
                });
              },
            ),
          ),
        ],
      ),
      body: body,
      key: _scaffoldkey,
    );
  }


  buildExpandableContentCategoryZero(SubCategoryLevelMinusOne document) {
    List<Widget> columnContent = [];

    for (SubCategoryLevelZero content in document.subCategories)
      columnContent.add(ExpansionTile(
        title: FlatButton(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  content.categoryName,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          onPressed: () async {
            bool checkConnection = await DataConnectionChecker().hasConnection;
            if (checkConnection == true) {
              GetContentProductsCredentials getContentProductsCredentials =
                  new GetContentProductsCredentials();
              ProductListingCredentials productListingCredentials =
                  new ProductListingCredentials();
              productListingCredentials.key = content.categoryName;
              productListingCredentials.offset = 0;
              productListingCredentials.size = 20;
              productListingCredentials.hasRangeAndSort = false;
              productListingCredentials.forMobileApp = true;
              List<String> categoryIdList = new List();
              categoryIdList.add(content.id);
              FilterCredentials filterCredentials = new FilterCredentials();
              TermCredentials term = new TermCredentials();
              term.subCategory0Id = categoryIdList;
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              final pinCode = preferences.getString("pinCode");
              List<String> pincodeList = new List();
              if (pinCode != null && pinCode != ("null") && pinCode != ("")) {
                pincodeList.add(pinCode);
                pincodeList.add("All India");
                term.serviceLocations = pincodeList;
              }

              RangeFilter rangeFilter = new RangeFilter();

              OutOfStockProduct outOfStockProduct=new OutOfStockProduct();
              outOfStockProduct.gte="1";

              rangeFilter.outOfStock=outOfStockProduct;

              filterCredentials.term = term;
              filterCredentials.range=rangeFilter;

              productListingCredentials.filter = filterCredentials;
              if (content.id != null ||
                  content.id != "" ||
                  content.id != ("null")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListing(
                        apiName: "productListing",
                        getContentProductsCredentials:
                            getContentProductsCredentials,
                        productListingCredentials: productListingCredentials,
                        categoryName: content.categoryName,
                        subCategory0Id: content.id,
                      ),
                    ));
              }
            } else {
              _showAlert("No internet connection",
                  "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.");
            }
          },
        ),
        children: <Widget>[
          new Column(
            children: buildExpandableContentCategoryOne(content.subCategories),
          ),
        ],
      ));

    return columnContent;
  }

  buildExpandableContentCategoryOne(List<SubCategoryLevelOne> document) {
    List<Widget> columnContent = [];

    for (SubCategoryLevelOne content in document)
      columnContent.add(ExpansionTile(
        title: FlatButton(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  content.categoryName,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          onPressed: () async {
            bool checkConnection = await DataConnectionChecker().hasConnection;
            if (checkConnection == true) {
              GetContentProductsCredentials getContentProductsCredentials =
                  new GetContentProductsCredentials();
              ProductListingCredentials productListingCredentials =
                  new ProductListingCredentials();
              productListingCredentials.key = content.categoryName;
              productListingCredentials.offset = 0;
              productListingCredentials.size = 20;
              productListingCredentials.hasRangeAndSort = false;
              productListingCredentials.forMobileApp = true;
              List<String> categoryIdList = new List();
              categoryIdList.add(content.id);
              FilterCredentials filterCredentials = new FilterCredentials();
              TermCredentials term = new TermCredentials();
              term.subCategory1Id = categoryIdList;
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              final pinCode = preferences.getString("pinCode");
              List<String> pincodeList = new List();
              if (pinCode != null && pinCode != ("null") && pinCode != ("")) {
                pincodeList.add(pinCode);
                pincodeList.add("All India");
                term.serviceLocations = pincodeList;
              }

              RangeFilter rangeFilter = new RangeFilter();

              OutOfStockProduct outOfStockProduct=new OutOfStockProduct();
              outOfStockProduct.gte="1";

              rangeFilter.outOfStock=outOfStockProduct;

              filterCredentials.term = term;
              filterCredentials.range=rangeFilter;

              productListingCredentials.filter = filterCredentials;
              if (content.id != null ||
                  content.id != "" ||
                  content.id != ("null")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListing(
                        apiName: "productListing",
                        getContentProductsCredentials:
                            getContentProductsCredentials,
                        productListingCredentials: productListingCredentials,
                        categoryName: content.categoryName,
                        subCategory1Id: content.id,
                      ),
                    ));
              }
            } else {
              _showAlert("No internet connection",
                  "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.");
            }
          },
        ),
        children: <Widget>[
          new Column(
            children: buildExpandableContentCategoryTwo(content.subCategories),
          ),
        ],
      ));

    return columnContent;
  }

  buildExpandableContentCategoryTwo(List<SubCategoryLevelTwo> document2) {
    List<Widget> columnContent = [];
    for (SubCategoryLevelTwo content in document2) {
      columnContent.add(new ExpansionTile(
        title: FlatButton(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  content.categoryName,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          onPressed: () async {
            bool checkConnection = await DataConnectionChecker().hasConnection;
            if (checkConnection == true) {
              GetContentProductsCredentials getContentProductsCredentials =
                  new GetContentProductsCredentials();
              ProductListingCredentials productListingCredentials =
                  new ProductListingCredentials();
              productListingCredentials.key = content.categoryName;
              productListingCredentials.offset = 0;
              productListingCredentials.size = 20;
              productListingCredentials.sortBy = "price";
              productListingCredentials.sortType = "asc";
              productListingCredentials.hasRangeAndSort = false;
              productListingCredentials.forMobileApp = true;
              List<String> categoryIdList = new List();
              categoryIdList.add(content.id);
              FilterCredentials filterCredentials = new FilterCredentials();
             
              TermCredentials term = new TermCredentials();
              term.subCategory2Id = categoryIdList;
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              final pinCode = preferences.getString("pinCode");
              List<String> pincodeList = new List();
              if (pinCode != null && pinCode != ("null") && pinCode != ("")) {
                pincodeList.add(pinCode);
                pincodeList.add("All India");
                term.serviceLocations = pincodeList;
              }

              RangeFilter rangeFilter = new RangeFilter();

              OutOfStockProduct outOfStockProduct=new OutOfStockProduct();
              outOfStockProduct.gte="1";

              rangeFilter.outOfStock=outOfStockProduct;


              filterCredentials.term = term;
              filterCredentials.range=rangeFilter;


              productListingCredentials.filter = filterCredentials;
              if (categoryIdList[0] != null ||
                  categoryIdList[0] != "" ||
                  categoryIdList[0] != ("null")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListing(
                        apiName: "productListing",
                        getContentProductsCredentials:
                            getContentProductsCredentials,
                        productListingCredentials: productListingCredentials,
                        categoryName: content.categoryName,
                        subCategory2Id: categoryIdList[0],
                      ),
                    ));
              }
              else {
                showSnackBar("Currently not available");
              }

            } else {
              _showAlert("No internet connection",
                  "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.");
            }
          },
        ),
        children: <Widget>[
          new Column(
            children:
                buildExpandableContentCategoryThree(content.subCategories),
          ),
        ],
      ));
    }
    // leading: new Icon(Icons.directions_car),

    return columnContent;
  }

  buildExpandableContentCategoryThree(List<SubCategoryLevelThree> document3) {
    List<Widget> columnContent = [];
    for (SubCategoryLevelThree content in document3) {
      columnContent.add(new ListTile(
        onTap: () async {
          if (content.id != null && content.id != "") {
            GetContentProductsCredentials getContentProductsCredentials =
            new GetContentProductsCredentials();
            ProductListingCredentials productListingCredentials =
            new ProductListingCredentials();
            productListingCredentials.key = content.categoryName;
            productListingCredentials.offset = 0;
            productListingCredentials.size = 20;
            productListingCredentials.sortBy = "price";
            productListingCredentials.sortType = "asc";
            productListingCredentials.hasRangeAndSort = false;
            productListingCredentials.forMobileApp = true;
            List<String> categoryIdList = new List();
            categoryIdList.add(content.id);
            FilterCredentials filterCredentials = new FilterCredentials();
           
            TermCredentials term = new TermCredentials();
            term.subCategory3Id = categoryIdList;
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            final pinCode = preferences.getString("pinCode");
            List<String> pincodeList = new List();
            if (pinCode != null && pinCode != ("null") && pinCode != ("")) {
              pincodeList.add(pinCode);
              pincodeList.add("All India");
              term.serviceLocations = pincodeList;
            }

            RangeFilter rangeFilter = new RangeFilter();

            OutOfStockProduct outOfStockProduct=new OutOfStockProduct();
            outOfStockProduct.gte="1";

            rangeFilter.outOfStock=outOfStockProduct;

            filterCredentials.term = term;
            filterCredentials.range=rangeFilter;

            productListingCredentials.filter = filterCredentials;

            if (categoryIdList[0] != null ||
                categoryIdList[0] != "" ||
                categoryIdList[0] != ("null")) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductListing(
                          apiName: "productListing",
                          getContentProductsCredentials:
                          getContentProductsCredentials,
                          productListingCredentials: productListingCredentials,
                          categoryName: content.categoryName,
                          subCategory3Id: categoryIdList[0],
                        ),
                  ));
            }

            else
              {
                showSnackBar("Currently not available");

              }
          } else {
            showSnackBar("Currently not available");
          }
        },
        title: Padding(
          padding: const EdgeInsets.only(left: 60.0),
          child: new Text(
            content.categoryName,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
        ),
      ));
    }
    // leading: new Icon(Icons.directions_car),

    return columnContent;
  }

  //Category listing api call
  Future<CategoryModel> getCategory() async {
    setState(() {
      isLoading = true;
    });

    Result result = await _apiResponse.getCategory();

    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      CategoryModel categoryModel = (result).value;
      if (categoryModel.status == "success") {
        setState(() {
          categoryList = categoryModel.documents;
        });
      } else {
        showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      CategoryModel unAuthoedUser = (result).value;
      showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

  //Display snack bar
  void showSnackBar(String message) {
    final snackBarContent = SnackBar(
      // padding: EdgeInsets.only(bottom: 16.0),
      content: Text(message),
      action: SnackBarAction(
          label: 'OK',
          onPressed: _scaffoldkey.currentState.hideCurrentSnackBar),
    );
    _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }
}
