import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highrich/APICredentials/ProductListing/getContentProductsCredentials.dart';
import 'package:highrich/APICredentials/ProductListing/productlistingcredentials.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Screens/pincodeDialog.dart';
import 'package:highrich/Screens/product_detail_page.dart';
import 'package:highrich/Screens/product_listing.dart';
import 'package:highrich/Screens/search.dart';
import 'package:highrich/Screens/fastMoving_screen.dart';
import 'package:highrich/general/app_config.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/model/HomeModel/home_banner_model.dart';
import 'package:highrich/model/fast_moving_model.dart';
import 'package:highrich/model/HomeModel/home_category.dart';
import 'package:highrich/model/HomeModel/home_products_model.dart';
import 'package:highrich/model/HomeModel/home_products_section_model.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/services/system_navigator.dart';
import 'package:highrich/model/category_model.dart';
import 'package:highrich/model/get_brand_model.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/general/shared_pref.dart';
import 'package:highrich/model/product_model.dart';
import 'package:highrich/model/filter_response_model.dart';

import 'package:highrich/Screens/progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FastMoving extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  final String categoryId;
  final String brandId;
  final String pinCode;
  final int total;
  final String level;
  final String subCategoryId;
  final String advertisementId;
  final int type;
  GetBrandModel getBrandModel = new GetBrandModel();
  GetContentProductsCredentials getContentProductsCredentials;

  FastMoving({
    Key key,
    this.menuScreenContext,
    this.onScreenHideButtonPressed,
    this.hideStatus = false,
    this.categoryId,
    this.pinCode,
    this.subCategoryId,
    this.advertisementId,
    this.type,
    this.level,
    this.brandId,
    this.total,
    this.getBrandModel,
    this.getContentProductsCredentials,
  }) : super(key: key);

  @override
  _FastMovingState createState() => _FastMovingState();
}

class _FastMovingState extends State<FastMoving> {
  bool _hideNavBar;
  int _current = 0;
  String apiName;
  String pinCode = "";
  int bannerPostion = 0;
  double boxHeight = 300;
  bool isLoading = false;
  int totalCount;
  int totalProductCount;
  int itemListingFlag;
  bool _isPaginationInProgress = true;
  bool isPullDown = false;
  List<Widget> cardSliders;
  String categoryName = "";
  String categoryId = "";
  int totalBrands;
  String level = "";
  int total;
  String subCategoryId = "";
  int popularCategoryPosition = 0;
  HomeBannerModel bannerSectiondata;
  HomeCateogryModel homeCateogryModel;
  HomeProductsModel homeProductsModel;
  bool isFromFilterPage = true;
  PersistentTabController _controller;
  String CHANNEL_NAME = "cartCount_event";
  List<HomeBannerModel> homeBannerList = new List();
  List<Products> productlist = new List();
  RemoteDataSource _apiResponse = RemoteDataSource();
  HomeProductsSectionsModel homeProductsSectionsModel;
  List<HomeProductsSectionsModel> homeProductsSectionsList = new List();
  List<SubCategoryLevelMinusOne> categoryList = new List();
  List<BrandFilter> brandList = new List();
  List<String> selectedBrandList = new List();
  List<SubCategory> subCategories = new List();
  List<ImageBrands> brands = new List();
  BrandSource source = new BrandSource();
  GetBrandModel getBrandModel = new GetBrandModel();
  List<SectionDataFast> sectionData = new List();
  Advertisements advertisements = new Advertisements();
  // FastMovingModel fastMovingModel = new FastMovingModel();
  List<AdvertisementBanner> advertisementBanner = new List();
  List<AdvertisementCard> advertisementCardList = new List();
  List<String> adCardSlider = new List();
  TermCredentials termCredentials = new TermCredentials();
  final ScrollController _scrollController = ScrollController();
  ProductListingCredentials productListingCredentials =
      new ProductListingCredentials();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  GetContentProductsCredentials getContentProductsCredentials =
      new GetContentProductsCredentials();
  List<String> images = new List();
//  final List<String> images = [
//    'images/brand_ad1.jpeg',
//    'images/brand_ad2.jpeg',
//    'images/nirapara.jpg',

//  ];
  // List<Widget> cardSlide(){
  //   return categoryList
  //   .map((element) => ClipRRect(
  //     child: Image.network(imageBaseURL + element.image,
  //     fit: BoxFit.cover,),
  //     borderRadius: BorderRadius.circular(5),
  //   ) ).toList();
  // }

