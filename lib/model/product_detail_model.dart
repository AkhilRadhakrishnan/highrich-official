import 'dart:convert';

import 'cart_model.dart';

class ProductDetailModel {
  String status;
  int count;
  Product product;
  List<RelatedProducts> relatedProducts;
  List<RelatedProducts> recentlyViewedProducts;

  ProductDetailModel(
      {this.status,
      this.count,
      this.product,
      this.relatedProducts,
      this.recentlyViewedProducts});

  factory ProductDetailModel.fromRawJson(String str) =>
      ProductDetailModel.fromJson(json.decode(str));

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];

    if (json['product'] != null) {
      product = json['product'] != dynamic
          ? new Product.fromJson(json['product'])
          : dynamic;
    }

    if (json['relatedProducts'] != null) {
      relatedProducts = new List<RelatedProducts>();
      json['relatedProducts'].forEach((v) {
        relatedProducts.add(new RelatedProducts.fromJson(v));
      });
    }
    if (json['recentlyViewedProducts'] != null) {
      recentlyViewedProducts = new List<RelatedProducts>();
      json['recentlyViewedProducts'].forEach((v) {
        recentlyViewedProducts.add(new RelatedProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['count'] = this.count;
    if (this.product != dynamic) {
      data['product'] = this.product.toJson();
    }
    if (this.relatedProducts != null) {
      data['relatedProducts'] =
          this.relatedProducts.map((v) => v.toJson()).toList();
    }
    if (this.recentlyViewedProducts != null) {
      data['recentlyViewedProducts'] =
          this.recentlyViewedProducts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RelatedProducts {
  String index;
  String type;
  String id;
  int version;
  SourceRelatedProducts source;

  RelatedProducts({this.index, this.type, this.id, this.version, this.source});

  RelatedProducts.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    type = json['type'];
    id = json['id'];
    version = json['version'];
    source = json['source'] != null
        ? new SourceRelatedProducts.fromJson(json['source'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['type'] = this.type;
    data['id'] = this.id;
    data['version'] = this.version;
    if (this.source != null) {
      data['source'] = this.source.toJson();
    }
    return data;
  }
}

class SourceRelatedProducts {
  String productId;
  String name;
  String nameNotAnalysed;
  String overview;
  List<SpecificationsRelatedProducts> specifications;
  List<String> tags;
  List<String> images;
  dynamic masterImage;
  dynamic videos;
  String videoURL;
  List<dynamic> priceRanges;
  List<dynamic> discountRanges;
  dynamic hasVendorDiscount;
  dynamic hasAdminDiscount;
  bool active;
  bool isDraft;
  dynamic isFeatured;
  String vendorType;
  String vendorId;
  String vendor;
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

  SourceRelatedProducts(
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
      this.priceRanges,
      this.discountRanges,
      this.hasVendorDiscount,
      this.hasAdminDiscount,
      this.active,
      this.isDraft,
      this.isFeatured,
      this.vendorType,
      this.vendorId,
      this.vendor,
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

  SourceRelatedProducts.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    nameNotAnalysed = json['nameNotAnalysed'];
    overview = json['overview'];
    if (json['specifications'] != null) {
      specifications = new List<SpecificationsRelatedProducts>();
      json['specifications'].forEach((v) {
        specifications.add(new SpecificationsRelatedProducts.fromJson(v));
      });
    }
    tags = json['tags'].cast<String>();
    images = json['images'].cast<String>();
    masterImage = json['masterImage'];
    videos = json['videos'];
    videoURL = json['videoURL'];

    if (json['priceRanges'] != null) {
      priceRanges = json['priceRanges'].cast<dynamic>();
    }
    if (json['discountRanges'] != null) {
      discountRanges = json['discountRanges'].cast<dynamic>();
    }

    hasVendorDiscount = json['hasVendorDiscount'];
    hasAdminDiscount = json['hasAdminDiscount'];
    active = json['active'];
    isDraft = json['isDraft'];
    isFeatured = json['isFeatured'];
    vendorType = json['vendorType'];
    vendorId = json['vendorId'];
    vendor = json['vendor'];
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
    if (json['processedPriceAndStock'] != null) {
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
    if (this.specifications != null) {
      data['specifications'] =
          this.specifications.map((v) => v.toJson()).toList();
    }
    data['tags'] = this.tags;
    data['images'] = this.images;
    data['masterImage'] = this.masterImage;
    data['videos'] = this.videos;
    data['videoURL'] = this.videoURL;
    data['priceRanges'] = this.priceRanges;
    data['discountRanges'] = this.discountRanges;
    data['hasVendorDiscount'] = this.hasVendorDiscount;
    data['hasAdminDiscount'] = this.hasAdminDiscount;
    data['active'] = this.active;
    data['isDraft'] = this.isDraft;
    data['isFeatured'] = this.isFeatured;
    data['vendorType'] = this.vendorType;
    data['vendorId'] = this.vendorId;
    data['vendor'] = this.vendor;
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
    if (this.serviceLocationRequest != null) {
      data['serviceLocationRequest'] = this.serviceLocationRequest.toJson();
    }
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['visitCount'] = this.visitCount;
    data['status'] = this.status;
    if (this.processedPriceAndStock != null) {
      data['processedPriceAndStock'] =
          this.processedPriceAndStock.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpecificationsRelatedProducts {
  String value;
  String key;

  SpecificationsRelatedProducts({this.value, this.key});

  SpecificationsRelatedProducts.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['key'] = this.key;
    return data;
  }
}

class ServiceLocationRequestRelatedProducts {
  String country;
  List<String> state;
  List<String> district;
  List<String> pincode;

  ServiceLocationRequestRelatedProducts(
      {this.country, this.state, this.district, this.pincode});

  ServiceLocationRequestRelatedProducts.fromJson(Map<String, dynamic> json) {
    country = json['country'];
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

class ProcessedPriceAndStockRelatedProducts {
  int serialNumber;
  List<String> batchNumbers;
  int variant;
  String quantity;
  String unit;
  int price;
  int discount;
  int stock;
  double sellingPrice;

  ProcessedPriceAndStockRelatedProducts(
      {this.serialNumber,
      this.batchNumbers,
      this.variant,
      this.quantity,
      this.unit,
      this.price,
      this.discount,
      this.stock,
      this.sellingPrice});

  ProcessedPriceAndStockRelatedProducts.fromJson(Map<String, dynamic> json) {
    serialNumber = json['serialNumber'];
    batchNumbers = json['batchNumbers'].cast<String>();
    variant = json['variant'];
    quantity = json['quantity'];
    unit = json['unit'];
    price = json['price'];
    discount = json['discount'];
    stock = json['stock'];
    sellingPrice = json['sellingPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serialNumber'] = this.serialNumber;
    data['batchNumbers'] = this.batchNumbers;
    data['variant'] = this.variant;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['stock'] = this.stock;
    data['sellingPrice'] = this.sellingPrice;
    return data;
  }
}

class Product {
  String index;
  String type;
  String id;
  int version;
  Source source;

  Product({this.index, this.type, this.id, this.version, this.source});

  Product.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    type = json['type'];
    id = json['id'];
    version = json['version'];

    if (json['source'] != null) {
      source = json['source'] != dynamic
          ? new Source.fromJson(json['source'])
          : dynamic;
    }
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
  dynamic name;
  String overview;
  String categoryId;
  String categoryName;
  bool activeCategory;
  String videoURL;
  String productId;
  String nameNotAnalysed;
  String vendorId;
  bool isVendorBlocked;
  String vendorType;
  String vendor;
  String vendorMobile;
  bool active;
  bool isDraft;
  bool isFeatured;
  String status;
  // List<dynamic> tags;
  List<String> serviceLocations;
  List<dynamic> specifications;
//  List<dynamic> videos;
  List<String> images;
  int lastModifiedDate;
  String brandName;
  String subCategory2Name;
  String subCategory3Id;
  String subCategory3Name;
  String subCategory1Name;
  String brandId;
  String subCategory1Id;
  String subCategory2Id;
  bool isCODEnabled;
  ServiceLocationRequest serviceLocationRequest;
  // dynamic rating;
  // dynamic hasVendorDiscount;
  // dynamic hasAdminDiscount;
  // dynamic commentIds;
  // dynamic visitCount;
  // dynamic avgRating;
  // dynamic codEnabledServiceLocations;
  // dynamic totalRatingsRegistered;
  List<ProductBatches> productBatches;
  // dynamic priceRanges;
  // dynamic masterImage;
  // dynamic discountRanges;
  List<ProcessedPriceAndStocks> processedPriceAndStock;

  Source(
      {this.name,
      this.overview,
      this.categoryId,
      this.categoryName,
      this.activeCategory,
      this.videoURL,
      this.productId,
      this.nameNotAnalysed,
      this.vendorId,
      this.isVendorBlocked,
      this.vendorType,
      this.vendor,
      this.vendorMobile,
      this.active,
      this.isDraft,
      this.isFeatured,
      this.status,
      // this.tags,
      this.serviceLocations,
      this.specifications,
      // this.videos,
      this.images,
      this.lastModifiedDate,
      this.brandName,
      this.subCategory2Name,
      this.subCategory3Id,
      this.subCategory3Name,
      this.subCategory1Name,
      this.brandId,
      this.subCategory1Id,
      this.subCategory2Id,
      this.isCODEnabled,
      this.serviceLocationRequest,
      // this.rating,
      // this.hasVendorDiscount,
      // this.hasAdminDiscount,
      // this.commentIds,
      // this.visitCount,
      // this.avgRating,
      // this.codEnabledServiceLocations,
      // this.totalRatingsRegistered,
      this.productBatches,
      // this.priceRanges,
      // this.masterImage,
      // this.discountRanges,
      this.processedPriceAndStock});

  Source.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    overview = json['overview'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    activeCategory = json['activeCategory'];
    videoURL = json['videoURL'];
    productId = json['productId'];
    nameNotAnalysed = json['nameNotAnalysed'];
    vendorId = json['vendorId'];
    isVendorBlocked = json['isVendorBlocked'];
    vendorType = json['vendorType'];
    vendor = json['vendor'];
    vendorMobile = json['vendorMobile'];
    active = json['active'];
    isDraft = json['isDraft'];
    isFeatured = json['isFeatured'];
    status = json['status'];

    serviceLocations = json['serviceLocations'].cast<String>();

    images = json['images'].cast<String>();
    lastModifiedDate = json['lastModifiedDate'];
    brandName = json['brandName'];
    subCategory2Name = json['subCategory2Name'];
    subCategory3Id = json['subCategory3Id'];
    subCategory3Name = json['subCategory3Name'];
    subCategory1Name = json['subCategory1Name'];
    brandId = json['brandId'];
    subCategory1Id = json['subCategory1Id'];
    subCategory2Id = json['subCategory2Id'];
    isCODEnabled = json['isCODEnabled'];
    serviceLocationRequest = json['serviceLocationRequest'] != null
        ? new ServiceLocationRequest.fromJson(json['serviceLocationRequest'])
        : null;
    // rating = json['rating'];
    // hasVendorDiscount = json['hasVendorDiscount'];
    // hasAdminDiscount = json['hasAdminDiscount'];
    // commentIds = json['commentIds'];
    // visitCount = json['visitCount'];
    // avgRating = json['avgRating'];
    // codEnabledServiceLocations = json['codEnabledServiceLocations'];
    // totalRatingsRegistered = json['totalRatingsRegistered'];
    if (json['productBatches'] != dynamic) {
      productBatches = new List<ProductBatches>();
      json['productBatches'].forEach((v) {
        productBatches.add(new ProductBatches.fromJson(v));
      });
    }
    // priceRanges = json['priceRanges'];
    // masterImage = json['masterImage'];
    // discountRanges = json['discountRanges'];
    if (json['processedPriceAndStock'] != dynamic) {
      processedPriceAndStock = new List<ProcessedPriceAndStocks>();
      json['processedPriceAndStock'].forEach((v) {
        processedPriceAndStock.add(new ProcessedPriceAndStocks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['overview'] = this.overview;
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['activeCategory'] = this.activeCategory;
    data['videoURL'] = this.videoURL;
    data['productId'] = this.productId;
    data['nameNotAnalysed'] = this.nameNotAnalysed;
    data['vendorId'] = this.vendorId;
    data['isVendorBlocked'] = this.isVendorBlocked;
    data['vendorType'] = this.vendorType;
    data['vendor'] = this.vendor;
    data['vendorMobile'] = this.vendorMobile;
    data['active'] = this.active;
    data['isDraft'] = this.isDraft;
    data['isFeatured'] = this.isFeatured;
    data['status'] = this.status;
    // if (this.tags != dynamic) {
    //   data['tags'] = this.tags.map((v) => v.toJson()).toList();
    // }
    data['serviceLocations'] = this.serviceLocations;
    if (this.specifications != dynamic) {
      data['specifications'] =
          this.specifications.map((v) => v.toJson()).toList();
    }
    // if (this.videos != dynamic) {
    //   data['videos'] = this.videos.map((v) => v.toJson()).toList();
    // }
    data['images'] = this.images;
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['brandName'] = this.brandName;
    data['subCategory2Name'] = this.subCategory2Name;
    data['subCategory3Id'] = this.subCategory3Id;
    data['subCategory3Name'] = this.subCategory3Name;
    data['subCategory1Name'] = this.subCategory1Name;
    data['brandId'] = this.brandId;
    data['subCategory1Id'] = this.subCategory1Id;
    data['subCategory2Id'] = this.subCategory2Id;
    data['isCODEnabled'] = this.isCODEnabled;
    if (this.serviceLocationRequest != dynamic) {
      data['serviceLocationRequest'] = this.serviceLocationRequest.toJson();
    }
    // data['rating'] = this.rating;
    // data['hasVendorDiscount'] = this.hasVendorDiscount;
    // data['hasAdminDiscount'] = this.hasAdminDiscount;
    // data['commentIds'] = this.commentIds;
    // data['visitCount'] = this.visitCount;
    // data['avgRating'] = this.avgRating;
    // data['codEnabledServiceLocations'] = this.codEnabledServiceLocations;
    // data['totalRatingsRegistered'] = this.totalRatingsRegistered;
    if (this.productBatches != dynamic) {
      data['productBatches'] =
          this.productBatches.map((v) => v.toJson()).toList();
    }
    // data['priceRanges'] = this.priceRanges;
    // data['masterImage'] = this.masterImage;
    // data['discountRanges'] = this.discountRanges;
    if (this.processedPriceAndStock != dynamic) {
      data['processedPriceAndStock'] =
          this.processedPriceAndStock.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceLocationRequest {
  String country;
  List<String> pincode;
  List<String> district;
  List<String> state;

  ServiceLocationRequest(
      {this.country, this.pincode, this.district, this.state});

  ServiceLocationRequest.fromJson(Map<String, dynamic> json) {
    if (json['country'] != null || json['country'] != dynamic) {
      country = json['country'];
    } else {
      country = null;
    }
    pincode = json['pincode'].cast<String>();
    district = json['district'].cast<String>();
    state = json['state'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['pincode'] = this.pincode;
    data['district'] = this.district;
    data['state'] = this.state;
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
  dynamic sellingPrice;
  String quantity;
  dynamic price;
  int variant;
  dynamic discount;
  dynamic weightInKg;
  dynamic notificationPeriodForToBeExpiredBatch;
  dynamic dealerPrice;
  int stock;

  PriceAndStocks(
      {this.unit,
      this.sellingPrice,
      this.quantity,
      this.price,
      this.variant,
      this.discount,
      this.weightInKg,
      this.notificationPeriodForToBeExpiredBatch,
      this.dealerPrice,
      this.stock});

  PriceAndStocks.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    sellingPrice = json['sellingPrice'];
    quantity = json['quantity'];
    price = json['price'];
    variant = json['variant'];
    discount = json['discount'];
    weightInKg = json['weightInKg'];
    notificationPeriodForToBeExpiredBatch =
        json['notificationPeriodForToBeExpiredBatch'];
    dealerPrice = json['dealerPrice'];
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
    data['weightInKg'] = this.weightInKg;
    data['notificationPeriodForToBeExpiredBatch'] =
        this.notificationPeriodForToBeExpiredBatch;
    data['dealerPrice'] = this.dealerPrice;
    data['stock'] = this.stock;
    return data;
  }
}
