import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highrich/APICredentials/ProductListing/getContentProductsCredentials.dart';
import 'package:highrich/APICredentials/ProductListing/productlistingcredentials.dart';
import 'package:highrich/APICredentials/add_to_cart.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/Home/bottomNavScreen.dart';
import 'package:highrich/Screens/Home/cart.dart';
import 'package:highrich/Screens/pincodeDialog.dart';
import 'package:highrich/Screens/product_detail_page.dart';
import 'package:highrich/Screens/product_filter.dart';
import 'package:highrich/Screens/product_listing.dart';
import 'package:highrich/Screens/progress_hud.dart';
import 'package:highrich/Screens/search.dart';
import 'package:highrich/Screens/setPincodeFromProduct.dart';
import 'package:highrich/Screens/set_pincode_from_list.dart';
import 'package:highrich/database/database.dart';
import 'package:highrich/entity/CartEntity.dart';
import 'package:highrich/general/app_config.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/general/custom_dialog.dart';
import 'package:highrich/general/default_button.dart';
import 'package:highrich/general/shared_pref.dart';
import 'package:highrich/model/CartModel/cart_count_model.dart';
import 'package:highrich/model/cart_model.dart';
import 'package:highrich/model/get_brand_model.dart';
import 'package:highrich/model/default_model.dart';
import 'package:highrich/model/product_model.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:shared_preferences/shared_preferences.dart';

/*
 *  2021 Highrich.in
 */
class ProductListing extends StatefulWidget {
  String from;
  String apiName;
  String keyWord;
  String sectionId;
  String categoryId;
  String subCategory0Id;
  String subCategory1Id;
  String subCategory2Id;
  String subCategory3Id;
  String brandId;
  String vendorId;
  int categoryLevel;
  String categoryName;
  GetContentProductsCredentials getContentProductsCredentials;
  ProductListingCredentials productListingCredentials;
  final bool isFromFMCG;

  ProductListing(
      {@required this.apiName,
      this.getContentProductsCredentials,
      this.productListingCredentials,
      this.categoryName,
      this.from,
      this.categoryId,
      this.subCategory0Id,
      this.subCategory1Id,
      this.subCategory2Id,
      this.subCategory3Id,
      this.brandId,
      this.vendorId,
      this.isFromFMCG = false,
      });

  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListing> {
  int _currentIndex = 1;
  int size = 10;
  int Qty = 1;
  int quantity = 1;
  String key = "";
  String userId;
  int totalCount;
  int offset = 0;
  String from;
  String categoryId;
  int categoryLevel;
  String product_id;
  String pinCode = "";
  String productName;
  String vendorId = "";
  String apiName = "";
  String categoryName;
  String sectionId = "";
  String brandsId = "";
  String subCategory0Id;
  String subCategory1Id;
  String subCategory2Id;
  String subCategory3Id;
  String imageUrl = "";
  String vendorType = "";
  bool isLoading = false;
  var newListProductpage;
  int itemListingFlag = 0;
  int totalProductCount = 0;
  Map filterPageParmsContent;
  String sortType = "relevance";
  bool _isRadioSelected = false;
  bool isFromFilterPage = false;
  PersistentTabController _controller;
  var filterParamsProductListingPage;
  SharedPref sharedPref = SharedPref();
  bool _isPaginationInProgress = false;
  List<Products> productlist = new List();
  List<ImageBrands> brands = new List();
  RemoteDataSource _apiResponse = RemoteDataSource();
  ProductListingCredentials productListingCredentials;
  ScrollController scrollController = ScrollController();
  GetContentProductsCredentials getContentProductsCredentials;
  ProcessedPriceAndStocks selectedUnit = new ProcessedPriceAndStocks();
  ItemCurrentPrice itemCurrentPriceCredential = new ItemCurrentPrice();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    productlist = [];
    totalProductCount = 0;
    apiName = widget.apiName;
    from = widget.from;
    brandsId = widget.brandId;
    getContentProductsCredentials = widget.getContentProductsCredentials;
    productListingCredentials = widget.productListingCredentials;

    filterPageParmsContent = getContentProductsCredentials.toJson();
    filterPageParmsContent["forMobileApp"] = true;
    filterPageParmsContent["hasRangeAndSort"] = false;
    filterPageParmsContent["type"] = "section";
    //  filterPageParmsContent.remove("filter");
    filterParamsProductListingPage = productListingCredentials.toJson();
    filterParamsProductListingPage["type"] = "search-filter";
    filterParamsProductListingPage["forMobileApp"] = true;
    filterParamsProductListingPage["hasRangeAndSort"] = false;

    categoryName = widget.categoryName;
    categoryId = widget.categoryId;
    subCategory0Id = widget.subCategory0Id;
    subCategory1Id = widget.subCategory1Id;
    subCategory2Id = widget.subCategory2Id;
    subCategory3Id = widget.subCategory3Id;
    vendorId = widget.vendorId;

    loadProducts();
    DartNotificationCenter.subscribe(
        channel: "UPDATE_PIN_CODE",
        observer: this,
        onNotification: (result) {
          loadProducts();
        });
  }