  @override
  void initState() {
    // _loadPinCode();
    // getCategory();
    setState(() {
      pinCode = widget.pinCode;
      // getBrandModel = widget.getBrandModel;
      // total = widget.total;
      print(brands?.length);
      level = widget.level;
      // getContentProductsCredentials = widget.getContentProductsCredentials;
    });
    fastMovingProducts();
    getBrand();
    // print(json.encode(getBrand));
    cardSliders = [];
    super.initState();

    DartNotificationCenter.subscribe(
        channel: "UPDATE_PIN_CODE",
        observer: this,
        onNotification: (result) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (mounted) {
            setState(() {
              pinCode = (prefs.getString('pinCode') ?? '');
            });
          }
        });
    DartNotificationCenter.subscribe(
        channel: 'LOGIN',
        observer: this,
        onNotification: (result) {
          if (mounted) {
            setState(() {
              _loadPinCode();
              cardSliders = [];
              // imageSliders = [];
              // homeAPI();
              fastMovingProducts();
            });
          }
        });
  }

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

  //Advertisement
  Future<FastMovingModel> advertismentClick() async {
    setState(() {
      isLoading = true;
    });

    var payload = {
      "categoryId": widget.categoryId,
      "subCategoryId": widget.subCategoryId,
      "advertisementId": widget.advertisementId,
      "type": widget.type
    };

    Result result = await _apiResponse.advertismentClick(payload);

    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      FastMovingModel fastMovingProductModel = (result).value;
      if (fastMovingProductModel.status == "success") {
        setState(() {
          subCategories = fastMovingProductModel.subCategories;
          categoryName = fastMovingProductModel.parentCategoryName;
          categoryId = fastMovingProductModel.parentCategoryId;
        });
      } else {
        showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      FastMovingModel unAuthoedUser = (result).value;
      showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

  Future<ProductsModel> getProducts(
      ProductListingCredentials productListingCredentials) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    setState(() {
      isLoading = true;
    });

    Result result =
        await _apiResponse.productListing(productListingCredentials);

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

  Future<FastMovingModel> fastMovingProducts() async {
    setState(() {
      isLoading = true;
    });

    var payload = {
      "categoryId": widget.categoryId,
      "pinCode": widget.pinCode,
      // "brandId": widget.brandId,
    };

    Result result = await _apiResponse.fastMovingProducts(payload);

    setState(() {
      isLoading = false;
      isPullDown = false;
    });
    _refreshController.refreshCompleted();
    if (result is SuccessState) {
      FastMovingModel fastMovingProductModel = (result).value;
      if (fastMovingProductModel.status == "success") {
        setState(() {
          subCategories = fastMovingProductModel.subCategories;
          categoryName = fastMovingProductModel.parentCategoryName;
          categoryId = fastMovingProductModel.parentCategoryId;

          //  adCardSlider = advertisements.advertisementCard.cast<String>();
          //     if (adCardSlider.length > 0) {
          //       setSliderView();
          //     }
        });
      } else {
        showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      FastMovingModel unAuthoedUser = (result).value;
      showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

  //brand images list
  Future<GetBrandModel> getBrand() async {
    setState(() {
      isLoading = true;
    });

    var payload = {
      "categoryId": widget.categoryId,
      "pinCode": widget.pinCode,
      "totalBrands": 30,
      "level": "-1",
    };

    Result result = await _apiResponse.getBrand(payload);

    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      GetBrandModel brandImageModel = (result).value;
      if (brandImageModel.status == "success") {
        setState(() {
          brands = brandImageModel.brands;
        });
      } else {
        showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      FastMovingModel unAuthoedUser = (result).value;
      showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

  //brand Selection
  Future<FilterResponseModel> productFilterSearchFilter(dynamic params) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    setState(() {
      isLoading = true;
    });

    Result result = await _apiResponse.productFilterSearchFilter(params);

    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      FilterResponseModel response = (result).value;
      if (response.status == "success") {
        setState(() {
          // categoryList = response.category;
          brandList = response.brand;
          print(brandList.length);
        });
      } else {
        showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      FilterResponseModel unAuthoedUser = (result).value;
      showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      showSnackBar("Failed, please try agian later");
    }
  }

  _loadPinCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pinCode = (prefs.getString('pinCode') ?? '');
    });

    if (pinCode != null && pinCode != ("null") && pinCode != ("")) {
      // homeAPI();
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) =>
              pinCodeDialog(message: "Please wait")).then((value) {
        setState(() {
          pinCode = value[0];
        });
        // homeAPI();
      });
    }
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

  void _onRefresh() async {
    // monitor network fetch
    isPullDown = true;
    // print("HOME");
    fastMovingProducts();

    // if failed,use refreshFailed()
  }

  Widget _uiSetup(BuildContext context) {
    var body = Container(
        color: Colors.white,
        child: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          header: MaterialClassicHeader(
            color: Colors.green,
          ),
          child: ListView.builder(
            //  scrollDirection: Axis.vertical,
            itemCount: 2,
            itemBuilder:
                //  (_, index) => _buildProducts(index),
                (_, i) {
              if (i == 0 && brands.length > 0)
                return _brandView(context);
              else if (i == 1)
                return _horizontalProductsListView(context);
              else {
                return Container();
              }
            },
          ),
        ));
    // TODO: implement build
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
            // Spacer(),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(categoryName,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            Container(
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Searchpage()));
                },
              ),
            ),
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
                  // homeAPI();
                });
              },
              child: Text(pinCode==null?"": pinCode != defaultPincode ? pinCode : "",
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

                    // homeAPI();
                  });
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: body,
          bottom: true,
        ),
        //  floatingActionButton: Padding(
        //    padding: const EdgeInsets.only(bottom: 40.0),
        //    child: RotatedBox(
        //        quarterTurns: 1,
        //      child: FloatingActionButton.extended(
        //          onPressed: () {
        //            _launchURL();
        //            // Add your onPressed code here!
        //            },

        //            label: const Text('Become an Affiliate'),
        //            icon: const Icon(Icons.thumb_up),
        //            backgroundColor: Colors.blue,

        //          ),
        //      ),
        //  ),
        //    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        key: _scaffoldkey);
  }

