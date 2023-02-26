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
import 'package:highrich/model/HomeModel/home_category.dart';
import 'package:highrich/model/HomeModel/home_products_model.dart';
import 'package:highrich/model/HomeModel/home_products_section_model.dart';
import 'package:highrich/model/fast_moving_model.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:highrich/model/category_model.dart';
import 'package:highrich/Network/result.dart';

import '../progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;

  HomePage(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hideNavBar;
  int _current = 0;
  String pinCode = "";
  int bannerPostion = 0;
  double boxHeight = 80;
  bool isLoading = false;
  bool isPullDown = false;
  String _home = 'home';
  List<Widget> imageSliders;
  List<Widget> bannerSliders;
  int popularCategoryPosition = 0;
  HomeBannerModel bannerSectiondata;
  List<HomeBannerModel> bannerSectiondataList = new List();
  HomeCateogryModel homeCateogryModel;
  HomeProductsModel homeProductsModel;
  PersistentTabController _controller;
  String CHANNEL_NAME = "cartCount_event";
  List<HomeBannerModel> homeBannerList = new List();
  RemoteDataSource _apiResponse = RemoteDataSource();
  HomeProductsSectionsModel homeProductsSectionsModel;
  List<SectionDataProducts> productSectionModelHome;
  List<HomeProductsSectionsModel> homeProductsSectionsList = new List();
  List<SubCategoryLevelMinusOne> categoryList = new List();
  List<SubCategory> subCategories = new List();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _loadPinCode();
    getCategory();
    _onRefresh();
    imageSliders = [];
    bannerSliders = [];
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
              imageSliders = [];
              bannerSliders = [];
              homeAPI();
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

  _loadPinCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pinCode = (prefs.getString('pinCode') ?? '');
    });

    if (pinCode != null && pinCode != ("null") && pinCode != ("")) {
      homeAPI();
    } else {
      /*showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) =>
              pinCodeDialog(message: "Please wait")).then((value) {
        setState(() {
          pinCode = value[0];
        });
        homeAPI();
      });*/
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
    print("HOME");
    print(bannerSectiondata);
    homeAPI();
    print("---------------------------------------");
    print(homeProductsSectionsList);
    print("---------------------------------------");

    // if failed,use refreshFailed()
  }

  Widget _uiSetup(BuildContext context) {
    var body = new Container(
        color: gray_bg,
        child: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          header: MaterialClassicHeader(
            color: Colors.deepOrange,
          ),
          child: ListView.builder(
            itemCount: 6,
            itemBuilder: (_, i) {
              if (i == 0)
                return _typeView(context);
              else if (i == 1)
                return _imageSlider();
              // else if (i == 2)
              //   return   _horizontalCategoryListView(context);
              // else if (i ==2)
              // return _categoryBannerView(context);
              else if (i == 2)
                return _horizontalProductsListView(context);
              else if (i == 3)
                return footerView(context);
              else if (i == 4)
                return Container(
                    //height:30,
                    );
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
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(6),
                child: SvgPicture.asset("images/logo_highrich.svg"),
              ),
            ),
            Spacer(),
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
                  homeAPI();
                });
              },
              child: Text(pinCode != defaultPincode ? pinCode : "",
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

                    homeAPI();
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
      imageSliders = bannerSectiondata?.sectionData
          .map((item) => Container(
              child: Image.network(imageBaseURL + item?.image,
                  fit: BoxFit.fill, width: double.infinity)))
          .toList();
    });
  }

  setBannerView() {
    setState(() {
      bannerSliders = bannerSectiondata?.sectionData
          .map((item) => Container(
              child: Image.network(imageBaseURL + item?.image,
                  fit: BoxFit.fill, width: double.infinity)))
          .toList();
    });
  }

  Future homeAPI() async {
    setState(() {
      homeProductsSectionsList.clear();
      bannerSectiondataList.clear();
    });

    bool checkConnection = await DataConnectionChecker().hasConnection;
    if (checkConnection == true) {
      if (isPullDown == false) {
        setState(() {
          isLoading = true;
        });
      }
      final response = await http.post(
        Uri.parse(baseURL + _home),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
//        'username':modelSignIn.email,
//        'password':modelSignIn.password

          'pinCode': pinCode,
        }),
      );
      print("PINCODE====" + pinCode);
      print(response.statusCode);
      if (response.statusCode == 200) {
        DartNotificationCenter.post(
          channel: "cartCount_event",
          options: "getCart",
        );
        print("HOME RESPONSE");
        print(response.body);
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final extractedData = json.decode(response.body);
        if (extractedData['status'] == 'success') {
          List reponseHome = extractedData['sections'];
          List<HomeBannerModel> bannerSectionList = new List();
          if (reponseHome.length > 0) {
            setState(() {
              isLoading = false;
              isPullDown = false;
            });
            _refreshController.refreshCompleted();
            for (int i = 0; i < reponseHome.length; i++) {
              var all = reponseHome[i];
              String sectionTitle = all["sectionType"];
              int sectionOrder = all["sectionOrder"];
              // For displaying top banner in hompage
              if (sectionTitle == "BANNER" && sectionOrder == 0) {
                print(reponseHome);
                bannerPostion = i;
                var banner = reponseHome[i];
                bannerSectiondata = HomeBannerModel.fromJson(banner);
                setSliderView();
              }
              //  else if(sectionTitle == "BANNER" && sectionOrder != 0) {
              //     print(reponseHome);
              //     bannerPostion = i;
              //     var banner = reponseHome[i];
              //     bannerSectiondata = HomeBannerModel.fromJson(banner);
              //     setBannerView();

              // }
              // For displaying top categories in hompage
              // else if (sectionTitle == "POPULAR_CATEGORY") {
              //   popularCategoryPosition = i;
              //   var topCategory = reponseHome[i];
              //   setState(() {
              //     homeCateogryModel = HomeCateogryModel.fromJson(topCategory);
              //   });
              // }
            }

            //Data receving for product section in home page
            List responseProducts = extractedData['sections'];

            // Removing banner and popular categories from list to list out products
            responseProducts.removeAt(bannerPostion);
            // responseProducts.removeAt(popularCategoryPosition - 1);

            List<HomeProductsSectionsModel> homeProductsSectionsTempList =
                new List();
            for (int g = 0; g < responseProducts.length; g++) {
              var products = responseProducts[g];
              homeProductsSectionsModel =
                  HomeProductsSectionsModel.fromJson(products);
              homeProductsSectionsTempList.add(homeProductsSectionsModel);
            }

            setState(() {
              homeProductsSectionsList = homeProductsSectionsTempList;
              isLoading = false;
            });

            setState(() {
              bannerSectiondataList = bannerSectionList;
              isLoading = false;
            });
          } else {
            //showInSnackBar("Please check emailID and password.");
            setState(() {
              isLoading = false;
            });
          }
        } else {
          // showInSnackBar("Sorry please try after sometime.");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        // If the server did not return a 200 OK response,
        // then throw an exception.
        //showInSnackBar("Please check network connection.");
        throw Exception('Failed to load user');
      }
    } else {
      setState(() {
        isLoading = false;
        isPullDown = false;
      });
      isPullDown = false;
      print('No internet :( Reason:');
      _showAlert("No internet connection",
          "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.");
      print(DataConnectionChecker().lastTryResults);
    }
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

  Widget _typeView(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length,
        itemBuilder: (_, index) => _buildBoxCategory(index),
      ),
    );
  }

  //Banner image slider
  Container _imageSlider() {
    return bannerSectiondata != null
        ? Container(
            color: Colors.white,
            child: Column(
              children: [
                ClipRRect(
                  child: Container(
                    child: CarouselSlider(
                      items: imageSliders,
                      options: CarouselOptions(
                          autoPlay: imageSliders.length > 1 ? true : false,
                          aspectRatio: 3,
                          autoPlayInterval: Duration(seconds: 10),
                          viewportFraction: 1,
                          // enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          }),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: bannerSectiondata?.sectionData?.map((url) {
                    int index = bannerSectiondata?.sectionData?.indexOf(url);
                    return imageSliders.length > 1
                        ? Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? Colors.deepOrange
                                  : Color(0xFFFFCC80),
                            ),
                          )
                        : Container(
                            width: 8.0,
                            height: 8.0,
                          );
                  }).toList(),
                ),
              ],
            ),
          )
        : Container();
  }

  //Categories in home page
  Widget _horizontalCategoryListView(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryList?.length,
        itemBuilder: (_, index) => _buildBoxCategory(index),
      ),
    );
  }

  //Product listing
  ListView _horizontalProductsListView(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // scrollDirection: Axis.vertical,
        itemCount: homeProductsSectionsList?.length,
        itemBuilder: (_, index) =>
            homeProductsSectionsList[index]?.sectionData?.isNotEmpty
                ? _buildProducts(index)
                : Container());
  }

  // Banner View
  // Container _categoryBannerView(BuildContext context) {
  //   return Container(
  //     color: Colors.white,
  //     margin: EdgeInsets.only(top: 14.0),
  //     height: MediaQuery.of(context).size.height/5,
  //     width: MediaQuery.of(context).size.width,
  //     child: ListView.builder(
  //       physics: const NeverScrollableScrollPhysics(),
  //       // scrollDirection: Axis.vertical,
  //       itemCount: bannerSectiondata.sectionData.length,
  //       itemBuilder: (_, index) =>  _buildBanner(index)

  //     ),
  //   );
  // }

  Widget footerView(BuildContext context) => Container(
        color: Colors.indigo[900],
        width: MediaQuery.of(context).size.width,
        // height: 100,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "CONTACT US",
                    style: TextStyle(
                        color: Colors.white60, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Headoffice:",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 28, top: 2),
                        child: Text(
                          "Highrich Online Shoppe Pvt. Ltd.",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 28, top: 5),
                        child: Text(
                          "Capital Art Businesses Spaces,",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 28, top: 5),
                        child: Text(
                          "Neruvissery, Arattupuzha P.O",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 28, top: 5),
                        child: Text(
                          "Thrissur, Kerala - 680562",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 28, top: 5),
                        child: Text(
                          "Phone : +91 9744338134",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 28, top: 5),
                        child: Text(
                          "Mail : info@highrich.in",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "For Queries / Suggestions/ Complaints:",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 28),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Malayalam:",
                                style: (TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white)),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "+91 9544500023",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "+91 9544500025",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "+91 9544500024",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Hindi / English:",
                                style: (TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "+91 7559900081",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "+91 9744338134",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "+91 9744338138",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          )),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "For Enquires - Franchise:",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 28),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "+91 7356183049",
                                style: (TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white)),
                              ),
                            ],
                          )),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 300,
                            height: 40,
                            child: Text(
                              "For Smart Rich Queries (National & International)- Franchise:",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 28),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chief Operating Officer (COO) : +91 6238014065",
                                style: (TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white)),
                              ),
                            ],
                          )),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 300,
                            height: 40,
                            child: Text(
                              "For Queries / Suggestions / Complaints (Multi Vendor / Sellers):",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 28),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "+91 95445 00096, +91 8137000844",
                                style: (TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white)),
                              ),
                            ],
                          )),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              indent: 10,
              thickness: 1,
              endIndent: 10,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star_outline_rounded,
                        color: Colors.yellow[600],
                      ),
                      TextButton(
                        child: Text(
                          "Join Affiliate Program",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        onPressed: () async {
                          launch("https://www.highrich.net/front_login_only");
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.store,
                        color: Colors.yellow[600],
                      ),
                      TextButton(
                        child: Text(
                          "Own an Agency",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        onPressed: () async {
                          launch("https://agency.highrich.in/");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        color: Colors.yellow[600],
                      ),
                      TextButton(
                        child: Text(
                          "Own a Hub",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        onPressed: () async {
                          launch("https://hub.highrich.in/");
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.sell_sharp,
                        color: Colors.yellow[600],
                      ),
                      TextButton(
                        child: Text(
                          "Sell on Highrich",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        onPressed: () async {
                          launch("https://seller.highrich.in/");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildBanner(int index) =>
      homeProductsSectionsList[index]?.sectionType != "BANNER"
          ? Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 115,
                    child: Text(homeProductsSectionsList[index]?.sectionTitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w700)),
                  ),
                  ClipRRect(
                    child: Container(
                      child: CarouselSlider(
                        items:
                            //  bannerSliders,
                            [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            // child: Image.asset("images/brand_ad1.jpeg",fit: BoxFit.cover,),
                            margin: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[50],
                                image: DecorationImage(
                                    image: NetworkImage(imageBaseURL +
                                        bannerSectiondata
                                            ?.sectionData[index]?.image),
                                    fit: BoxFit.cover)),
                          ),
                          // ),
                        ],
                        options: CarouselOptions(
                            autoPlay: imageSliders.length > 2 ? true : false,
                            aspectRatio: 3,
                            autoPlayInterval: Duration(seconds: 10),
                            viewportFraction: 1,
                            // enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                      ),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: bannerSectiondata.sectionData.map((url) {
                  //     int index = bannerSectiondata?.sectionData?.indexOf(url);
                  //     return imageSliders.length > 1
                  //         ? Container(
                  //             width: 8.0,
                  //             height: 8.0,
                  //             margin: EdgeInsets.symmetric(
                  //                 vertical: 10.0, horizontal: 2.0),
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: _current == index
                  //                   ? Colors.deepOrange
                  //                   : Color(0xFFFFCC80),
                  //             ),
                  //           )
                  //         : Container(
                  //             width: 8.0,
                  //             height: 8.0,
                  //           );
                  //   }).toList(),
                  // ),
                ],
              ),
            )
          : Container();

  Widget _buildProducts(int index) => homeProductsSectionsList[index]
                  ?.sectionType ==
              "CATEGORY" ||
          homeProductsSectionsList[index]?.sectionType == "STORE" &&
              homeProductsSectionsList[index]?.sectionType != "POPULAR_CATEGORY"
      ? Container(
          width: 90,
          // height: 600,
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 14.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 115,
                        child: Text(
                            homeProductsSectionsList[index]?.sectionTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w700)),
                      ),
                      Spacer(),
                      FlatButton(
                          // color: Colors.green,
                          onPressed: () async {
                            ProductListingCredentials
                                productListingCredentials =
                                new ProductListingCredentials();
                            GetContentProductsCredentials
                                getContentProductsCredentials =
                                new GetContentProductsCredentials();
                            getContentProductsCredentials.sectionId =
                                homeProductsSectionsList[index]?.sectionId;
                            getContentProductsCredentials.offset = 0;
                            getContentProductsCredentials.size = 20;
                            getContentProductsCredentials.type = "section";
                            getContentProductsCredentials.sortBy = "price";
                            getContentProductsCredentials.sortType = "asc";

                            FilterCredentialsContent filterCredentials =
                                new FilterCredentialsContent();
                            TermCredentialsContent termCredentials =
                                TermCredentialsContent();
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
                            OutOfStockGetContent outOfStockGetContent =
                                new OutOfStockGetContent();
                            outOfStockGetContent.gte = "1";
                            RangeFilterContent rangeFilterContent =
                                new RangeFilterContent();
                            rangeFilterContent.outOfStock =
                                outOfStockGetContent;
                            filterCredentials.term = termCredentials;
                            filterCredentials.range = rangeFilterContent;
                            getContentProductsCredentials.filter =
                                filterCredentials;
                            bool checkConnection =
                                await DataConnectionChecker().hasConnection;
                            if (checkConnection == true) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductListing(
                                      apiName: "getContentProducts",
                                      getContentProductsCredentials:
                                          getContentProductsCredentials,
                                      productListingCredentials:
                                          productListingCredentials,
                                      categoryName:
                                          homeProductsSectionsList[index]
                                              ?.sectionTitle,
                                    ),
                                  ));
                            } else {
                              _showAlert("No internet connection",
                                  "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.");
                            }
                          },
                          child: Text("View All",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount:
                          homeProductsSectionsList[index]?.sectionData?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, itemIndex) => _buildBox(itemIndex,
                          context, homeProductsSectionsList[index].sectionData),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              )),
        )
      : Container();
  // Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 height: MediaQuery.of(context).size.height / 5,
  //                 child: Image.asset("images/brand_ad1.jpeg",fit: BoxFit.cover,),
  //                 margin: EdgeInsets.all(6.0),
  //                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey[50],
  //                 // image: DecorationImage(image:  NetworkImage(imageBaseURL + subCategories[index]?.advertisements?.advertisementCard[cardIndex].images[0]), fit: BoxFit.cover)),

  //                 ),
  //           );
  // homeProductsSectionsList[index]?.sectionType !=  "POPULAR_CATEGORY" ?
  //  Container(
  //       color: Colors.white,
  //       child: Column(
  //         children: [
  //           Container(
  //                 width: MediaQuery.of(context).size.width - 115,
  //                 child: Text(homeProductsSectionsList[index]?.sectionTitle,
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 2,
  //                     style: TextStyle(
  //                         fontSize: 16.0,
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.w700)),
  //               ),
  //           ClipRRect(
  //             child: Container(
  //               child: CarouselSlider(
  //                 items:
  //                 //  bannerSliders,
  //                  [

  //                 Container(
  //               width: MediaQuery.of(context).size.width,
  //               height: MediaQuery.of(context).size.height / 5,
  //               // child: Image.asset("images/brand_ad1.jpeg",fit: BoxFit.cover,),
  //                       margin: EdgeInsets.all(6.0),
  //                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey[50],
  //                       image: DecorationImage(image:  NetworkImage(imageBaseURL +
  //                       bannerSectiondata?.sectionData[3]?.image
  //                       ), fit: BoxFit.cover)),

  //                       ) ,
  //                 // ),
  //                 ],
  //                 options: CarouselOptions(
  //                     autoPlay: imageSliders.length > 2 ? true : false,
  //                     aspectRatio: 3,
  //                     autoPlayInterval: Duration(seconds: 10),
  //                     viewportFraction: 1,
  //                     // enlargeCenterPage: true,
  //                     onPageChanged: (index, reason) {
  //                       setState(() {
  //                         _current = index;
  //                       });
  //                     }),
  //               ),
  //             ),
  //           ),
  //           // Row(
  //           //   mainAxisAlignment: MainAxisAlignment.center,
  //           //   children: bannerSectiondata.sectionData.map((url) {
  //           //     int index = bannerSectiondata?.sectionData?.indexOf(url);
  //           //     return imageSliders.length > 1
  //           //         ? Container(
  //           //             width: 8.0,
  //           //             height: 8.0,
  //           //             margin: EdgeInsets.symmetric(
  //           //                 vertical: 10.0, horizontal: 2.0),
  //           //             decoration: BoxDecoration(
  //           //               shape: BoxShape.circle,
  //           //               color: _current == index
  //           //                   ? Colors.deepOrange
  //           //                   : Color(0xFFFFCC80),
  //           //             ),
  //           //           )
  //           //         : Container(
  //           //             width: 8.0,
  //           //             height: 8.0,
  //           //           );
  //           //   }).toList(),
  //           // ),
  //         ],
  //       ),
  //     ) : Container();

  Widget _buildBoxCategory(int index) => Container(
        width: 90,
        height: 270,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: new GestureDetector(
            onTap: () async {
              bool checkConnection =
                  await DataConnectionChecker().hasConnection;
              if (checkConnection == true) {
                List<String> pincodeList = new List();

                GetContentProductsCredentials getContentProductsCredentials =
                    new GetContentProductsCredentials();
                ProductListingCredentials productListingCredentials =
                    new ProductListingCredentials();
                productListingCredentials.key =
                    categoryList[index].categoryName;
                productListingCredentials.offset = 0;
                productListingCredentials.size = 20;
                productListingCredentials.sortBy = "price";
                productListingCredentials.sortType = "asc";
                productListingCredentials.hasRangeAndSort = false;
                productListingCredentials.forMobileApp = true;
                List<String> categoryIdList = new List();
                categoryIdList.add(categoryList[index].id);
                FilterCredentials filterCredentials = new FilterCredentials();
                TermCredentials term = new TermCredentials();

                term.categoryId = categoryIdList;
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                final pinCode = preferences.getString("pinCode");
                if (pinCode != null && pinCode != ("null") && pinCode != ("")) {
                  pincodeList.add(pinCode);
                  pincodeList.add("All India");
                  term.serviceLocations = pincodeList;
                }

                RangeFilter rangeFilter = new RangeFilter();

                OutOfStockProduct outOfStockProduct = new OutOfStockProduct();
                outOfStockProduct.gte = "1";
                rangeFilter.outOfStock = outOfStockProduct;
                filterCredentials.term = term;
                filterCredentials.range = rangeFilter;
                productListingCredentials.filter = filterCredentials;

                if (categoryList[index].id != null ||
                    categoryList[index].id != "" ||
                    categoryList[index].id != ("null")) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FastMoving(
                          categoryId: categoryList[index].id,
                          pinCode: pinCode,
                        ),
                        //  ProductListing(
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
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: categoryList[index].image != null
                              ? NetworkImage(
                                  imageBaseURL + categoryList[index].image)
                              : NetworkImage(""),
                          fit: BoxFit.contain),
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
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    categoryList[index].categoryName != null
                        ? categoryList[index].categoryName
                        : "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}

Container _buildBox(int itemIndex, BuildContext context,
        List<SectionDataProducts> productSectionModelHome) =>
    Container(
      margin: EdgeInsets.only(top: 12, left: 4),
      height: 180,
      width: 165,
      child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey[300], width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          // elevation: 1.0,
          child: new InkWell(
            onTap: () async {
              bool checkConnection =
                  await DataConnectionChecker().hasConnection;
              if (checkConnection == true) {
                if (productSectionModelHome[itemIndex].source != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Product_Detail_Page(
                          product_id: productSectionModelHome[itemIndex]
                              .source
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
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Center(
                                      // alignment: Alignment.centerLeft,
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
              ],
            ),
          )),
    );