  void getChangedPincode()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pinCode = (prefs.getString('pinCode') ?? '');
  }

  @override
  void didUpdateWidget(covariant ProductListing oldWidget) {
    getChangedPincode();
    super.didUpdateWidget(oldWidget);
  }

  loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      productlist.clear();
      pinCode = (prefs.getString('pinCode') ?? '');
    });
    if (apiName == "productListing") {
      print("----------productListingCredentials-----------");
      FilterCredentials filterCredentials = new FilterCredentials();
      List<String> pincodeList = new List();
      TermCredentials term = new TermCredentials();
      if (pinCode != null && pinCode != ("null") && pinCode != ("")) {
        pincodeList.add(pinCode);
        pincodeList.add("All India");
        term.serviceLocations = pincodeList;
        print("PINCODELIST");
        print(pincodeList);
      }
      if (brandsId != null && brandsId != ("null") && brandsId != ("")) {
        List<String> brandList = new List();
        brandList.add(brandsId);
        term.brandId = brandList;
        print(widget.brandId);
      }

      if (vendorId != null && vendorId != ("null") && vendorId != ("")) {
        List<String> vendorsList = new List();
        vendorsList.add(vendorId);
        term.vendorId = vendorsList;
        print(widget.vendorId);
      }

      if (categoryId != null && categoryId != ("null") && categoryId != ("")) {
        List<String> selectedcategoryIdList = new List();
        selectedcategoryIdList.add(categoryId);
        term.categoryId = selectedcategoryIdList;
      }
      if (subCategory0Id != null &&
          subCategory0Id != ("null") &&
          subCategory0Id != ("")) {
        List<String> selectedcategoryIdList = new List();
        selectedcategoryIdList.add(subCategory0Id);
        term.subCategory0Id = selectedcategoryIdList;
      }

      if (subCategory1Id != null &&
          subCategory1Id != ("null") &&
          subCategory1Id != ("")) {
        List<String> selectedcategoryIdList = new List();
        selectedcategoryIdList.add(subCategory1Id);
        term.subCategory1Id = selectedcategoryIdList;
      }
      if (subCategory2Id != null &&
          subCategory2Id != ("null") &&
          subCategory2Id != ("")) {
        List<String> selectedcategoryIdList = new List();
        selectedcategoryIdList.add(subCategory2Id);
        term.subCategory2Id = selectedcategoryIdList;
      }
      if (subCategory3Id != null &&
          subCategory3Id != ("null") &&
          subCategory3Id != ("")) {
        List<String> selectedcategoryIdList = new List();
        selectedcategoryIdList.add(subCategory3Id);
        term.subCategory3Id = selectedcategoryIdList;
      }
      OutOfStockProduct outOfStockProduct = new OutOfStockProduct();
      outOfStockProduct.gte = "1";
      RangeFilter range = new RangeFilter();
      range.outOfStock = outOfStockProduct;
      filterCredentials.range = range;
      filterCredentials.term = term;
      productListingCredentials.filter = filterCredentials;
      productListingCredentials.hasRangeAndSort = false;
      getProducts(productListingCredentials);
    } else {
      print("----------getContentProductsCredentials-----------");
      FilterCredentialsContent filterCredentials =
          new FilterCredentialsContent();
      TermCredentialsContent termCredentials = TermCredentialsContent();
      List<String> pincodeList = new List();
      if (pinCode != null && pinCode != ("null") && pinCode != ("")) {
        pincodeList.add(pinCode);
        pincodeList.add("All India");
        termCredentials.serviceLocations = pincodeList;
      }
      OutOfStockGetContent outOfStockGetContent = new OutOfStockGetContent();
      outOfStockGetContent.gte = "1";
      RangeFilterContent rangeFilterContent = new RangeFilterContent();
      rangeFilterContent.outOfStock = outOfStockGetContent;
      filterCredentials.range = rangeFilterContent;
      filterCredentials.term = termCredentials;
      getContentProductsCredentials.filter = filterCredentials;
      getContentProductsCredentials.hasRangeAndSort = false;
      getContentProductsCredentials.forMobileApp = true;
      getContentProducts(getContentProductsCredentials);
    }
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
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!_isPaginationInProgress) {
          if (size < totalCount) {
            _isPaginationInProgress = true;
            offset = offset + size;
            if (apiName == "productListing") {
              productListingCredentials.offset = offset;
              getProducts(productListingCredentials);
            } else {
              getContentProductsCredentials.offset = offset;
              getContentProducts(getContentProductsCredentials);
            }
          }
        }
      }
    });

    _loadPinCode() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        pinCode = (prefs.getString('pinCode') ?? '');
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.black,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(categoryName ?? "",
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              if (from == "Searchpage") {
                Navigator.pop(context);
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Searchpage()));
              }
            },
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) =>
                          pinCodeDialog(message: "Please wait"));
                },
                child: Text(pinCode != defaultPincode ? pinCode : "",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.w700)),
              ),
              pinCode != defaultPincode ? IconButton(
                icon: Icon(
                  Icons.my_location,
                  color: Colors.blue,
                ),
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) =>
                          pinCodeDialog(message: "Please wait"));
                },
              ) : SizedBox.shrink(),
              Container(
                margin: EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: Image.asset("images/global_icon.png",height: 22,width: 22),
                  onPressed: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString("pinCode","");
                    _loadPinCode();
                    loadProducts();
                  },
                ),
              )
            ],
          )
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: Container(
            child: Container(
                child: Column(
          children: [
            itemListingFlag != 1 && !isFromFilterPage
                ? Container()
                : Container(
                    height: 40,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Spacer(),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductFilterPage(
                                        apiName: apiName,
                                        productListingCredentials:
                                            productListingCredentials,
                                        categoryName: categoryName,
                                        filterPageParms:
                                            filterParamsProductListingPage,
                                        getContentProductsCredentials:
                                            getContentProductsCredentials,
                                        filterPageParmsContent:
                                            filterPageParmsContent,
                                        categoryId: categoryId,
                                        subCategory0Id: subCategory0Id,
                                        subCategory1Id: subCategory1Id,
                                        subCategory2Id: subCategory2Id,
                                        subCategory3Id: subCategory3Id),
                                  )).then((value) {
                                    _loadPinCode();
                                apiName = value[0];
                                productListingCredentials = value[1];
                                categoryName = value[2];
                                getContentProductsCredentials = value[3];
                                isFromFilterPage = value[4];
                                _isPaginationInProgress = true;
                                if (isFromFilterPage == true) {
                                  offset = 0;
                                }
                                productlist.clear();
                                if (apiName == "productListing") {
                                  getProducts(productListingCredentials);
                                } else {
                                  getContentProducts(
                                      getContentProductsCredentials);
                                }
                              });
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset("images/filter.svg"),
                                SizedBox(
                                  width: 12,
                                ),
                                Text("Filter")
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 1,
                          color: Colors.grey.shade200,
                        ),
                        Spacer(),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              offset = 0;
                              Future(() => showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return ModalBottomSheetSort(
                                        sortType: sortType,
                                        valueChanged: (value) {
                                          sortType = value;
                                          if (apiName == "productListing") {
                                            setState(() {
                                              productlist.clear();
                                            });
                                            productListingCredentials.sortBy =
                                                "price";
                                            productListingCredentials.sortType =
                                                sortType;
                                            productListingCredentials.offset =
                                                0;
                                            getProducts(
                                                productListingCredentials);
                                          } else if (apiName == "search") {
                                            setState(() {
                                              productlist.clear();
                                            });
                                            productListingCredentials.sortBy =
                                                "price";
                                            productListingCredentials.sortType =
                                                sortType;
                                            productListingCredentials.offset =
                                                0;
                                            getProducts(
                                                productListingCredentials);
                                          } else if (apiName == "category") {
                                            setState(() {
                                              productlist.clear();
                                            });
                                            productListingCredentials.sortBy =
                                                "price";
                                            productListingCredentials.sortType =
                                                sortType;
                                            productListingCredentials.offset =
                                                0;
                                            getProducts(
                                                productListingCredentials);
                                          } else {
                                            setState(() {
                                              productlist.clear();
                                            });
                                            getContentProductsCredentials
                                                .sortType = sortType;
                                            getContentProductsCredentials
                                                .sortBy = "price";
                                            getContentProductsCredentials
                                                .offset = 0;
                                            getContentProducts(
                                                getContentProductsCredentials);
                                          }
                                          Navigator.pop(context);
                                        });
                                  }));
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset("images/sort.svg"),
                                SizedBox(
                                  width: 12,
                                ),
                                Text("Sort")
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    )),
            itemListingFlag == 1
                ? Container(
                    height: 54,
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(totalProductCount.toString() + " Results"),
                      ),
                    ),
                  )
                : Container(),
            itemListingFlag == 1
                ? Expanded(
                    child: Container(
                    color: Colors.grey.shade200,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 1 / 1.70,
                          //  crossAxisSpacing: 0,
                          mainAxisSpacing: 2),
                      controller: scrollController,
                      itemCount: productlist.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 2.0),
                          child: InkWell(
                            onTap: () {
                              product_id = productlist[index].source.productId;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Product_Detail_Page(
                                      product_id: product_id,
                                    ),
                                  )).then((value) {
                                _loadPinCode();
                              });
                            },
                            child: Container(
                              //  margin: EdgeInsets.only(top: 8, left: 4),
                              height: 180,
                              width: 165,
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey[300], width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                elevation: 0,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(4),
                                                              bottomLeft: Radius
                                                                  .circular(4)),
                                                      color: Colors.red[700],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          getDiscount(index),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12.0,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SvgPicture.asset(
                                                    'images/flag.svg',
                                                    color: Colors.red[700],
                                                    height: 20,
                                                  ),
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          width: 130,
                                          height: 120,
                                          // decoration: BoxDecoration(
                                          //   border:  Border.all(color: Colors.blueAccent),
                                          //   borderRadius: BorderRadius.circular(10)
                                          // ),
                                          child: Padding(
                                              padding: EdgeInsets.all(6),
                                              child: productlist[index]
                                                          .source
                                                          .images
                                                          .length >
                                                      0
                                                  ? CachedNetworkImage(
                                                      imageUrl: (imageBaseURL +
                                                          productlist[index]
                                                              .source
                                                              .images[0]),
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child: new Text(
                                                        "LOADING...",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      )),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(Icons.error),
                                                    )
                                                  : SvgPicture.asset(
                                                      "images/placeholder_img.svg")),
                                        ),
                                        Expanded(
                                          child: Container(
                                            // height: 200,
                                            alignment: Alignment.centerLeft,
                                            // child: Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  top: 6.0,
                                                  bottom: 6.0,
                                                  right: 8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              20,
                                                          width: 150,
                                                          // child: Expanded(
                                                          //   flex: 3,
                                                          child: Text(
                                                            productlist[index]
                                                                .source
                                                                .name,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  //     Spacer(),
                                                  // Expanded(
                                                  //   flex: 1,
                                                  //   child: Text(
                                                  //     '',
                                                  //     style: TextStyle(
                                                  //       fontWeight:
                                                  //           FontWeight.bold,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  //   ],
                                                  // ),
                                                  // SizedBox(
                                                  //   height: 4,
                                                  // ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          getSellingPrice(
                                                              index),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .deepOrangeAccent,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          getActualPrice(index),
                                                          style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey.shade500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        getUnit(index),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12.0),
                                                      ),
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      // Text(
                                                      //   getDiscount(index),
                                                      //   style: TextStyle(
                                                      //     fontWeight:
                                                      //         FontWeight.bold,
                                                      //     color: Colors
                                                      //         .green,
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  // // Row(
                                                  // //   children: [
                                                  // //     Text(
                                                  // //       getUnit(index),
                                                  // //       style: TextStyle(
                                                  // //           fontWeight:
                                                  // //               FontWeight.w600,
                                                  // //           color: Colors.black87,
                                                  // //           fontSize: 12.0),
                                                  // //     ),
                                                  // //     SizedBox(
                                                  // //       width: 12,
                                                  // //     ),
                                                  // //     Visibility(
                                                  // //       visible:
                                                  // //           checkDiscount(index),
                                                  // //       child: Container(
                                                  // //         width: 80,
                                                  // //         height: 30,
                                                  // //         child: Stack(
                                                  // //           children: [
                                                  // //             // SvgPicture.asset(
                                                  // //             //   'images/OfferBg.svg',
                                                  // //             //   height: 30,
                                                  // //             // ),
                                                  // //             Center(

                                                  // //               child: Text(
                                                  // //                 getDiscount(
                                                  // //                     index),
                                                  // //                 style: TextStyle(
                                                  // //                     color: Colors
                                                  // //                         .green,
                                                  // //                     fontWeight:
                                                  // //                         FontWeight
                                                  // //                             .bold,
                                                  // //                     fontSize:
                                                  // //                         12.0),
                                                  // //               ),
                                                  // //             )
                                                  // //           ],
                                                  // //         ),
                                                  // //       ),
                                                  // //     ),
                                                  // //     Spacer(),
                                                  // //   ],
                                                  // // ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  productlist[index]
                                                              .source
                                                              .processedPriceAndStock
                                                              .length >
                                                          0
                                                      ? AppConfig.isAuthorized ? Row(
                                                          children: [
                                                            Text(
                                                              "SI:",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  fontSize:
                                                                      14.0),
                                                              maxLines: 1,
                                                            ),
                                                            SizedBox(
                                                              width: 6,
                                                            ),
                                                            Text(
                                                              // '₹ ' +
                                                              productlist[index]
                                                                  .source
                                                                  ?.processedPriceAndStock[
                                                                      0]
                                                                  ?.salesIncentive
                                                                  ?.toStringAsFixed(
                                                                      2)
                                                                  ?.toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  fontSize:
                                                                      14.0),
                                                            )
                                                          ],
                                                        ) : SizedBox.shrink()
                                                      : Container(),
                                                  SizedBox(height: 2),
                                                  /*ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize: Size(
                                                          double.infinity,
                                                          30), // double.infinity is the width and 30 is the height
                                                    ),
                                                    onPressed: () {
                                                      _moveToCart(index);
                                                    },
                                                    child: Text('ADD TO CART'),
                                                  ),*/

                                                  //  Expanded(child: Container(
                                                  //   padding: EdgeInsets.only(top: 5, bottom: 5),
                                                  //   width: MediaQuery.of(context).size.width,
                                                  //   decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(3)),
                                                  //   child: Align(alignment: Alignment.center, child:  Text("ADD TO CART", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),),
                                                  // ),
                                                  // ),
                                                  // Container(
                                                  //   height:5
                                                  // ),

                                                  // IconButton(
                                                  //   onPressed: () {
                                                  //     _moveToCart(index);
                                                  //   },
                                                  //   icon: SvgPicture.asset(
                                                  //       "images/cart_orange.svg"),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ))
                : itemListingFlag == 2
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: SvgPicture.asset(
                                    "images/no_items_image.svg")),
                            SizedBox(
                              height: 20,
                            ),
                            Center(child: Text("No products here!")),
                          ],
                        ),
                      )
                    : Container(),
          ],
        ))),
      ),
      key: _scaffoldkey,
    );
  }

  _moveToCart(int index) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await SharedPref.shared.getToken();
    pinCode = prefs.getString('pinCode');
    print("PINCODEEEEEE" + pinCode);
    // if (token != null && token != ("null") && token != "") {
    if (pinCode != null && pinCode != ("null") && pinCode != "") {
      ModalBottomSheet mbs = new ModalBottomSheet(
          processedPriceAndStockList:
              productlist[index].source.processedPriceAndStock,
          productName: productlist[index].source.name,
          productImage: productlist[index].source.images[0],
          productID: productlist[index].source.productId,
          vendorId: productlist[index].source.vendorId,
          vendorType: productlist[index].source.vendorType);
      Future(() => showModalBottomSheet(
          context: context,
          builder: (context) {
            return mbs;
          }));
    }
    else if(pinCode == null || pinCode.isEmpty || pinCode == "null"){
      print(productlist[index].source.serviceLocations);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) =>
              SetPincodeFromProductDialog(message: "Please wait",
                  serviceLocations: productlist[index].source.serviceLocations))
          .then((value) async{
        print(value);
        if(value==null){
          return;
        }
        else if(value=="pincode"){
          ModalBottomSheet mbs = new ModalBottomSheet(
              processedPriceAndStockList:
              productlist[index].source.processedPriceAndStock,
              productName: productlist[index].source.name,
              productImage: productlist[index].source.images[0],
              productID: productlist[index].source.productId,
              vendorId: productlist[index].source.vendorId,
              vendorType: productlist[index].source.vendorType);
          Future(() => showModalBottomSheet(
              context: context,
              builder: (context) {
                return mbs;
              }));
        } else {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) =>
                  SetPinCodeFromList(pinCode: value[0],enteredPinCode: value[1])).then((value) {
            if(value!=null){
              ModalBottomSheet mbs = new ModalBottomSheet(
                  processedPriceAndStockList:
                  productlist[index].source.processedPriceAndStock,
                  productName: productlist[index].source.name,
                  productImage: productlist[index].source.images[0],
                  productID: productlist[index].source.productId,
                  vendorId: productlist[index].source.vendorId,
                  vendorType: productlist[index].source.vendorType);
              Future(() => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return mbs;
                  }));
            }
          });
        }
      });
    }
    else {
      print(productlist[index].source.serviceLocations);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) =>
              SetPincodeFromProductDialog(message: "Please wait",
                  serviceLocations: productlist[index].source.serviceLocations))
          .then((value) async{
        print(value);
        if(value==null){
          return;
        }
        else if(value=="pincode"){
          ModalBottomSheet mbs = new ModalBottomSheet(
              processedPriceAndStockList:
              productlist[index].source.processedPriceAndStock,
              productName: productlist[index].source.name,
              productImage: productlist[index].source.images[0],
              productID: productlist[index].source.productId,
              vendorId: productlist[index].source.vendorId,
              vendorType: productlist[index].source.vendorType);
          Future(() => showModalBottomSheet(
              context: context,
              builder: (context) {
                return mbs;
              }));
        } else {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) =>
                  SetPinCodeFromList(pinCode: value[0],enteredPinCode: value[1])).then((value) {
            if(value!=null){
              ModalBottomSheet mbs = new ModalBottomSheet(
                  processedPriceAndStockList:
                  productlist[index].source.processedPriceAndStock,
                  productName: productlist[index].source.name,
                  productImage: productlist[index].source.images[0],
                  productID: productlist[index].source.productId,
                  vendorId: productlist[index].source.vendorId,
                  vendorType: productlist[index].source.vendorType);
              Future(() => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return mbs;
                  }));
            }
          });
        }
      });
    }
  }

  //Product listing api call
  Future<ProductsModel> getProducts(
      ProductListingCredentials productListingCredentials) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    setState(() {
      isLoading = true;
    });

    Result result =
        await _apiResponse.productListing(productListingCredentials,isFromFMCG: widget.isFromFMCG);

    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      ProductsModel response = (result).value;
      if (response.status == "success") {
        print(response);
        setState(() {
          totalProductCount = response.count;
          productlist.addAll(response.products);
        });
        totalCount = response.count;
        setState(() {
          if (productlist.length > 0) {
            itemListingFlag = 1;
          } else {
            itemListingFlag = 2;
          }
        });

        _isPaginationInProgress = false;
      } else {
        showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      ProductsModel unAuthoedUser = (result).value;
      showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

//Product listing api call
  Future<ProductsModel> getContentProducts(
      GetContentProductsCredentials getContentProductsCredentials) async {
    setState(() {
      isLoading = true;
    });

    Result result =
        await _apiResponse.getContentProducts(getContentProductsCredentials,isFromFMCG: widget.isFromFMCG);

    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      ProductsModel response = (result).value;
      if (response.status == "success") {
        setState(() {
          totalProductCount = response.count;
          productlist.addAll(response.products);
        });
        totalCount = response.count;

        setState(() {
          if (productlist.length > 0) {
            itemListingFlag = 1;
          } else {
            itemListingFlag = 2;
          }
        });

        _isPaginationInProgress = false;
      } else {
        showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      ProductsModel unAuthoedUser = (result).value;
      showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

//Display snack bar
  void showSnackBar(String message) {
    final snackBarContent = SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: 'OK',
          onPressed: () => ScaffoldMessenger.of(context)
              .hideCurrentSnackBar(reason: SnackBarClosedReason.hide)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarContent);
  }

  //To show selling price
  String getSellingPrice(int index) {
    String key;
    if (productlist[index].source.processedPriceAndStock.length > 0) {
      key = "₹ " +
          productlist[index]
              .source
              .processedPriceAndStock[0]
              .sellingPrice
              .toStringAsFixed(2)
              .toString();
    } else {
      key = "₹ 0";
    }
    return key;
  }

  //To show actual price
  String getActualPrice(int index) {
    String key;
    if (productlist[index].source.processedPriceAndStock.length > 0) {
      key = "₹ " +
          productlist[index]
              .source
              .processedPriceAndStock[0]
              .price
              .toStringAsFixed(2)
              .toString();
    } else {
      key = "₹ 0";
    }
    return key;
  }

  //To show unit
  String getUnit(int index) {
    String key;
    if (productlist[index].source.processedPriceAndStock.length > 0) {
      if (productlist[index].source.processedPriceAndStock.length >= 5) {
        key = productlist[index]
                .source
                .processedPriceAndStock[0]
                .quantity
                .toString() +
            " " +
            productlist[index]
                ?.source
                ?.processedPriceAndStock[0]
                ?.unit
                .toString();
      } else {
        key = productlist[index]
                .source
                .processedPriceAndStock[0]
                .quantity
                .toString() +
            " " +
            productlist[index].source.processedPriceAndStock[0].unit.toString();
      }
    } else {
      key = "";
    }
    return key;
  }

//To show discount
  bool checkDiscount(int index) {
    bool discountFlag = false;
    if (productlist[index].source.processedPriceAndStock.length > 0) {
      String discount = productlist[index]
          .source
          .processedPriceAndStock[0]
          .discount
          .toString();
      if (discount != null) {
        discountFlag = true;
      } else {
        discountFlag = false;
      }
    } else {
      discountFlag = false;
    }
    return discountFlag;
  }

  //To show discount
  String getDiscount(int index) {
    String key;
    if (productlist[index].source.processedPriceAndStock.length > 0) {
      key = productlist[index]
              .source
              .processedPriceAndStock[0]
              .discount
              .round()
              .toString() +
          "% OFF";
    } else {
      key = "";
    }
    return key;
  }
}

class ModalBottomSheet extends StatefulWidget {
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
  String productName, productImage, productID, vendorId, vendorType;
  List<ProcessedPriceAndStocks> processedPriceAndStockList = new List();

  ModalBottomSheet(
      {@required this.processedPriceAndStockList,
      this.productName,
      this.productImage,
      this.productID,
      this.vendorId,
      this.vendorType});
}

class _ModalBottomSheetState extends State<ModalBottomSheet>
    with SingleTickerProviderStateMixin {
  int Qty = 1;
  String userId;
  int _currentIndex = 1;
  bool isLoading = false;
  bool radioClicked = false;
  ProcessedPriceAndStocks selectedPrice;
  int stockValue = 0;
  String token;
  var cartDao;
  int guestCartCount = 0;
  CartCountModel cartCountModel;
  var heightOfModalBottomSheet = 400.0;
  String productName, productImage, productID, vendorId, vendorType;
  RemoteDataSource _apiResponse = RemoteDataSource();
  ProcessedPriceAndStocks selectedUnit = new ProcessedPriceAndStocks();
  List<ProcessedPriceAndStocks> processedPriceAndStockList = new List();
  ItemCurrentPrice itemCurrentPriceCredential = new ItemCurrentPrice();

  @override
  void initState() {
    DartNotificationCenter.post(
      channel: "cartCount_event",
      options: "getCart",
    );
    _loadPinCode();
    processedPriceAndStockList = widget.processedPriceAndStockList;
    productName = widget.productName;
    productImage = widget.productImage;
    productID = widget.productID;
    vendorId = widget.vendorId;
    vendorType = widget.vendorType;

    if (processedPriceAndStockList.length > 0) {
      selectedPrice = processedPriceAndStockList[0];
      stockValue = selectedPrice.stock;
    }
    DartNotificationCenter.subscribe(
        channel: "CARTCOUNT_MODEL",
        observer: this,
        onNotification: (result) {
          cartCountModel = result;
        });
  }

  _loadPinCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
  }

  Widget build(BuildContext context) {
    for (int i = 0; i < processedPriceAndStockList.length; i++) {
      print(processedPriceAndStockList[i].quantity +
          " " +
          processedPriceAndStockList[i].unit);
    }
    return ListView(
      padding: EdgeInsets.all(8.0),
      shrinkWrap: true,
      children: <Widget>[
        new ListTile(
            title: new Text(
              productName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            onTap: () => {}),
        Divider(
          color: Colors.grey,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[100],
          ),
          child: isLoading
              ? Container(
                  height: MediaQuery.of(context).size.height - 300,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                )
              : ListView(
                  padding: EdgeInsets.all(2.0),
                  children: processedPriceAndStockList
                      .map((item) => RadioListTile(
                            groupValue: selectedPrice,
                            title: Text(
                              item.quantity + " " + item.unit,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600),
                            ),
                            value: item,
                            onChanged: (val) {
                              print("Selected rate" + val.toString());

                              setState(() {
                                selectedPrice = val;
                                selectedUnit = selectedPrice;
                                radioClicked = true;
                                stockValue = selectedPrice.stock;
                              });
                            },
                          ))
                      .toList(),
                ),
        ),
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Container(
                    height: 100,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 40,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colorButtonBlue,
                            ),
                            child: TextButton(
                              //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              onPressed: () {
                                setState(() {
                                  if (Qty > 1) {
                                    Qty = Qty - 1;
                                  }
                                });
                              },
                              child: Center(
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 40,
                            width: 50,
                            child: Center(
                              child: Text(
                                '$Qty',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 40,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colorButtonBlue,
                            ),
                            child: TextButton(
                              //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              onPressed: () {
                                setState(() {
                                  Qty = Qty + 1;
                                });
                              },
                              child: Center(
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: InkWell(
                  onTap: () {
                    if (token != null && token != ("null") && token != "") {
                      if (stockValue >= Qty) {
                        List<String> productIDList = cartCountModel?.cartItems
                            ?.map((e) => e.productId)
                            ?.toList();
                        List<int> seriesIDList = cartCountModel?.cartItems
                            ?.map((e) => e.serialNumber)
                            ?.toList();
                        if (radioClicked == false) {
                          selectedUnit = processedPriceAndStockList[0];
                        }
                        // if (productIDList.contains(productID)) {
                        //   if (seriesIDList
                        //       .contains(selectedUnit.serialNumber)) {
                        //     showToast("Item already exist in the cart");
                        //     print("sample" + seriesIDList.toString());
                        //     print("Exception:::" +
                        //         selectedUnit.serialNumber.toString());
                        //     if (cartCountModel?.cartItems[0].variant ==
                        //         selectedUnit.quantity + selectedUnit.unit) {
                        //       print("SAME VARIENT");
                        //     } else {
                        //       print("NOT SAME VARIENT");
                        //       // addToCart();
                        //     }
                        //   } else {
                        //     print("sample3");
                        //     addToCart();
                        //   }
                        // } else {
                        //   print("sample2");
                        //   addToCart();
                        // }
                        addToCart();
                      } else {
                        showToast("Out of stock");
                      }
                    } else {
                      guestCart();
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        color: stockValue < Qty ? Colors.grey : colorButtonOrange,),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child:
                                  SvgPicture.asset("images/ic_cart_white.svg"),
                            ),
                            Text(
                              stockValue < Qty ? "Out of Stock" : "Add to Cart",
                              style: (TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white)),
                            )
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  guestCart() async {
    bool isAlreadyInCart = false;
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    cartDao = database.cartDao;

    setState(() {
      isLoading = true;
    });

    List<CartEntity> resultEntity = await cartDao.getGuestCart();
    List<String> cartListTemp = new List();
    List<CartItems> getCartList = new List();
    List<int> seriesIDList = new List();
    List<String> guestCartProductIDList = new List();
    cartListTemp = resultEntity.map((e) => e.itemsInCart).toList();
    Map<String, dynamic> userMap;
    cartListTemp.map((e) => null);
    for (int i = 0; i < cartListTemp.length; i++) {
      Map<String, dynamic> userMap = jsonDecode(cartListTemp[i]);
      CartItems cartItemModel = CartItems.fromJson(userMap);

      setState(() {
        getCartList.add(cartItemModel);
        guestCartProductIDList.add(cartItemModel.productId);
        seriesIDList.add(cartItemModel.itemCurrentPrice.serialNumber);
      });
    }
    if (stockValue < Qty) {
      print("Stock out============");
      // showToast("Out Of Stock");
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) =>
              CustomDialog(message: "Product out of stock!"));
      setState(() {
        isLoading = false;
      });
    } else {
      if (guestCartProductIDList.contains(productID)) {
        getCartList.forEach((element) {
          if (element.itemCurrentPrice.serialNumber ==
              selectedUnit.serialNumber) {
            isAlreadyInCart = true;
          }
        });
        if (isAlreadyInCart) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) =>
                  CustomDialog(message: "Item already exist in the cart"));
          setState(() {
            isLoading = false;
          });
        } else {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) =>
                  CustomDialog(message: "Item already exist in the cart"));
          setState(() {
            isLoading = false;
          });
        }
      } else {
        addToGuestCart();
      }
    }
  }

  getGuestCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      guestCartCount = prefs.getInt("guestCartCount");
    });
  }

  setGuestCartCount(int guestCartCount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("guestCartCount", guestCartCount);
  }

  addToGuestCart() async {
    if (radioClicked == false) {
      selectedUnit = processedPriceAndStockList[0];
    }
    getGuestCartCount();
    CartItems cartItemModel = new CartItems();
    cartItemModel.productId = productID;
    cartItemModel.productName = productName;
    cartItemModel.vendorId = vendorId;
    cartItemModel.vendorType = vendorType;
    cartItemModel.quantity = Qty;
    cartItemModel.image = productImage;
    cartItemModel.itemCurrentPrice = selectedUnit;
    cartItemModel.processedPriceAndStocks = processedPriceAndStockList;
    String jsonCartItemModel = jsonEncode(cartItemModel);
    print(jsonCartItemModel);

    final cart = CartEntity(null, jsonCartItemModel);
    await cartDao.addToGuestCart(cart);

    Fluttertoast.showToast(
        msg: "Item Added to Cart", backgroundColor: Color(0xFF42A5F5));
    // showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) =>
    //         CustomDialog(message: "Item added to cart"));

    setState(() {
      isLoading = false;
      if (guestCartCount != null) {
        guestCartCount = guestCartCount + Qty;
      } else {
        guestCartCount = 1;
      }

      setGuestCartCount(guestCartCount);
    });
    DartNotificationCenter.post(
      channel: "cartCount_event",
      options: "getGuestCart",
    );
    DartNotificationCenter.post(channel: "getCart");
  }

  // //Add to cart api
  Future<DefaultModel> addToCart() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    userId = preferences.getString("userId");
    itemCurrentPriceCredential.serialNumber = selectedUnit.serialNumber;
    itemCurrentPriceCredential.batchNumbers = selectedUnit.batchNumbers;
    itemCurrentPriceCredential.variant = selectedUnit.variant;
    itemCurrentPriceCredential.quantity = selectedUnit.quantity;
    itemCurrentPriceCredential.unit = selectedUnit.unit;
    itemCurrentPriceCredential.batchType = selectedUnit.batchType;
    itemCurrentPriceCredential.addedDate = selectedUnit.addedDate;
    itemCurrentPriceCredential.expiryDate = selectedUnit.expiryDate;
    itemCurrentPriceCredential.price = selectedUnit.price.toDouble();
    itemCurrentPriceCredential.weightInKg = selectedUnit.weightInKg;

    if (selectedUnit.discount.toString() != null &&
        selectedUnit.discount.toString() != ("null")) {
      itemCurrentPriceCredential.discount = selectedUnit?.discount.toDouble();
    } else {
      itemCurrentPriceCredential.discount = 0;
    }
    itemCurrentPriceCredential.stock = selectedUnit.stock;
    itemCurrentPriceCredential.sellingPrice =
        selectedUnit.sellingPrice.toDouble();
    itemCurrentPriceCredential.salesIncentive = selectedUnit.salesIncentive;
    setState(() {
      isLoading = true;
    });
    print(jsonEncode(itemCurrentPriceCredential));
    Result result = await _apiResponse.addToCart(userId, productID, vendorId,
        vendorType, Qty, token, itemCurrentPriceCredential);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      DefaultModel defaultModel = (result).value;
      if (defaultModel.status == "success") {
        DartNotificationCenter.post(
          channel: "cartCount_event",
          options: "getCart",
        );

        DartNotificationCenter.post(channel: 'getCart');
        Navigator.of(context).pop();
        // _showAlert("Success!", defaultModel.message);
        Fluttertoast.showToast(
            msg: "Item Added to Cart", backgroundColor: Color(0xFF42A5F5));
        print(defaultModel.message);
      } else {
        showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      DefaultModel unAuthoedUser = (result).value;
      showSnackBar("Failed, please try agian later");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("LOGIN", false);
      prefs.setString("token", "");
      prefs.setString("userId", "");
      prefs.setString("pinCode", "");

      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => new BottomNavScreen()));
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

  //Display snack bar
  void showSnackBar(String message) {
    final snackBar = SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            // Some code to undo the change.
          },
        ));
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
            TextButton(
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
}