//   _launchURL() async {
//   const url = 'https://highrich.net';
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }

  setSliderView() {
    setState(() {
      cardSliders = adCardSlider
          .map((item) => Container(
              child: Image.network(imageBaseURL + item,
                  fit: BoxFit.fill, width: double.infinity)))
          .toList();
    });
  }

//Display snack bar
  void showSnackBar(String message) {
    final snackBarContent = SnackBar(
      // padding: EdgeInsets.only(bottom:16.0),
      content: Text(message),
      action: SnackBarAction(
          label: 'OK',
          onPressed: _scaffoldkey.currentState.hideCurrentSnackBar),
    );
    _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }

  Container _horizontalProductsListView(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 14.0),
      // height: 800,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        //  reverse: true,
        shrinkWrap: true,
        //  controller: _scrollController,
        itemCount: subCategories?.length,
        itemBuilder: (_, index) => _buildProducts(index),
      ),
    );
  }

  Container _brandView(BuildContext context) {
    // brands?.length > 0 ?
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: brands?.length,
          itemBuilder: (_, brandIndex) =>
              _brandViewScroll(brandIndex, brands, context)),
    );
    // :Container();
  }

  Widget _brandViewScroll(
          int brandIndex, List<ImageBrands> brands, BuildContext context) =>
      brands[brandIndex].source.image != null
          ? Container(
              width: 100,
              height: 60,
              child: GestureDetector(
                onTap: () async {
                  GetContentProductsCredentials getContentProductsCredentials =
                      new GetContentProductsCredentials();
                  ProductListingCredentials productListingCredentials =
                      new ProductListingCredentials();

                  productListingCredentials.offset = 0;
                  productListingCredentials.size = 30;
                  productListingCredentials.sortBy = "";
                  productListingCredentials.sortType = "";
                  productListingCredentials.hasRangeAndSort = false;
                  productListingCredentials.key = categoryName;

                  UserSearch search = new UserSearch();
                  search.key = categoryName;
                  search.pinCode = widget.pinCode;
                  productListingCredentials.userSearch = search;
                  productListingCredentials.forMobileApp = true;

                  FilterCredentials filterCredentials = new FilterCredentials();
                  TermCredentials termCredentials = TermCredentials();
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  final pinCode = preferences.getString("pinCode");
                  List<String> pincodeList = new List();
                  if (pinCode != null &&
                      pinCode != ("null") &&
                      pinCode != ("")) {
                    pincodeList.add(pinCode);
                    pincodeList.add("All India");
                    termCredentials.serviceLocations = pincodeList;
                  }

                  List<String> brandId = new List();
                  brandId.add(brands[brandIndex].source.brandId);
                  termCredentials.brandId = brandId;
                  OutOfStockProduct outOfStockGetContent =
                      new OutOfStockProduct();
                  outOfStockGetContent.gte = "1";
                  RangeFilter rangeFilterContent = new RangeFilter();
                  rangeFilterContent.outOfStock = outOfStockGetContent;
                  filterCredentials.term = termCredentials;
                  filterCredentials.range = rangeFilterContent;

                  productListingCredentials.filter = filterCredentials;

                  bool checkConnection =
                      await DataConnectionChecker().hasConnection;
                  if (checkConnection == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductListing(
                            apiName: "productListing",
                            getContentProductsCredentials:
                                getContentProductsCredentials,
                            productListingCredentials:
                                productListingCredentials,
                            categoryName: brands[brandIndex].source.brandName,
                            // subCategory0Id: subCategories[index].subCategory0Id,
                            brandId: brands[brandIndex].source.brandId,
                          ),
                        ));
                  } else {
                    _showAlert("No internet connection",
                        "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.");
                  }
                },
                child: CircleAvatar(
                  radius: 31,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: brands[brandIndex].source.image != null
                          ? NetworkImage(
                              imageBaseURL + brands[brandIndex].source.image)
                          : AssetImage("images/nirapara.jpg")),
                ),
              ),
            )
          : Container();

  Widget _buildProducts(int index) => subCategories[index]
              ?.sectionData
              ?.length >
          0
      ? Container(
          width: 90,
          // height: 750,
          color: Colors.grey[50],
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                children: [
                  subCategories[index]?.advertisements?.advertisementBanner !=
                          null
                      ?
                      //  GestureDetector(
                      //    onTap: () async {
                      //        GetContentProductsCredentials getContentProductsCredentials =
                      //         new GetContentProductsCredentials();
                      //           ProductListingCredentials productListingCredentials =
                      //               new ProductListingCredentials();

                      //           productListingCredentials.offset = 0;
                      //           productListingCredentials.size = 30;
                      //           productListingCredentials.sortBy = "";
                      //           productListingCredentials.sortType = "";
                      //           productListingCredentials.hasRangeAndSort = false;
                      //           productListingCredentials.key = subCategories[index].subCategory0Name;

                      //           UserSearch search = new UserSearch();
                      //           search.key = subCategories[index].subCategory0Name;
                      //           search.pinCode = widget.pinCode;
                      //           productListingCredentials.userSearch = search;
                      //           productListingCredentials.forMobileApp = true;

                      //           FilterCredentials filterCredentials =
                      //               new FilterCredentials();
                      //           TermCredentials termCredentials =
                      //               TermCredentials();
                      //           SharedPreferences preferences =
                      //               await SharedPreferences.getInstance();
                      //           final pinCode = preferences.getString("pinCode");
                      //           List<String> pincodeList = new List();
                      //           if (pinCode != null &&
                      //               pinCode != ("null") &&
                      //               pinCode != ("")) {
                      //             pincodeList.add(pinCode);
                      //             pincodeList.add("All India");
                      //             termCredentials.serviceLocations = pincodeList;
                      //           }
                      //           List<String> subCategory0Id = new List();
                      //           subCategory0Id.add(subCategories[index].subCategory0Id);

                      //           List<String> brandId = new List();
                      //           List<String> vendorId = new List();

                      //           if(subCategories[index]?.advertisements?.advertisementBanner[0].advertisementType == "BRANDS") {
                      //               brandId.add(subCategories[index]?.advertisements?.advertisementBanner[0].id);
                      //           } else if(subCategories[index]?.advertisements?.advertisementBanner[0].advertisementType == "STORES") {
                      //               vendorId.add(subCategories[index]?.advertisements?.advertisementBanner[0].id);
                      //           } else if(subCategories[index]?.advertisements?.advertisementBanner[0].advertisementType == "SELLERS") {
                      //               vendorId.add(subCategories[index]?.advertisements?.advertisementBanner[0].id);
                      //           }

                      //           termCredentials.subCategory0Id = subCategory0Id;
                      //           if(brandId.length > 0) {
                      //             termCredentials.brandId = brandId;
                      //           } else if(vendorId.length > 0) {
                      //             termCredentials.vendorId = vendorId;
                      //           }
                      //           OutOfStockProduct outOfStockGetContent=new OutOfStockProduct();
                      //           outOfStockGetContent.gte="1";
                      //           RangeFilter rangeFilterContent=new RangeFilter();
                      //           rangeFilterContent.outOfStock=outOfStockGetContent;
                      //           filterCredentials.term = termCredentials;
                      //           filterCredentials.range=rangeFilterContent;

                      //           productListingCredentials.filter = filterCredentials;

                      //           bool checkConnection =
                      //               await DataConnectionChecker().hasConnection;
                      //           if (checkConnection == true) {
                      //            if(brandId.length > 0) {
                      //              Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                 builder: (context) => ProductListing(
                      //                   apiName: "productListing",
                      //                   getContentProductsCredentials:
                      //                       getContentProductsCredentials,
                      //                   productListingCredentials: productListingCredentials,
                      //                   categoryName: subCategories[index].subCategory0Name,
                      //                   subCategory0Id: subCategories[index].subCategory0Id,
                      //                   brandId: subCategories[index]?.advertisements?.advertisementBanner[0].id,
                      //                 ),
                      //               ));
                      //            } else {

                      //              Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                 builder: (context) => ProductListing(
                      //                   apiName: "productListing",
                      //                   getContentProductsCredentials:
                      //                       getContentProductsCredentials,
                      //                   productListingCredentials: productListingCredentials,
                      //                   categoryName: subCategories[index].subCategory0Name,
                      //                   subCategory0Id: subCategories[index].subCategory0Id,
                      //                   vendorId: subCategories[index]?.advertisements?.advertisementBanner[0].id,
                      //                 ),
                      //               ));
                      //            }
                      //               //  print(advertisementCardList.length);
                      //           } else {
                      //             _showAlert("No internet connection",
                      //                 "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.");
                      //           }
                      //      },
                      //    child: Container(
                      //     width: MediaQuery.of(context).size.width,
                      //     height: MediaQuery.of(context).size.height / 5,
                      //             margin: EdgeInsets.all(6.0),
                      //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey[50],
                      //             image: DecorationImage(image:  NetworkImage(imageBaseURL + subCategories[index].advertisements?.advertisementBanner[0].images[0]), fit: BoxFit.cover)),
                      //             // child: Image.asset("images/brand_ad1.jpeg",fit: BoxFit.cover,),
                      //             ),
                      //  )
                      Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          child: CarouselSlider.builder(
                            itemCount: subCategories[index]
                                ?.advertisements
                                ?.advertisementBanner
                                ?.length,
                            // scrollDirection: Axis.horizontal,
                            options: CarouselOptions(
                              // height: 200.0,
                              // enlargeCenterPage: true,
                              autoPlay: true,
                              // aspectRatio: 16 / 9,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: subCategories[index]
                                          ?.advertisements
                                          ?.advertisementBanner
                                          ?.length >
                                      1
                                  ? true
                                  : false,
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              viewportFraction: 1.2,
                            ),
                            itemBuilder: (_, bannerIndex) {
                              return GestureDetector(
                                onTap: () async {
                                  GetContentProductsCredentials
                                      getContentProductsCredentials =
                                      new GetContentProductsCredentials();
                                  ProductListingCredentials
                                      productListingCredentials =
                                      new ProductListingCredentials();

                                  productListingCredentials.offset = 0;
                                  productListingCredentials.size = 30;
                                  productListingCredentials.sortBy = "";
                                  productListingCredentials.sortType = "";
                                  productListingCredentials.hasRangeAndSort =
                                      false;
                                  productListingCredentials.key =
                                      subCategories[index].subCategory0Name;

                                  UserSearch search = new UserSearch();
                                  search.key =
                                      subCategories[index].subCategory0Name;
                                  search.pinCode = widget.pinCode;
                                  productListingCredentials.userSearch = search;
                                  productListingCredentials.forMobileApp = true;

                                  FilterCredentials filterCredentials =
                                      new FilterCredentials();
                                  TermCredentials termCredentials =
                                      TermCredentials();
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  final pinCode =
                                      preferences.getString("pinCode");
                                  List<String> pincodeList = new List();
                                  if (pinCode != null &&
                                      pinCode != ("null") &&
                                      pinCode != ("")) {
                                    pincodeList.add(pinCode);
                                    pincodeList.add("All India");
                                    termCredentials.serviceLocations =
                                        pincodeList;
                                  }
                                  List<String> subCategory0Id = new List();
                                  subCategory0Id
                                      .add(subCategories[index].subCategory0Id);

                                  List<String> brandId = new List();
                                  List<String> vendorId = new List();

                                  if (subCategories[index]
                                          ?.advertisements
                                          ?.advertisementBanner[bannerIndex]
                                          .advertisementType ==
                                      "BRANDS") {
                                    brandId.add(subCategories[index]
                                        ?.advertisements
                                        ?.advertisementBanner[bannerIndex]
                                        .id);
                                  } else if (subCategories[index]
                                          ?.advertisements
                                          ?.advertisementBanner[bannerIndex]
                                          .advertisementType ==
                                      "STORES") {
                                    vendorId.add(subCategories[index]
                                        ?.advertisements
                                        ?.advertisementBanner[bannerIndex]
                                        .id);
                                  } else if (subCategories[index]
                                          ?.advertisements
                                          ?.advertisementBanner[bannerIndex]
                                          .advertisementType ==
                                      "SELLERS") {
                                    vendorId.add(subCategories[index]
                                        ?.advertisements
                                        ?.advertisementBanner[bannerIndex]
                                        .id);
                                  }

                                  termCredentials.subCategory0Id =
                                      subCategory0Id;
                                  if (brandId.length > 0) {
                                    termCredentials.brandId = brandId;
                                  } else if (vendorId.length > 0) {
                                    termCredentials.vendorId = vendorId;
                                  }
                                  OutOfStockProduct outOfStockGetContent =
                                      new OutOfStockProduct();
                                  outOfStockGetContent.gte = "1";
                                  RangeFilter rangeFilterContent =
                                      new RangeFilter();
                                  rangeFilterContent.outOfStock =
                                      outOfStockGetContent;
                                  filterCredentials.term = termCredentials;
                                  filterCredentials.range = rangeFilterContent;

                                  productListingCredentials.filter =
                                      filterCredentials;

                                  bool checkConnection =
                                      await DataConnectionChecker()
                                          .hasConnection;
                                  if (checkConnection == true) {
                                    if (brandId.length > 0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductListing(
                                              apiName: "productListing",
                                              getContentProductsCredentials:
                                                  getContentProductsCredentials,
                                              productListingCredentials:
                                                  productListingCredentials,
                                              categoryName: subCategories[index]
                                                  .subCategory0Name,
                                              subCategory0Id:
                                                  subCategories[index]
                                                      .subCategory0Id,
                                              brandId: subCategories[index]
                                                  ?.advertisements
                                                  ?.advertisementBanner[
                                                      bannerIndex]
                                                  .id,
                                            ),
                                          ));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductListing(
                                              apiName: "productListing",
                                              getContentProductsCredentials:
                                                  getContentProductsCredentials,
                                              productListingCredentials:
                                                  productListingCredentials,
                                              categoryName: subCategories[index]
                                                  .subCategory0Name,
                                              subCategory0Id:
                                                  subCategories[index]
                                                      .subCategory0Id,
                                              vendorId: subCategories[index]
                                                  ?.advertisements
                                                  ?.advertisementBanner[
                                                      bannerIndex]
                                                  .id,
                                            ),
                                          ));
                                    }
                                    //  print(advertisementCardList.length);
                                  } else {
                                    _showAlert("No internet connection",
                                        "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.");
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 1,
                                  margin: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey[50],
                                      image: DecorationImage(
                                          image: NetworkImage(imageBaseURL +
                                              subCategories[index]
                                                  ?.advertisements
                                                  ?.advertisementBanner[
                                                      bannerIndex]
                                                  .images[0]),
                                          fit: BoxFit.cover)),
                                  // child: Image.asset("images/brand_ad1.jpeg",fit: BoxFit.cover,),
                                ),
                              );
                            },
                            // }
                            // => _buildBoxCategory(cardIndex,context,subCategories[index]?.advertisements?.advertisementCard),
                          ),
                        )
                      // )
                      : Container(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 115,
                          child: Text(subCategories[index].subCategory0Name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700)),
                        ),
                        // Spacer(),
                        FlatButton(
                          // color: Colors.orange,
                          onPressed: () async {
                            print("*******SAMPLE********");
                            print(advertisements?.advertisementCard?.length);
                            // print(imageBaseURL + subCategories[index].advertisements.advertisementCard[index].images[0]);
                            GetContentProductsCredentials
                                getContentProductsCredentials =
                                new GetContentProductsCredentials();
                            ProductListingCredentials
                                productListingCredentials =
                                new ProductListingCredentials();

                            productListingCredentials.offset = 0;
                            productListingCredentials.size = 30;
                            productListingCredentials.sortBy = "";
                            productListingCredentials.sortType = "";
                            productListingCredentials.hasRangeAndSort = false;
                            productListingCredentials.key =
                                subCategories[index].subCategory0Name;

                            UserSearch search = new UserSearch();
                            search.key = subCategories[index].subCategory0Name;
                            search.pinCode = widget.pinCode;
                            productListingCredentials.userSearch = search;
                            productListingCredentials.forMobileApp = true;

                            FilterCredentials filterCredentials =
                                new FilterCredentials();
                            TermCredentials termCredentials = TermCredentials();
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            final pinCode = preferences.getString("pinCode");
                            List<String> pincodeList = new List();
                            if (pinCode != null &&
                                pinCode != ("null") &&
                                pinCode != ("")) {
                              pincodeList.add(pinCode);
                              pincodeList.add("All India");
                              termCredentials.serviceLocations = pincodeList;
                            }
                            List<String> subCategory0Id = new List();
                            subCategory0Id
                                .add(subCategories[index].subCategory0Id);
                            termCredentials.subCategory0Id = subCategory0Id;
                            OutOfStockProduct outOfStockGetContent =
                                new OutOfStockProduct();
                            outOfStockGetContent.gte = "1";
                            RangeFilter rangeFilterContent = new RangeFilter();
                            rangeFilterContent.outOfStock =
                                outOfStockGetContent;
                            filterCredentials.term = termCredentials;
                            filterCredentials.range = rangeFilterContent;

                            productListingCredentials.filter =
                                filterCredentials;

                            bool checkConnection =
                                await DataConnectionChecker().hasConnection;
                            if (checkConnection == true) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductListing(
                                      apiName: "productListing",
                                      getContentProductsCredentials:
                                          getContentProductsCredentials,
                                      productListingCredentials:
                                          productListingCredentials,
                                      categoryName:
                                          subCategories[index].subCategory0Name,
                                      subCategory0Id:
                                          subCategories[index].subCategory0Id,
                                    ),
                                  ));
                              //  print(advertisementCardList.length);
                            } else {
                              _showAlert("No internet connection",
                                  "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.");
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.blue[700],
                                borderRadius: BorderRadius.circular(2)),
                            child:
                                // Icon(Icons.arrow_forward, color: Colors.white,)
                                Text("View All",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    indent: 8,
                    endIndent: 8,
                  ),
                  subCategories[index]?.advertisements?.advertisementCard !=
                              null &&
                          subCategories[index]
                                  ?.advertisements
                                  ?.advertisementCard
                                  ?.length >
                              1
                      ? Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: CarouselSlider.builder(
                            itemCount: subCategories[index]
                                ?.advertisements
                                ?.advertisementCard
                                ?.length,
                            // scrollDirection: Axis.horizontal,
                            options: CarouselOptions(
                              height: 100.0,
                              enlargeCenterPage: subCategories[index]
                                          ?.advertisements
                                          ?.advertisementCard
                                          ?.length >
                                      2
                                  ? true
                                  : false,
                              autoPlay: subCategories[index]
                                          ?.advertisements
                                          ?.advertisementCard
                                          ?.length >
                                      1
                                  ? true
                                  : false,
                              // aspectRatio: 16 / 9,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: subCategories[index]
                                          ?.advertisements
                                          ?.advertisementCard
                                          ?.length >
                                      1
                                  ? true
                                  : false,
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              viewportFraction: 0.6,
                            ),
                            itemBuilder: (_, cardIndex) {
                              return GestureDetector(
                                onTap: () async {
                                  GetContentProductsCredentials
                                      getContentProductsCredentials =
                                      new GetContentProductsCredentials();
                                  ProductListingCredentials
                                      productListingCredentials =
                                      new ProductListingCredentials();

                                  productListingCredentials.offset = 0;
                                  productListingCredentials.size = 30;
                                  productListingCredentials.sortBy = "";
                                  productListingCredentials.sortType = "";
                                  productListingCredentials.hasRangeAndSort =
                                      false;
                                  productListingCredentials.key =
                                      subCategories[index].subCategory0Name;

                                  UserSearch search = new UserSearch();
                                  search.key =
                                      subCategories[index].subCategory0Name;
                                  search.pinCode = widget.pinCode;
                                  productListingCredentials.userSearch = search;
                                  productListingCredentials.forMobileApp = true;

                                  FilterCredentials filterCredentials =
                                      new FilterCredentials();
                                  TermCredentials termCredentials =
                                      TermCredentials();
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  final pinCode =
                                      preferences.getString("pinCode");
                                  List<String> pincodeList = new List();
                                  if (pinCode != null &&
                                      pinCode != ("null") &&
                                      pinCode != ("")) {
                                    pincodeList.add(pinCode);
                                    pincodeList.add("All India");
                                    termCredentials.serviceLocations =
                                        pincodeList;
                                  }
                                  List<String> subCategory0Id = new List();
                                  subCategory0Id
                                      .add(subCategories[index].subCategory0Id);

                                  List<String> brandId = new List();
                                  List<String> vendorId = new List();

                                  if (subCategories[index]
                                          ?.advertisements
                                          ?.advertisementCard[cardIndex]
                                          .advertisementType ==
                                      "BRANDS") {
                                    brandId.add(subCategories[index]
                                        ?.advertisements
                                        ?.advertisementCard[cardIndex]
                                        .id);
                                  } else if (subCategories[index]
                                          ?.advertisements
                                          ?.advertisementCard[cardIndex]
                                          .advertisementType ==
                                      "STORES") {
                                    vendorId.add(subCategories[index]
                                        ?.advertisements
                                        ?.advertisementCard[cardIndex]
                                        .id);
                                  } else if (subCategories[index]
                                          ?.advertisements
                                          ?.advertisementCard[cardIndex]
                                          .advertisementType ==
                                      "SELLERS") {
                                    vendorId.add(subCategories[index]
                                        ?.advertisements
                                        ?.advertisementCard[cardIndex]
                                        .id);
                                  }

                                  termCredentials.subCategory0Id =
                                      subCategory0Id;
                                  if (brandId.length > 0) {
                                    termCredentials.brandId = brandId;
                                  } else if (vendorId.length > 0) {
                                    termCredentials.vendorId = vendorId;
                                  }
                                  OutOfStockProduct outOfStockGetContent =
                                      new OutOfStockProduct();
                                  outOfStockGetContent.gte = "1";
                                  RangeFilter rangeFilterContent =
                                      new RangeFilter();
                                  rangeFilterContent.outOfStock =
                                      outOfStockGetContent;
                                  filterCredentials.term = termCredentials;
                                  filterCredentials.range = rangeFilterContent;

                                  productListingCredentials.filter =
                                      filterCredentials;

                                  bool checkConnection =
                                      await DataConnectionChecker()
                                          .hasConnection;
                                  if (checkConnection == true) {
                                    if (brandId.length > 0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductListing(
                                              apiName: "productListing",
                                              getContentProductsCredentials:
                                                  getContentProductsCredentials,
                                              productListingCredentials:
                                                  productListingCredentials,
                                              categoryName: subCategories[index]
                                                  .subCategory0Name,
                                              subCategory0Id:
                                                  subCategories[index]
                                                      .subCategory0Id,
                                              brandId: subCategories[index]
                                                  ?.advertisements
                                                  ?.advertisementCard[cardIndex]
                                                  .id,
                                            ),
                                          ));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductListing(
                                              apiName: "productListing",
                                              getContentProductsCredentials:
                                                  getContentProductsCredentials,
                                              productListingCredentials:
                                                  productListingCredentials,
                                              categoryName: subCategories[index]
                                                  .subCategory0Name,
                                              subCategory0Id:
                                                  subCategories[index]
                                                      .subCategory0Id,
                                              vendorId: subCategories[index]
                                                  ?.advertisements
                                                  ?.advertisementCard[cardIndex]
                                                  .id,
                                            ),
                                          ));
                                    }
                                    //  print(advertisementCardList.length);
                                  } else {
                                    _showAlert("No internet connection",
                                        "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.");
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 1,
                                  margin: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[50],
                                      image: DecorationImage(
                                          image: NetworkImage(imageBaseURL +
                                              subCategories[index]
                                                  ?.advertisements
                                                  ?.advertisementCard[cardIndex]
                                                  .images[0]),
                                          fit: BoxFit.cover)),
                                  // child: Image.asset("images/brand_ad1.jpeg",fit: BoxFit.cover,),
                                ),
                              );
                            },
                            // }
                            // => _buildBoxCategory(cardIndex,context,subCategories[index]?.advertisements?.advertisementCard),
                          ),
                        )
                      : Container(),
                  SizedBox(height: 5),
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: subCategories[index]?.sectionData?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, itemIndex) => _buildBox(
                          itemIndex, context, subCategories[index].sectionData),
                    ),
                  ),
                  SizedBox(height: 5),
                  // Divider(color: Colors.grey,indent: 10,endIndent: 10,)
                  // Container(height: 20,color: Colors.grey[100],)
                ],
              )),
        )
      : Container();
}

