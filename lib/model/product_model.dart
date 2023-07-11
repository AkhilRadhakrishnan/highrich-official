import 'dart:convert';

import 'cart_model.dart';

class ProductsModel {
  String status;
  dynamic count;
  List<Products> products;

  factory ProductsModel.fromRawJson(String str) =>
      ProductsModel.fromJson(json.decode(str));

  ProductsModel({this.status, this.count, this.products});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    if (json['products'] != null) {
      if (json['products'] != dynamic) {
        products = new List<Products>();
        json['products'].forEach((v) {
          products.add(new Products.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['count'] = this.count;
    if (this.products != dynamic) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String index;
  String type;
  String id;
  dynamic version;
  Source source;

  Products({this.index, this.type, this.id, this.version, this.source});

  Products.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    type = json['type'];
    id = json['id'];
    version = json['version'];
    source =
        json['source'] != dynamic ? new Source.fromJson(json['source']) : dynamic;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['type'] = this.type;
    data['id'] = this.id;
    data['version'] = this.version;
    if (this.source != dynamic) {
      data['source'] = this.source.toJson();
    }
    return data;
  }
}

class Source {
  String productId;
  String name;
  String nameNotAnalysed;
  String overview;
  List<dynamic> specifications;
  List<dynamic> tags;
  List<String> images;
  dynamic masterImage;
  dynamic videos;
  String videoURL;
 // List<ProductBatches> productBatches=[];

  dynamic hasVendorDiscount;
  dynamic hasAdminDiscount;
  bool active;
  bool isDraft;
  dynamic isFeatured;
  String vendorType;
  String vendorId;
  bool isVendorBlocked;
  String brandId;
  String brandName;
  String categoryId;
  String subCategory1Id;
  String subCategory2Id;
  String subCategory3Id;
  bool activeCategory;
  String categoryName;
  String subCategory1Name;
  String subCategory2Name;
  String subCategory3Name;
  dynamic rating;
  dynamic avgRating;
  dynamic totalRatingsRegistered;
  dynamic commentIds;
  bool isCODEnabled;
  List<String> serviceLocations;
  dynamic codEnabledServiceLocations;
  ServiceLocationRequest serviceLocationRequest;
  int lastModifiedDate;
  dynamic visitCount;
  String status;
  List<ProcessedPriceAndStocks> processedPriceAndStock;

  Source(
      {this.productId,
        this.name,
        this.nameNotAnalysed,
        this.overview,
        this.specifications,
        this.tags,
        this.images,
        this.masterImage,
        this.videos,
        this.videoURL,
        //this.productBatches,

        this.hasVendorDiscount,
        this.hasAdminDiscount,
        this.active,
        this.isDraft,
        this.isFeatured,
        this.vendorType,
        this.vendorId,
        this.isVendorBlocked,
        this.brandId,
        this.brandName,
        this.categoryId,
        this.subCategory1Id,
        this.subCategory2Id,
        this.subCategory3Id,
        this.activeCategory,
        this.categoryName,
        this.subCategory1Name,
        this.subCategory2Name,
        this.subCategory3Name,
        this.rating,
        this.avgRating,
        this.totalRatingsRegistered,
        this.commentIds,
        this.isCODEnabled,
        this.serviceLocations,
        this.codEnabledServiceLocations,
        this.serviceLocationRequest,
        this.lastModifiedDate,
        this.visitCount,
        this.status,
        this.processedPriceAndStock});

  Source.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    nameNotAnalysed = json['nameNotAnalysed'];
    overview = json['overview'];
    // if (json['specifications'] != dynamic) {
    //   specifications = new List<dynamic>();
    //   json['specifications'].forEach((v) {
    //     specifications.add(new dynamic.fromJson(v));
    //   });
    // }
    // if (json['tags'] != dynamic) {
    //   tags = new List<dynamic>();
    //   json['tags'].forEach((v) {
    //     tags.add(new dynamic.fromJson(v));
    //   });
    // }
    images = json['images'].cast<String>();
    masterImage = json['masterImage'];
    videos = json['videos'];
    videoURL = json['videoURL'];
    // if (json['productBatches'] != dynamic) {
    //   productBatches = new List<ProductBatches>();
    //   json['productBatches'].forEach((v) {
    //     productBatches.add(new ProductBatches.fromJson(v));
    //   });
    // }



    hasVendorDiscount = json['hasVendorDiscount'];
    hasAdminDiscount = json['hasAdminDiscount'];
    active = json['active'];
    isDraft = json['isDraft'];
    isFeatured = json['isFeatured'];
    vendorType = json['vendorType'];
    vendorId = json['vendorId'];
    isVendorBlocked = json['isVendorBlocked'];
    brandId = json['brandId'];
    brandName = json['brandName'];
    categoryId = json['categoryId'];
    subCategory1Id = json['subCategory1Id'];
    subCategory2Id = json['subCategory2Id'];
    subCategory3Id = json['subCategory3Id'];
    activeCategory = json['activeCategory'];
    categoryName = json['categoryName'];
    subCategory1Name = json['subCategory1Name'];
    subCategory2Name = json['subCategory2Name'];
    subCategory3Name = json['subCategory3Name'];
    rating = json['rating'];
    avgRating = json['avgRating'];
    totalRatingsRegistered = json['totalRatingsRegistered'];
    commentIds = json['commentIds'];
    isCODEnabled = json['isCODEnabled'];
    serviceLocations = json['serviceLocations'].cast<String>();
    codEnabledServiceLocations = json['codEnabledServiceLocations'];
    serviceLocationRequest = json['serviceLocationRequest'] != null
        ? new ServiceLocationRequest.fromJson(json['serviceLocationRequest'])
        : null;
    lastModifiedDate = json['lastModifiedDate'];
    visitCount = json['visitCount'];
    status = json['status'];
    if (json['processedPriceAndStock'] != dynamic) {
      processedPriceAndStock = new List<ProcessedPriceAndStocks>();
      json['processedPriceAndStock'].forEach((v) {
        processedPriceAndStock.add(new ProcessedPriceAndStocks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['name'] = this.name;
    data['nameNotAnalysed'] = this.nameNotAnalysed;
    data['overview'] = this.overview;
    if (this.specifications != dynamic) {
      data['specifications'] =
          this.specifications.map((v) => v.toJson()).toList();
    }
    if (this.tags != dynamic) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    data['images'] = this.images;
    data['masterImage'] = this.masterImage;
    data['videos'] = this.videos;
    data['videoURL'] = this.videoURL;
    // if (this.productBatches != dynamic) {
    //   data['productBatches'] =
    //       this.productBatches.map((v) => v.toJson()).toList();
    // }

    data['hasVendorDiscount'] = this.hasVendorDiscount;
    data['hasAdminDiscount'] = this.hasAdminDiscount;
    data['active'] = this.active;
    data['isDraft'] = this.isDraft;
    data['isFeatured'] = this.isFeatured;
    data['vendorType'] = this.vendorType;
    data['vendorId'] = this.vendorId;
    data['isVendorBlocked'] = this.isVendorBlocked;
    data['brandId'] = this.brandId;
    data['brandName'] = this.brandName;
    data['categoryId'] = this.categoryId;
    data['subCategory1Id'] = this.subCategory1Id;
    data['subCategory2Id'] = this.subCategory2Id;
    data['subCategory3Id'] = this.subCategory3Id;
    data['activeCategory'] = this.activeCategory;
    data['categoryName'] = this.categoryName;
    data['subCategory1Name'] = this.subCategory1Name;
    data['subCategory2Name'] = this.subCategory2Name;
    data['subCategory3Name'] = this.subCategory3Name;
    data['rating'] = this.rating;
    data['avgRating'] = this.avgRating;
    data['totalRatingsRegistered'] = this.totalRatingsRegistered;
    data['commentIds'] = this.commentIds;
    data['isCODEnabled'] = this.isCODEnabled;
    data['serviceLocations'] = this.serviceLocations;
    data['codEnabledServiceLocations'] = this.codEnabledServiceLocations;
    if (this.serviceLocationRequest != dynamic) {
      data['serviceLocationRequest'] = this.serviceLocationRequest.toJson();
    }
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['visitCount'] = this.visitCount;
    data['status'] = this.status;
    if (this.processedPriceAndStock != dynamic) {
      data['processedPriceAndStock'] =
          this.processedPriceAndStock.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductBatches {
  int addedDate;
  List<PriceAndStocks> priceAndStocks;
  String type;
  String batchNumber;

  ProductBatches(
      {this.addedDate, this.priceAndStocks, this.type, this.batchNumber});

  ProductBatches.fromJson(Map<String, dynamic> json) {
    addedDate = json['addedDate'];
    if (json['priceAndStocks'] != dynamic) {
      priceAndStocks = new List<PriceAndStocks>();
      json['priceAndStocks'].forEach((v) {
        priceAndStocks.add(new PriceAndStocks.fromJson(v));
      });
    }
    type = json['type'];
    batchNumber = json['batchNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addedDate'] = this.addedDate;
    if (this.priceAndStocks != dynamic) {
      data['priceAndStocks'] =
          this.priceAndStocks.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    data['batchNumber'] = this.batchNumber;
    return data;
  }
}

class PriceAndStocks {
  String unit;
  double sellingPrice;
  String quantity;
  double price;
  int variant;
  int discount;
  int stock;

  PriceAndStocks(
      {this.unit,
        this.sellingPrice,
        this.quantity,
        this.price,
        this.variant,
        this.discount,
        this.stock});

  PriceAndStocks.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    sellingPrice = json['sellingPrice'];
    quantity = json['quantity'];
    price = json['price'];
    variant = json['variant'];
    discount = json['discount'];
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unit'] = this.unit;
    data['sellingPrice'] = this.sellingPrice;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['variant'] = this.variant;
    data['discount'] = this.discount;
    data['stock'] = this.stock;
    return data;
  }
}

class ServiceLocationRequest {
  String country;
  List<String> state;
  List<String> district;
  List<String> pincode;

  ServiceLocationRequest(
      {this.country, this.state, this.district, this.pincode});

  ServiceLocationRequest.fromJson(Map<String, dynamic> json) {
    if (json['country'] != null) {
      country = json['country'];
    }

    state = json['state'].cast<String>();
    district = json['district'].cast<String>();
    pincode = json['pincode'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['state'] = this.state;
    data['district'] = this.district;
    data['pincode'] = this.pincode;
    return data;
  }
}

class PinCodeAvailabilityModel{
  final String status;
  final String message;
  final bool availability;
  final String pinCode;
  final Products product;

  PinCodeAvailabilityModel({
    this.status,
    this.message,
    this.availability,
    this.pinCode,
    this.product,
  });

  factory PinCodeAvailabilityModel.fromJson(Map<String, dynamic> json) => PinCodeAvailabilityModel(
    status: json["status"],
    message: json["message"],
    availability: json["availability"],
    pinCode: json["pinCode"],
    product: json["product"]==null ? null :  Products.fromJson(json["product"]),
  );
}