class ModalBottomSheetSort extends StatefulWidget {
  final ValueChanged valueChanged;
  String sortType;

  ModalBottomSheetSort({@required this.sortType, this.valueChanged});

  _ModalBottomSheetSortState createState() => _ModalBottomSheetSortState();
}

enum SingingCharacter { relevance, desc, asc }

class _ModalBottomSheetSortState extends State<ModalBottomSheetSort>
    with SingleTickerProviderStateMixin {
  var heightOfModalBottomSheet = 250.0;
  int _currentIndex = 1;
  String sortType;

  SingingCharacter _character;

  Widget build(BuildContext context) {
    sortType = widget.sortType;
    if (sortType == "asc") {
      _character = SingingCharacter.asc;
    } else if (sortType == "desc") {
      _character = SingingCharacter.desc;
    } else {
      _character = SingingCharacter.relevance;
    }
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        new ListTile(
            title: new Text(
              "Sort By",
            ),
            onTap: () => {}),
        Divider(),
        new RadioListTile(
          groupValue: _character,
          title: Text("Relevance"),
          value: SingingCharacter.relevance,
          onChanged: (val) {
            setState(() {
              _character = val;
              sortType = "relevance";
              widget.valueChanged(sortType);
              print("..." + sortType + ".....");
            });
          },
        ),
        new RadioListTile(
          groupValue: _character,
          title: Text("Price(Low - High)"),
          value: SingingCharacter.asc,
          onChanged: (val) {
            setState(() {
              _character = val;
              sortType = "asc";
              widget.valueChanged(sortType);
              print("..." + sortType + ".....");
            });
          },
        ),
        new RadioListTile(
          groupValue: _character,
          title: Text("Price(High - Low)"),
          value: SingingCharacter.desc,
          onChanged: (val) {
            setState(() {
              _character = val;
              sortType = "desc";
              widget.valueChanged(sortType);
              print("..." + sortType + ".....");
            });
          },
        ),
        // new RadioListTile(
        //   groupValue: _character,
        //   title: Text("Relevance(Popularity)"),
        //   value: SingingCharacter.relevance,
        //   onChanged: (val) {
        //     setState(() {
        //       _character = val;
        //       sortType = "relevance";
        //       widget.valueChanged(sortType);
        //       print("..." + sortType + ".....");
        //     });
        //   },
        // ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