Container _buildBox(int itemIndex, BuildContext context,
        List<SectionDataFast> productSectionModelHome) =>
    Container(
      margin: EdgeInsets.only(top: 12, left: 4),
      height: 180,
      width: 175,
      child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey[300], width: 0),
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 1,
          child: new InkWell(
            onTap: () async {
              bool checkConnection =
                  await DataConnectionChecker().hasConnection;
              if (checkConnection == true) {
                if (productSectionModelHome[itemIndex]?.source != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Product_Detail_Page(
                          product_id: productSectionModelHome[itemIndex]
                              ?.source
                              ?.productId,
                        ),
                      ));
                }
              } else {
                Fluttertoast.showToast(msg: "No internet connection");
              }
            },
            child: Column(
              children: [
                productSectionModelHome[itemIndex]
                            .source
                            .processedPriceAndStock
                            .length >
                        0
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8, top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 58,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        bottomLeft: Radius.circular(4)),
                                    color: Colors.red[700],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: productSectionModelHome[itemIndex]
                                                  .source
                                                  .processedPriceAndStock
                                                  .length >
                                              0
                                          ? Text(
                                              productSectionModelHome[itemIndex]
                                                      .source
                                                      ?.processedPriceAndStock[
                                                          0]
                                                      ?.discount
                                                      .round()
                                                      // .toStringAsFixed(2)
                                                      .toString() +
                                                  '% OFF',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0),
                                            )
                                          : Text(""),
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
                      )
                    : Container(),
                SizedBox(
                  height: 3,
                ),
                Container(
                  width: 130,
                  height: 120,
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: CachedNetworkImage(
                      imageUrl: (imageBaseURL +
                          productSectionModelHome[itemIndex].source.images[0]),
                      placeholder: (context, url) => Center(
                          child: new Text(
                        "LOADING...",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w800),
                      )),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6, right: 4),
                    child: Text(
                      productSectionModelHome[itemIndex].source.name,
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: Row(
                    children: [
                      productSectionModelHome[itemIndex]
                                  .source
                                  .processedPriceAndStock
                                  .length >
                              0
                          ? Text(
                              '₹ ' +
                                  productSectionModelHome[itemIndex]
                                      .source
                                      ?.processedPriceAndStock[0]
                                      ?.sellingPrice
                                      .toStringAsFixed(2)
                                      .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent,
                                fontSize: 15.0,
                              ),
                            )
                          : Text(""),
                      Spacer(),
                      productSectionModelHome[itemIndex]
                                  .source
                                  .processedPriceAndStock
                                  .length >
                              0
                          ? Text(
                              '₹ ' +
                                  productSectionModelHome[itemIndex]
                                      .source
                                      ?.processedPriceAndStock[0]
                                      ?.price
                                      .toStringAsFixed(2)
                                      .toString(),
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.grey.shade500,
                              ),
                            )
                          : Text(""),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: Row(
                    children: [
                      productSectionModelHome[itemIndex]
                                  .source
                                  .processedPriceAndStock
                                  .length >
                              0
                          ? Text(
                              productSectionModelHome[itemIndex]
                                          .source
                                          .processedPriceAndStock
                                          .length >
                                      0
                                  ? productSectionModelHome[itemIndex]
                                              .source
                                              ?.processedPriceAndStock[0]
                                              ?.unit
                                              .length >
                                          2
                                      ? productSectionModelHome[itemIndex]
                                              .source
                                              ?.processedPriceAndStock[0]
                                              ?.quantity +
                                          " " +
                                          productSectionModelHome[itemIndex]
                                              .source
                                              ?.processedPriceAndStock[0]
                                              ?.unit
                                      // .substring(0, 3)
                                      : productSectionModelHome[itemIndex]
                                              .source
                                              ?.processedPriceAndStock[0]
                                              ?.quantity +
                                          " " +
                                          productSectionModelHome[itemIndex]
                                              .source
                                              ?.processedPriceAndStock[0]
                                              ?.unit
                                  : Text(""),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  fontSize: 12.0),
                              maxLines: 1,
                            )
                          : Text(""),
                      Spacer(),
                      // productSectionModelHome[itemIndex]
                      //             .source
                      //             .processedPriceAndStock
                      //             .length >
                      //         0
                      //     ? Container(
                      //         width: 80,
                      //         height: 30,
                      //         child: Stack(
                      //           children: [
                      //             // SvgPicture.asset(
                      //             //   'images/OfferBg.svg',
                      //             //   height: 30,
                      //             // ),
                      //             Align(
                      //               alignment: Alignment.centerRight,
                      //               child: productSectionModelHome[itemIndex]
                      //                           .source
                      //                           .processedPriceAndStock
                      //                           .length >
                      //                       0
                      //                   ? Text(
                      //                       productSectionModelHome[itemIndex]
                      //                               .source
                      //                               ?.processedPriceAndStock[0]
                      //                               ?.discount
                      //                               .toStringAsFixed(2)
                      //                               .toString() +
                      //                           ' % off',
                      //                       style: TextStyle(
                      //                           color: Colors.green,
                      //                           fontWeight: FontWeight.bold,
                      //                           fontSize: 12.0),
                      //                     )
                      //                   : Text(""),
                      //             )
                      //           ],
                      //         ),
                      //       )
                      //     : Container(),

                      // IconButton(icon: Icon(Icons.shopping_cart_outlined,color: Colors.deepOrangeAccent,), onPressed: null)
                    ],
                  ),
                ),
                if (AppConfig.isAuthorized)
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    child: productSectionModelHome[itemIndex]
                                .source
                                .processedPriceAndStock
                                .length >
                            0
                        ? Row(
                            children: [
                              Text(
                                "SI:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                    fontSize: 14.0),
                                maxLines: 1,
                              ),
                              Spacer(),
                              Text(
                                productSectionModelHome[itemIndex]
                                    .source
                                    ?.processedPriceAndStock[0]
                                    ?.salesIncentive
                                    .toStringAsFixed(2)
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                    fontSize: 14.0),
                              )
                            ],
                          )
                        : Container(),
                  ),
                SizedBox(
                  height: 5,
                ),
                //  Padding(
                //    padding: const EdgeInsets.all(8.0),
                //    child: Container(
                //      child: ElevatedButton(
                //        style: ElevatedButton.styleFrom(
                //          minimumSize: Size(double.infinity, 30), // double.infinity is the width and 30 is the height
                //        ),
                //         onPressed: () {
                //           _moveToCart(itemIndex);
                //         },
                //         child: Text('ADD TO CART'),
                // ),
                //    ),
                //  ),
              ],
            ),
          )),
    );
