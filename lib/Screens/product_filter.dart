import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:highrich/APICredentials/ProductAPI.dart';
import 'package:highrich/APICredentials/ProductListing/getContentProductsCredentials.dart';
import 'package:highrich/APICredentials/ProductListing/productlistingcredentials.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/progress_hud.dart';
import 'package:highrich/Screens/search.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/model/MyReturns/my_returns.dart';
import 'package:highrich/model/category_model.dart';
import 'package:highrich/model/filter_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
/*
 *  2021 Highrich.in
 */
class ProductFilterPage extends StatefulWidget {
  String apiName;
  String categoryName;
  String categoryId;
  String subCategory0Id;
  String subCategory1Id;
  String subCategory2Id;
  String subCategory3Id;

  ProductListingCredentials productListingCredentials;
  GetContentProductsCredentials getContentProductsCredentials;
  var filterPageParms;
  var filterPageParmsContent;

  ProductFilterPage(
      {this.apiName,
      this.productListingCredentials,
      this.categoryName,
      this.filterPageParms,
      this.getContentProductsCredentials,
      this.filterPageParmsContent,
      this.categoryId,
      this.subCategory0Id,
      this.subCategory1Id,
      this.subCategory2Id,
      this.subCategory3Id});

  @override
  _ProductFilterState createState() => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilterPage> {
  String apiName;
  bool priceFilter;
  String categoryId;
  String maxPrice = "";
  String minPrice = "";
  String categoryName;
  String subCategory0Id;
  String subCategory1Id;
  String subCategory2Id;
  String subCategory3Id;
  int brandListSize = 0;
  List<bool> _isChecked;
  bool isLoading = false;
  bool _priceValidate = false;
  bool isFromFilterPage = true;
  bool isPriceValidation = false;
  List<BrandFilter> brandList = new List();
  List<String> selectedBrandList = new List();
  List<String> subCategory0IdList = new List();
  List<String> subCategory1IdList = new List();
  List<String> subCategory2IdList = new List();
  List<String> subCategory3IdList = new List();
  List<String> selectedcategoryIdList = new List();
  RemoteDataSource _apiResponse = RemoteDataSource();
  List<SubCategoryLevelZeroFilter> categoryList = new List();
  TextEditingController minPriceController = new TextEditingController();
  TextEditingController maxPriceController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  ProductListingCredentials productListingCredentials = new ProductListingCredentials();
  ProductListingCredentials clearProductListingCredentials = new ProductListingCredentials();
  GetContentProductsCredentials getContentProductsCredentials = new GetContentProductsCredentials();

  @override
  void initState() {
    super.initState();
    selectedBrandList.clear();
    selectedcategoryIdList.clear();
    subCategory0IdList.clear();
    subCategory1IdList.clear();
    subCategory2IdList.clear();
    subCategory3IdList.clear();
    categoryName = widget.categoryName ?? "";
    apiName = widget.apiName;
    getContentProductsCredentials = widget.getContentProductsCredentials;
    categoryId = widget.categoryId;
    subCategory0Id = widget.subCategory0Id;
    subCategory1Id = widget.subCategory1Id;
    subCategory2Id = widget.subCategory2Id;
    subCategory3Id = widget.subCategory3Id;
    productListingCredentials = widget.productListingCredentials;
    print(json.encode(productListingCredentials));
    print(json.encode(getContentProductsCredentials));

    //From category page
    if (apiName == "productListing") {
      // Adding already selected brands to the list
      if (widget.productListingCredentials?.filter != null) {
        if (widget.productListingCredentials?.filter?.term != null) {
          if (widget.productListingCredentials?.filter?.term?.brandId != null) {
            widget.productListingCredentials?.filter?.term?.brandId
                ?.forEach((element) {
              if (!selectedBrandList.contains(element)) {
                selectedBrandList.add(element);
              }
            });
          }
        }

        if (widget.productListingCredentials?.filter?.range?.priceRanges !=
            null) {
          if (widget
                  .productListingCredentials?.filter?.range?.priceRanges?.gte !=
              null) {
            minPrice = widget
                .productListingCredentials?.filter?.range?.priceRanges?.gte
                ?.toString();
          }
          if (widget
                  .productListingCredentials?.filter?.range?.priceRanges?.lte !=
              null) {
            maxPrice = widget
                .productListingCredentials?.filter?.range?.priceRanges?.lte
                ?.toString();
          }

          if (minPrice.isNotEmpty) {
            setState(() {
              minPriceController.text = minPrice;
            });
          }

          if (maxPrice.isNotEmpty) {
            setState(() {
              maxPriceController.text = maxPrice;
            });
          }
        }

// For initial selection of category list and also adding already selected category id in filter list
        if (widget.productListingCredentials?.filter?.term?.categoryId !=
            null) {
          if (!selectedcategoryIdList.contains(
              widget.productListingCredentials?.filter?.term?.categoryId)) {
            widget.productListingCredentials?.filter?.term?.categoryId
                ?.forEach((element) {
              if (!selectedcategoryIdList.contains(element)) {
                selectedcategoryIdList.add(element);
              }
            });
          }
        }

        if (widget.productListingCredentials?.filter?.term?.subCategory0Id !=
            null) {
          if (!subCategory0IdList.contains(
              widget.productListingCredentials?.filter?.term?.subCategory0Id)) {
            widget.productListingCredentials?.filter?.term?.subCategory0Id
                ?.forEach((element) {
              if (!subCategory0IdList.contains(element)) {
                subCategory0IdList.add(element);
              }
            });
          }
        }

        if (widget.productListingCredentials?.filter?.term?.subCategory1Id !=
            null) {
          if (!subCategory1IdList.contains(
              widget.productListingCredentials?.filter?.term?.subCategory1Id)) {
            widget.productListingCredentials?.filter?.term?.subCategory1Id
                ?.forEach((element) {
              if (!subCategory1IdList.contains(element)) {
                subCategory1IdList.add(element);
              }
            });
          }
        }

        if (widget.productListingCredentials?.filter?.term?.subCategory2Id !=
            null) {
          if (!subCategory2IdList.contains(
              widget.productListingCredentials?.filter?.term?.subCategory2Id)) {
            widget.productListingCredentials?.filter?.term?.subCategory2Id
                ?.forEach((element) {
              if (!subCategory2IdList.contains(element)) {
                subCategory2IdList.add(element);
              }
            });
          }
        }

        if (widget.productListingCredentials?.filter?.term?.subCategory3Id !=
            null) {
          if (!subCategory3IdList.contains(
              widget.productListingCredentials?.filter?.term?.subCategory3Id)) {
            widget.productListingCredentials?.filter?.term?.subCategory3Id
                ?.forEach((element) {
              if (!subCategory3IdList.contains(element)) {
                subCategory3IdList.add(element);
              }
            });
          }
        }
      }
    }

    //From Home page
    else {
      // Adding already selected brands to the list

      if (getContentProductsCredentials?.filter?.term?.brandId != null) {
        if (getContentProductsCredentials?.filter?.term?.brandId?.length > 0) {
          getContentProductsCredentials?.filter?.term?.brandId
              ?.forEach((element) {
            if (!selectedBrandList.contains(element)) {
              selectedBrandList.add(element);
            }
          });
        }
      }

      // Displaying price if min price and price already exist
      if (widget.getContentProductsCredentials?.filter?.range != null) {
        if (widget.getContentProductsCredentials?.filter?.range?.priceRanges !=
            null) {
          if (widget.getContentProductsCredentials?.filter?.range?.priceRanges
                  ?.gte !=
              null) {
            minPrice = widget
                .getContentProductsCredentials?.filter?.range?.priceRanges?.gte
                ?.toString();
          }
          if (widget.getContentProductsCredentials?.filter?.range?.priceRanges
                  ?.lte !=
              null) {
            maxPrice = widget
                .getContentProductsCredentials?.filter?.range?.priceRanges?.lte
                ?.toString();
          }

          if (minPrice.isNotEmpty) {
            setState(() {
              minPriceController.text = minPrice;
            });
          }

          if (maxPrice.isNotEmpty) {
            setState(() {
              maxPriceController.text = maxPrice;
            });
          }
        }
      }

      if (widget.getContentProductsCredentials?.filter?.range != null) {
        // For initial selection of category list and also adding already selected category id in filter list
        if (widget.getContentProductsCredentials?.filter?.term?.categoryId !=
            null) {
          if (!selectedcategoryIdList.contains(
              widget.getContentProductsCredentials?.filter?.term?.categoryId)) {
            widget.getContentProductsCredentials?.filter?.term?.categoryId
                ?.forEach((element) {
              if (!selectedcategoryIdList.contains(element)) {
                selectedcategoryIdList.add(element);
              }
            });
          }
        }


        if (widget
                .getContentProductsCredentials?.filter?.term?.subCategory0Id !=
            null) {
          if (!subCategory0IdList.contains(widget
              .getContentProductsCredentials?.filter?.term?.subCategory0Id)) {
            widget.getContentProductsCredentials?.filter?.term?.subCategory0Id
                ?.forEach((element) {
              if (!subCategory0IdList.contains(element)) {
                subCategory0IdList.add(element);
              }
            });
          }
        }

        if (widget
                .getContentProductsCredentials?.filter?.term?.subCategory1Id !=
            null) {
          if (!subCategory1IdList.contains(widget
              .getContentProductsCredentials?.filter?.term?.subCategory1Id)) {
            widget.getContentProductsCredentials?.filter?.term?.subCategory1Id
                ?.forEach((element) {
              if (!subCategory1IdList.contains(element)) {
                subCategory1IdList.add(element);
              }
            });
          }
        }

        if (widget
                .getContentProductsCredentials?.filter?.term?.subCategory2Id !=
            null) {
          if (!subCategory2IdList.contains(widget
              .getContentProductsCredentials?.filter?.term?.subCategory2Id)) {
            widget.getContentProductsCredentials?.filter?.term?.subCategory2Id
                ?.forEach((element) {
              if (!subCategory2IdList.contains(element)) {
                subCategory2IdList.add(element);
              }
            });
          }
        }

        if (widget
                .getContentProductsCredentials?.filter?.term?.subCategory3Id !=
            null) {
          if (!subCategory3IdList.contains(widget
              .getContentProductsCredentials?.filter?.term?.subCategory3Id)) {
            widget.getContentProductsCredentials?.filter?.term?.subCategory3Id
                ?.forEach((element) {
              if (!subCategory3IdList.contains(element)) {
                subCategory3IdList.add(element);
              }
            });
          }
        }
      }
    }

    if (apiName == "productListing") {
      productFilterSearchFilter(widget.filterPageParms);
    } else {
      productFilterSection(widget.filterPageParmsContent);
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

  buildExpandableContentCategoryThree(
      List<SubCategoryLevelFourFilter> document3) {
    List<Widget> columnContent = [];
    for (SubCategoryLevelFourFilter content in document3) {
      columnContent.add(new ListTile(
        onTap: () {
          setState(() {
            if (!subCategory3IdList.contains(content.id)) {
              subCategory3IdList.add(content.id);
              categoryName = content.categoryName;
            } else {
              subCategory3IdList.remove(content.id);
            }
          });
        },
        title: Padding(
          padding: const EdgeInsets.only(left: 60.0),
          child: new Text(
            content.categoryName,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: subCategory1IdList.contains(content.id)
                  ? Colors.orangeAccent
                  : Colors.black,
            ),
          ),
        ),
      ));
    }
    // leading: new Icon(Icons.directions_car),

    return columnContent;
  }

  buildExpandableContentCategorytwo(
      List<SubCategoryLevelThreeFilter> document2) {
    List<Widget> columnContent = [];
    for (SubCategoryLevelThreeFilter content in document2) {
      columnContent.add(new ExpansionTile(
        title: TextButton(
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
                    color: subCategory1IdList.contains(content.id)
                        ? Colors.orangeAccent
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            setState(() {
              if (!subCategory2IdList.contains(content.id)) {
                subCategory2IdList.add(content.id);
                categoryName = content.categoryName;
              } else {
                subCategory2IdList.remove(content.id);
              }
            });
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


  buildExpandableContentCategoryZero(SubCategoryLevelZeroFilter document) {
    List<Widget> columnContent = [];

    for (SubCategoryLevelOneFilter content in document.subCategories)
      columnContent.add(ExpansionTile(
        title: TextButton(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  content.categoryName,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: subCategory0IdList.contains(content.id)
                        ? Colors.orangeAccent
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            // clicking the button will trigger this and not open the list tile
            // only the arrow will open it
            setState(() {
              if (!subCategory0IdList.contains(content.id)) {
                subCategory0IdList.add(content.id);
                categoryName = content.categoryName;
              } else {
                subCategory0IdList.remove(content.id);
              }
            });
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

  buildExpandableContentCategoryOne(List<SubCategoryLevelTwoFilter> document) {
    List<Widget> columnContent = [];

    for (SubCategoryLevelTwoFilter content in document)
      columnContent.add(ExpansionTile(
        title: TextButton(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  content.categoryName,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: subCategory1IdList.contains(content.id)
                        ? Colors.orangeAccent
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            // clicking the button will trigger this and not open the list tile
            // only the arrow will open it
            setState(() {
              if (!subCategory1IdList.contains(content.id)) {
                subCategory1IdList.add(content.id);
                categoryName = content.categoryName;
              } else {
                subCategory1IdList.remove(content.id);
              }
            });
          },
        ),
        children: <Widget>[
          new Column(
            children: buildExpandableContentCategorytwo(content.subCategories),
          ),
        ],
      ));

    return columnContent;
  }

  Container priceFilterBox() {
    final node = FocusScope.of(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Spacer(),
              Container(
                width: 100,
                height: 100,
                child: TextField(
                  style: TextStyle(fontFamily: 'Montserrat-Black'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  //  onSaved: (newValue) => email = newValue,
                  controller: minPriceController,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  onChanged: (text) {
                    if (text.length > 0) {
                      if (int.parse(minPriceController.text) > int.parse(maxPriceController.text)) {
                        isPriceValidation=true;
                      } else {
                        isPriceValidation=false;
                      }
                    }

                  },
                  decoration: InputDecoration(
                    labelText: "Min ₹ ",
                    labelStyle: TextStyle(color: Colors.black54),
                    // hintText: "Name",
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintStyle: TextStyle(color: Colors.black54),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(
                        color: Colors.black54,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(
                        color: Colors.black54,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: 100,
                height: 100,
                child: TextField(
                  style: TextStyle(fontFamily: 'Montserrat-Black'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  //  onSaved: (newValue) => email = newValue,
                  controller: maxPriceController,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),

                  onChanged: (text) {
                    setState(() {
                      if (text.length > 0) {
                        if (int.parse(text) > int.parse(minPriceController.text)) {
                          isPriceValidation=false;
                        } else {
                          isPriceValidation=true;
                        }
                      }
                      else
                        {
                          isPriceValidation=false;
                        }
                    });
                  },
                  decoration: InputDecoration(
                    // errorText: isPriceValidation?
                    //      'MinPrice should be less than MaxPrice'
                    //     : null,
                    labelText: "Max ₹ ",
                    labelStyle: TextStyle(color: Colors.black54),
                    // hintText: "Name",
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintStyle: TextStyle(color: Colors.black54),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(
                        color: Colors.black54,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(
                        color: Colors.black54,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Container CategoryFilterBox() {
    return Container(
        height: 300 * categoryList?.length.toDouble(),
        child: Container(
          child: ListView.builder(
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              return new ExpansionTile(
                title: TextButton(
                  child: Row(
                    children: [
                      Text(
                        categoryList[index].categoryName,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: selectedcategoryIdList
                                  .contains(categoryList[index].id)
                              ? Colors.orangeAccent
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      if (!selectedcategoryIdList
                          .contains(categoryList[index].id)) {
                        selectedcategoryIdList.add(categoryList[index].id);
                      } else {
                        selectedcategoryIdList.removeAt(index);
                      }
                    });
                  },
                ),
                children: <Widget>[
                  new Column(
                    children:
                        buildExpandableContentCategoryZero(categoryList[index]),
                  ),
                ],
              );
            },
          ),
        ));
  }

  Container brandFilterBox() {
    return Container(
      height: 60 * brandList?.length.toDouble(),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: brandList?.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(brandList[index]?.brandName),
            value: _isChecked[index],
            onChanged: (val) {
              setState(() {
                _isChecked[index] = val;
                if (selectedBrandList.contains(brandList[index].brandId)) {
                  selectedBrandList.remove(brandList[index].brandId);
                } else {
                  selectedBrandList.add(brandList[index].brandId);
                }
              });
            },
          );
        },
      ),
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(6),
              child: IconButton(
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
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(6),
            child: Text("Filters",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
          ),
          Spacer(),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return new ExpansionTile(
                      initiallyExpanded: true,
                      title: index == 0
                          ? Text(
                              "Price",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black),
                            )
                          : index == 1
                              ? Text(
                                  "Brand",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                )
                              : Text(
                                  "Category",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                ),
                      children: <Widget>[
                        Column(
                          children: [
                            index == 0
                                ? priceFilterBox()
                                : index == 1
                                    ? brandFilterBox()
                                    : CategoryFilterBox()
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                height: 70,
                color: Colors.black12,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      color: Colors.white,
                      height: 48,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              // productListingCredentials=clearProductListingCredentials;
                              setState(() {
                                minPriceController.text = "";
                                maxPriceController.text = "";
                                selectedBrandList.clear();
                                selectedcategoryIdList.clear();
                                subCategory0IdList.clear();
                                subCategory1IdList.clear();
                                subCategory2IdList.clear();
                                subCategory3IdList.clear();

                                if (apiName == "productListing") {
                                  productListingCredentials.filter.term = null;
                                  productListingCredentials.filter.range = null;
                                  _isChecked =
                                      List<bool>.filled(brandListSize, false);
                                  if (categoryId != null &&
                                      categoryId != "" &&
                                      categoryId != "null") {
                                    selectedcategoryIdList.add(categoryId);
                                  }
                                  if (subCategory0Id != null &&
                                      subCategory0Id != "" &&
                                      subCategory0Id != "null") {
                                    subCategory0IdList.add(subCategory0Id);
                                  }
                                  if (subCategory1Id != null &&
                                      subCategory1Id != "" &&
                                      subCategory1Id != "null") {
                                    subCategory1IdList.add(subCategory1Id);
                                  }
                                  if (subCategory2Id != null &&
                                      subCategory2Id != "" &&
                                      subCategory2Id != "null") {
                                    subCategory2IdList.add(subCategory2Id);
                                  }
                                  if (subCategory3Id != null &&
                                      subCategory3Id != "" &&
                                      subCategory3Id != "null") {
                                    subCategory3IdList.add(subCategory3Id);
                                  }
                                  // newList.type = "search-filter";
                                  //productFilterSearchFilter(widget.filterPageParms);

                                } else {
                                  getContentProductsCredentials.filter.term =
                                      null;
                                  getContentProductsCredentials.filter.range =
                                      null;
                                  _isChecked =
                                      List<bool>.filled(brandListSize, false);
                                  // getContentProductsCredentials.type = "section";
                                  // productFilterSection(widget.filterPageParmsContent);
                                }
                              });
                            },
                            child: Text("Clear All",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              if(isPriceValidation==false) {
                                minPrice = minPriceController.text;
                                maxPrice = maxPriceController.text;

                                List<String> pincodeList = new List();

                                SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                                final pinCode = preferences.getString(
                                    "pinCode");

                                if (apiName == "productListing") {
                                  TermCredentials termCredentials =
                                  new TermCredentials();

                                  OutOfStockProduct outOfStockProduct =
                                  new OutOfStockProduct();
                                  outOfStockProduct.gte = "1";
                                  RangeFilter _rangeFilter = RangeFilter();
                                    if (minPrice.length>0 ||
                                        maxPrice.length>0) {
                                      PriceRanges _priceranges =
                                      PriceRanges();

                                      if (minPrice != null &&
                                          minPrice != ("null") &&
                                          minPrice != ("")) {
                                        _priceranges.gte = int.parse(minPrice);
                                      }
                                      if (maxPrice != null &&
                                          maxPrice != ("null") &&
                                          maxPrice != ("")) {
                                        _priceranges.lte = int.parse(maxPrice);
                                      }

                                      _rangeFilter.priceRanges = _priceranges;
                                    }

                                  _rangeFilter.outOfStock = outOfStockProduct;
                                  productListingCredentials.hasRangeAndSort =
                                  true;
                                  productListingCredentials.filter.range =
                                      _rangeFilter;

                                  if (selectedcategoryIdList.length > 0) {
                                    termCredentials.categoryId =
                                        selectedcategoryIdList;
                                    if (pinCode != null &&
                                        pinCode != ("null") &&
                                        pinCode != ("")) {
                                      if (!pincodeList.contains(pinCode)) {
                                        pincodeList.add(pinCode);
                                        pincodeList.add("All India");
                                        termCredentials.serviceLocations =
                                            pincodeList;
                                      }
                                    }
                                  }

                                  if (subCategory0IdList.length > 0) {
                                    termCredentials.subCategory0Id =
                                        subCategory0IdList;
                                    if (pinCode != null &&
                                        pinCode != ("null") &&
                                        pinCode != ("")) {
                                      if (!pincodeList.contains(pinCode)) {
                                        pincodeList.add(pinCode);
                                        pincodeList.add("All India");
                                        termCredentials.serviceLocations =
                                            pincodeList;
                                      }
                                    }
                                  }

                                  if (subCategory1IdList.length > 0) {
                                    termCredentials.subCategory1Id =
                                        subCategory1IdList;
                                    if (pinCode != null &&
                                        pinCode != ("null") &&
                                        pinCode != ("")) {
                                      if (!pincodeList.contains(pinCode)) {
                                        pincodeList.add(pinCode);
                                        pincodeList.add("All India");
                                        termCredentials.serviceLocations =
                                            pincodeList;
                                      }
                                    }
                                  }

                                  if (subCategory2IdList.length > 0) {
                                    termCredentials.subCategory2Id =
                                        subCategory2IdList;
                                    if (pinCode != null &&
                                        pinCode != ("null") &&
                                        pinCode != ("")) {
                                      if (!pincodeList.contains(pinCode)) {
                                        pincodeList.add(pinCode);
                                        pincodeList.add("All India");
                                        termCredentials.serviceLocations =
                                            pincodeList;
                                      }
                                    }
                                  }

                                  if (subCategory3IdList.length > 0) {
                                    termCredentials.subCategory3Id =
                                        subCategory3IdList;
                                    if (pinCode != null &&
                                        pinCode != ("null") &&
                                        pinCode != ("")) {
                                      if (!pincodeList.contains(pinCode)) {
                                        pincodeList.add(pinCode);
                                        pincodeList.add("All India");
                                        termCredentials.serviceLocations =
                                            pincodeList;
                                      }
                                    }
                                  }

                                  if (selectedBrandList.length > 0) {
                                    termCredentials.brandId = selectedBrandList;
                                    if (pinCode != null &&
                                        pinCode != ("null") &&
                                        pinCode != ("")) {
                                      if (!pincodeList.contains(pinCode)) {
                                        pincodeList.add(pinCode);
                                        pincodeList.add("All India");
                                        termCredentials.serviceLocations =
                                            pincodeList;
                                      }
                                    }
                                  } else {
                                    if (pinCode != null &&
                                        pinCode != ("null") &&
                                        pinCode != ("")) {
                                      if (!pincodeList.contains(pinCode)) {
                                        pincodeList.add(pinCode);
                                        pincodeList.add("All India");
                                        termCredentials.serviceLocations =
                                            pincodeList;
                                      }
                                    }
                                  }
                                  productListingCredentials.offset = 0;
                                  productListingCredentials.size = 20;
                                  productListingCredentials.filter.term =
                                      termCredentials;


                                  print("Product Filter Button Clicked: " +
                                      json.encode(productListingCredentials));

                                    Navigator.pop(context, [ 
                                      apiName,
                                      productListingCredentials,
                                      categoryName,
                                      getContentProductsCredentials,
                                      isFromFilterPage
                                    ]);

                                } else {
                                  OutOfStockGetContent outOfStockGetContent =
                                  new OutOfStockGetContent();
                                  outOfStockGetContent.gte = "1";

                                  RangeFilterContent _rangeFilter =
                                  RangeFilterContent();

                                    if (minPrice.length>0 ||
                                        maxPrice.length>0) {
                                      PriceRangesContent _priceranges =
                                      PriceRangesContent();

                                      if (minPrice != null &&
                                          minPrice != ("null") &&
                                          minPrice != ("")) {
                                        _priceranges.gte = int.parse(minPrice);
                                      }
                                      if (maxPrice != null &&
                                          maxPrice != ("null") &&
                                          maxPrice != ("")) {
                                        _priceranges.lte = int.parse(maxPrice);
                                      }

                                      _rangeFilter.priceRanges = _priceranges;
                                    }

                                  _rangeFilter.outOfStock =
                                      outOfStockGetContent;
                                  getContentProductsCredentials.offset = 0;
                                  getContentProductsCredentials.size = 20;
                                  getContentProductsCredentials
                                      .hasRangeAndSort =
                                  true;
                                  getContentProductsCredentials.forMobileApp =
                                  true;
                                  getContentProductsCredentials.filter.range =
                                      _rangeFilter;

                                  if (selectedcategoryIdList.length > 0) {
                                    TermCredentialsContent termCredentials =
                                    new TermCredentialsContent();
                                    termCredentials.categoryId =
                                        selectedcategoryIdList;
                                    if (pinCode != null &&
                                        pinCode != ("null") &&
                                        pinCode != ("")) {
                                      if (!pincodeList.contains(pinCode)) {
                                        pincodeList.add(pinCode);
                                        pincodeList.add("All India");
                                        termCredentials.serviceLocations =
                                            pincodeList;
                                      }
                                    }
                                    getContentProductsCredentials.filter.term =
                                        termCredentials;
                                  }

                                   if (subCategory0IdList.length > 0) {
                                    TermCredentialsContent termCredentials =
                                    new TermCredentialsContent();
                                    termCredentials.subCategory0Id =
                                        subCategory0IdList;
                                    if (pinCode != null &&
                                        pinCode != ("null") &&
                                        pinCode != ("")) {
                                      if (!pincodeList.contains(pinCode)) {
                                        pincodeList.add(pinCode);
                                        pincodeList.add("All India");
                                        termCredentials.serviceLocations =
                                            pincodeList;
                                      }
                                    }
                                    getContentProductsCredentials.filter.term =
                                        termCredentials;
                                  }

                                  if (subCategory1IdList.length > 0) {
                                    TermCredentialsContent termCredentials =
                                    new TermCredentialsContent();
                                    termCredentials.subCategory1Id =
                                        subCategory1IdList;
                                    if (pinCode != null &&
                                        pinCode != ("null") &&
                                        pinCode != ("")) {
                                      if (!pincodeList.contains(pinCode)) {
                                        pincodeList.add(pinCode);
                                        pincodeList.add("All India");
                                        termCredentials.serviceLocations =
                                            pincodeList;
                                      }
                                    }
                                    getContentProductsCredentials.filter.term =
                                        termCredentials;
                                  }

                                  if (subCategory2IdList.length > 0) {
                                    TermCredentialsContent termCredentials =
                                    new TermCredentialsContent();
                                    termCredentials.subCategory2Id =
                                        subCategory2IdList;
                                    if (pinCode != null &&
                                        pinCode != ("null") &&
                                        pinCode != ("")) {
                                      if (!pincodeList.contains(pinCode)) {
                                        pincodeList.add(pinCode);
                                        pincodeList.add("All India");
                                        termCredentials.serviceLocations =
                                            pincodeList;
                                      }
                                    }
                                    getContentProductsCredentials.filter.term =
                                        termCredentials;
                                  }

                                  if (subCategory3IdList.length > 0) {
                                    TermCredentialsContent termCredentials =
                                    new TermCredentialsContent();
                                    termCredentials.subCategory3Id =
                                        subCategory3IdList;
                                    if (pinCode != null &&
                                        pinCode != ("null") &&
                                        pinCode != ("")) {
                                      if (!pincodeList.contains(pinCode)) {
                                        pincodeList.add(pinCode);
                                        pincodeList.add("All India");
                                        termCredentials.serviceLocations =
                                            pincodeList;
                                      }
                                    }
                                    getContentProductsCredentials.filter.term =
                                        termCredentials;
                                  }
                                  if (selectedBrandList.length > 0) {
                                    TermCredentialsContent termCredentials =
                                    new TermCredentialsContent();
                                    termCredentials.brandId = selectedBrandList;
                                    if (pinCode != null &&
                                        pinCode != ("null") &&
                                        pinCode != ("")) {
                                      if (!pincodeList.contains(pinCode)) {
                                        pincodeList.add(pinCode);
                                        pincodeList.add("All India");
                                        termCredentials.serviceLocations =
                                            pincodeList;
                                      }
                                    }
                                    getContentProductsCredentials.filter.term =
                                        termCredentials;
                                  } else {
                                    TermCredentialsContent termCredentials =
                                    new TermCredentialsContent();
                                    if (pinCode != null &&
                                        pinCode != ("null") &&
                                        pinCode != ("")) {
                                      if (!pincodeList.contains(pinCode)) {
                                        pincodeList.add(pinCode);
                                        pincodeList.add("All India");
                                        termCredentials.serviceLocations =
                                            pincodeList;
                                      }
                                    }
                                    getContentProductsCredentials.filter.term =
                                        termCredentials;
                                  }


                                  getContentProductsCredentials.offset = 0;
                                  getContentProductsCredentials.size = 20;
                                  print("***Filter Content*** " +
                                      json.encode(
                                          getContentProductsCredentials));

                                    Navigator.pop(context, [
                                      apiName,
                                      productListingCredentials,
                                      categoryName,
                                      // pinCode,
                                      getContentProductsCredentials,
                                      isFromFilterPage
                                    ]);
                                }
                              }
                              else
                                {
                                  showToast("MinPrice should be less than MaxPrice");
                                }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(6),
                              child: Text("Apply",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      key: _scaffoldkey,
    );
  }

  //Product listing api call
  Future<FilterResponseModel> productFilterSection(
      var getContentProductsCredentials) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    setState(() {
      isLoading = true;
    });

    Result result =
        await _apiResponse.productFilterSection(getContentProductsCredentials);

    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      FilterResponseModel response = (result).value;
      if (response.status == "success") {
        setState(() {
          categoryList = response.category;
          brandList = response.brand;
          brandListSize = brandList.length;
          _isChecked = List<bool>.filled(brandList?.length, false);

          for (int i = 0; i < brandList.length; i++) {
            if (selectedBrandList.contains(brandList[i].brandId)) {
              _isChecked[i] = true;
            }
          }
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

  //Product listing api call
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
          categoryList = response.category;
          brandList = response.brand;
          _isChecked = List<bool>.filled(brandList?.length, false);
          brandListSize = brandList.length;
          for (int i = 0; i < brandList.length; i++) {
            if (selectedBrandList.contains(brandList[i].brandId)) {
              _isChecked[i] = true;
            }
          }
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
}
