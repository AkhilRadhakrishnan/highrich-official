import 'dart:convert';

class HomeProductsSectionsModel {
  String sectionTitle;
  String sectionType;
  String sectionTypeName;
  int sectionOrder;
  Conditions conditions;
  String sectionId;
  int version;
  List<SectionDataProducts> sectionData;
  // List<SectionData> bannerData;
  

  factory HomeProductsSectionsModel.fromRawJson(String str) =>
      HomeProductsSectionsModel.fromJson(json.decode(str));

  HomeProductsSectionsModel(
      {this.sectionTitle,
        this.sectionType,
        this.sectionTypeName,
        this.sectionOrder,
        this.conditions,
        this.sectionId,
        this.version,
        this.sectionData,
        // this.bannerData
        });

  HomeProductsSectionsModel.fromJson(Map<String, dynamic> json) {
    sectionTitle = json['sectionTitle'];
    sectionType = json['sectionType'];
    sectionTypeName = json['sectionTypeName'];
    sectionOrder = json['sectionOrder'];
    conditions = json['conditions'] != null
        ? new Conditions.fromJson(json['conditions'])
        : null;
    sectionId = json['sectionId'];
    version = json['version'];
    if (json['sectionData'] != null) {
      sectionData = new List<SectionDataProducts>();
      json['sectionData'].forEach((v) {
        sectionData.add(new SectionDataProducts.fromJson(v));
      });
    }
    // if (json['bannerData'] != null) {
    //   bannerData = new List<SectionData>();
    //   json['bannerData'].forEach((v) {
    //     bannerData.add(new SectionData.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sectionTitle'] = this.sectionTitle;
    data['sectionType'] = this.sectionType;
    data['sectionTypeName'] = this.sectionTypeName;
    data['sectionOrder'] = this.sectionOrder;
    if (this.conditions != null) {
      data['conditions'] = this.conditions.toJson();
    }
    data['sectionId'] = this.sectionId;
    data['version'] = this.version;
    if (this.sectionData != null) {
      data['sectionData'] = this.sectionData.map((v) => v.toJson()).toList();
    }
    // if (this.bannerData != null) {
    //   data['bannerData'] = this.bannerData.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
// class SectionData {
//   String bannerCategoryName;
//   String image;
//   // BannerConditions bannerConditions;
//   String bannerType;
//   String bannerId;

//   String bannerCategory;

//   SectionData(
//       {this.bannerCategoryName,
//         this.image,
//         // this.bannerConditions,
//         this.bannerType,
//         this.bannerId,
//         this.bannerCategory});

//   SectionData.fromJson(Map<String, dynamic> json) {
//     bannerCategoryName = json['bannerCategoryName'];
//     image = json['image'];
//     // bannerConditions = json['bannerConditions'] != null
//     //     ? new BannerConditions.fromJson(json['bannerConditions'])
//     //     : null;
//     bannerType = json['bannerType'];
//     bannerId = json['bannerId'];
//     bannerCategory = json['bannerCategory'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['bannerCategoryName'] = this.bannerCategoryName;
//     data['image'] = this.image;
//     // if (this.bannerConditions != null) {
//     //   data['bannerConditions'] = this.bannerConditions.toJson();
//     // }
//     data['bannerType'] = this.bannerType;
//     data['bannerId'] = this.bannerId;
//     data['bannerCategory'] = this.bannerCategory;
//     return data;
//   }
// }

class Conditions {

  int offset;
  int size;

  Conditions({this.offset, this.size});

  Conditions.fromJson(Map<String, dynamic> json) {

    offset = json['offset'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = this.offset;
    data['size'] = this.size;
    return data;
  }
}





class SectionDataProducts {
  String index;
  String type;
  String id;
  int version;
  String image;
  Source source;

  SectionDataProducts({this.index, this.type, this.id, this.version, this.source});

  SectionDataProducts.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    type = json['type'];
    id = json['id'];
    image = json['image'];
    version = json['version'];
    source =
    json['source'] != null ? new Source.fromJson(json['source']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['type'] = this.type;
    data['id'] = this.id;
    data['image'] = this.image;
    data['version'] = this.version;
    if (this.source != null) {
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
  List<Specifications> specifications;
  List<String> tags;
  List<String> images;
  String masterImage;
  String videos;
  String videoURL;
  List<ProductBatches> productBatches;
  List<dynamic> priceRanges;
  List<dynamic> discountRanges;
  String hasVendorDiscount;
  String hasAdminDiscount;
  bool active;
  bool isDraft;
  String isFeatured;
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
  String rating;
  String avgRating;
  String totalRatingsRegistered;
  String commentIds;
  bool isCODEnabled;
  List<String> serviceLocations;
  String codEnabledServiceLocations;
  ServiceLocationRequest serviceLocationRequest;
  int lastModifiedDate;
  String visitCount;
  String status;
  List<ProcessedPriceAndStock> processedPriceAndStock;

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
        this.productBatches,
        this.priceRanges,
        this.discountRanges,
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
    if (json['specifications'] != null) {
      specifications = new List<Specifications>();
      json['specifications'].forEach((v) {
        specifications.add(new Specifications.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      tags = json['tags'].cast<String>();
    }
    images = json['images'].cast<String>();
    masterImage = json['masterImage'];
    videos = json['videos'];
    videoURL = json['videoURL'];
    if (json['productBatches'] != null) {
      productBatches = new List<ProductBatches>();
      json['productBatches'].forEach((v) {
        productBatches.add(new ProductBatches.fromJson(v));
      });
    }
    if (json['priceRanges'] != null) {
      priceRanges = json['priceRanges'].cast<double>();
    }
    if (json['discountRanges'] != null) {
      discountRanges = json['discountRanges'].cast<int>();
    }

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
    if (json['processedPriceAndStock'] != null) {
      processedPriceAndStock = new List<ProcessedPriceAndStock>();
      json['processedPriceAndStock'].forEach((v) {
        processedPriceAndStock.add(new ProcessedPriceAndStock.fromJson(v));
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
    if (this.productBatches != null) {
      data['productBatches'] =
          this.productBatches.map((v) => v.toJson()).toList();
    }
    data['priceRanges'] = this.priceRanges;
    data['discountRanges'] = this.discountRanges;
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

class Specifications {
  String value;
  String key;

  Specifications({this.value, this.key});

  Specifications.fromJson(Map<String, dynamic> json) {
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

class ProductBatches {
  int addedDate;
  List<PriceAndStocks> priceAndStocks;
  String type;
  String batchNumber;

  ProductBatches(
      {this.addedDate, this.priceAndStocks, this.type, this.batchNumber});

  ProductBatches.fromJson(Map<String, dynamic> json) {
    addedDate = json['addedDate'];
    if (json['priceAndStocks'] != null) {
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
    if (this.priceAndStocks != null) {
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

class ProcessedPriceAndStock {
  int serialNumber;
  List<String> batchNumbers;
  int variant;
  String quantity;
  String unit;
  double price;
  double discount;
  int stock;
  double sellingPrice;
  double salesIncentive;

  ProcessedPriceAndStock(
      {this.serialNumber,
        this.batchNumbers,
        this.variant,
        this.quantity,
        this.unit,
        this.price,
        this.discount,
        this.stock,
        this.sellingPrice,
      this.salesIncentive});

  ProcessedPriceAndStock.fromJson(Map<String, dynamic> json) {
    serialNumber = json['serialNumber'];
    batchNumbers = json['batchNumbers'].cast<String>();
    variant = json['variant'];
    quantity = json['quantity'];
    unit = json['unit'];
    price = json['price'];
    discount = json['discount'];
    stock = json['stock'];
    sellingPrice = json['sellingPrice'];
    salesIncentive = json['salesIncentive'];
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
    data['salesIncentive'] = this.salesIncentive;
    return data;
  }
}