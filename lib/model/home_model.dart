import 'dart:convert';

class HomeModel {
  String status;
  String message;
  List<Sections> sections;

  HomeModel({this.status, this.message, this.sections});


  factory HomeModel.fromRawJson(String str) =>
      HomeModel.fromJson(json.decode(str));

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['sections'] != String) {
      sections = new List<Sections>();
      json['sections'].forEach((v) {
        sections.add(new Sections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.sections != String) {
      data['sections'] = this.sections.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sections {
  String sectionTitle;
  String sectionType;
  int sectionOrder;
  String sectionId;
  int version;
  List<SectionData> sectionData;
  String sectionTypeName;
  Conditions conditions;

  Sections(
      {this.sectionTitle,
      this.sectionType,
      this.sectionOrder,
      this.sectionId,
      this.version,
      this.sectionData,
      this.sectionTypeName,
      this.conditions});

  Sections.fromJson(Map<String, dynamic> json) {
    sectionTitle = json['sectionTitle'];
    sectionType = json['sectionType'];
    sectionOrder = json['sectionOrder'];
    sectionId = json['sectionId'];
    version = json['version'];
    if (json['sectionData'] != String) {
      sectionData = new List<SectionData>();
      json['sectionData'].forEach((v) {
        sectionData.add(new SectionData.fromJson(v));
      });
    }
    sectionTypeName = json['sectionTypeName'];
    conditions = json['conditions'] != String
        ? new Conditions.fromJson(json['conditions'])
        : String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sectionTitle'] = this.sectionTitle;
    data['sectionType'] = this.sectionType;
    data['sectionOrder'] = this.sectionOrder;
    data['sectionId'] = this.sectionId;
    data['version'] = this.version;
    if (this.sectionData != String) {
      data['sectionData'] = this.sectionData.map((v) => v.toJson()).toList();
    }
    data['sectionTypeName'] = this.sectionTypeName;
    if (this.conditions != String) {
      data['conditions'] = this.conditions.toJson();
    }
    return data;
  }
}

class SectionData {
  String bannerCategoryName;
  String image;
  BannerConditions bannerConditions;
  String bannerType;
  String bannerId;
  int lastModifiedDate;
  String bannerCategory;
  String popularCategoryId;
  String popularCategoryName;
  String categoryName;
  String categoryId;
  String index;
  String type;
  String id;
  int version;
  Source source;

  SectionData(
      {this.bannerCategoryName,
      this.image,
      this.bannerConditions,
      this.bannerType,
      this.bannerId,
      this.lastModifiedDate,
      this.bannerCategory,
      this.popularCategoryId,
      this.popularCategoryName,
      this.categoryName,
      this.categoryId,
      this.index,
      this.type,
      this.id,
      this.version,
      this.source});

  SectionData.fromJson(Map<String, dynamic> json) {
    bannerCategoryName = json['bannerCategoryName'];
    image = json['image'];
    bannerConditions = json['bannerConditions'] != String
        ? new BannerConditions.fromJson(json['bannerConditions'])
        : String;
    bannerType = json['bannerType'];
    bannerId = json['bannerId'];
    lastModifiedDate = json['lastModifiedDate'];
    bannerCategory = json['bannerCategory'];
    popularCategoryId = json['popularCategoryId'];
    popularCategoryName = json['popularCategoryName'];
    categoryName = json['categoryName'];
    categoryId = json['categoryId'];
    index = json['index'];
    type = json['type'];
    id = json['id'];
    version = json['version'];
    source =
        json['source'] != String ? new Source.fromJson(json['source']) : String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bannerCategoryName'] = this.bannerCategoryName;
    data['image'] = this.image;
    if (this.bannerConditions != String) {
      data['bannerConditions'] = this.bannerConditions.toJson();
    }
    data['bannerType'] = this.bannerType;
    data['bannerId'] = this.bannerId;
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['bannerCategory'] = this.bannerCategory;
    data['popularCategoryId'] = this.popularCategoryId;
    data['popularCategoryName'] = this.popularCategoryName;
    data['categoryName'] = this.categoryName;
    data['categoryId'] = this.categoryId;
    data['index'] = this.index;
    data['type'] = this.type;
    data['id'] = this.id;
    data['version'] = this.version;
    if (this.source != String) {
      data['source'] = this.source.toJson();
    }
    return data;
  }
}

class BannerConditions {
  HomeFilter filter;

  BannerConditions({this.filter});

  BannerConditions.fromJson(Map<String, dynamic> json) {
    filter =
        json['filter'] != String ? new HomeFilter.fromJson(json['filter']) : String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.filter != String) {
      data['filter'] = this.filter.toJson();
    }
    return data;
  }
}

class HomeFilter {
  List<HomeTerm> term;

  HomeFilter({this.term});

  HomeFilter.fromJson(Map<String, dynamic> json) {
    if (json['term'] != String) {
      term = new List<HomeTerm>();
      json['term'].forEach((v) {
        term.add(new HomeTerm.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.term != String) {
      data['term'] = this.term.map((v) => v.toJson()).toList();
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
  List<double> priceRanges;
  List<int> discountRanges;
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
    if (json['specifications'] != String) {
      specifications = new List<Specifications>();
      json['specifications'].forEach((v) {
        specifications.add(new Specifications.fromJson(v));
      });
    }
    tags = json['tags'].cast<String>();
    images = json['images'].cast<String>();
    masterImage = json['masterImage'];
    videos = json['videos'];
    videoURL = json['videoURL'];
    if (json['productBatches'] != String) {
      productBatches = new List<ProductBatches>();
      json['productBatches'].forEach((v) {
        productBatches.add(new ProductBatches.fromJson(v));
      });
    }
    priceRanges = json['priceRanges'].cast<double>();
    discountRanges = json['discountRanges'].cast<int>();
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
    serviceLocationRequest = json['serviceLocationRequest'] != String
        ? new ServiceLocationRequest.fromJson(json['serviceLocationRequest'])
        : String;
    lastModifiedDate = json['lastModifiedDate'];
    visitCount = json['visitCount'];
    status = json['status'];
    if (json['processedPriceAndStock'] != String) {
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
    if (this.specifications != String) {
      data['specifications'] =
          this.specifications.map((v) => v.toJson()).toList();
    }
    data['tags'] = this.tags;
    data['images'] = this.images;
    data['masterImage'] = this.masterImage;
    data['videos'] = this.videos;
    data['videoURL'] = this.videoURL;
    if (this.productBatches != String) {
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
    if (this.serviceLocationRequest != String) {
      data['serviceLocationRequest'] = this.serviceLocationRequest.toJson();
    }
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['visitCount'] = this.visitCount;
    data['status'] = this.status;
    if (this.processedPriceAndStock != String) {
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
    if (json['priceAndStocks'] != String) {
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
    if (this.priceAndStocks != String) {
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
  int price;
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
  int price;
  int discount;
  int stock;
  double sellingPrice;

  ProcessedPriceAndStock(
      {this.serialNumber,
      this.batchNumbers,
      this.variant,
      this.quantity,
      this.unit,
      this.price,
      this.discount,
      this.stock,
      this.sellingPrice});

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

class Conditions {
  HomeFilter filter;
  int offset;
  int size;

  Conditions({this.filter, this.offset, this.size});

  Conditions.fromJson(Map<String, dynamic> json) {
    filter =
        json['filter'] != String ? new HomeFilter.fromJson(json['filter']) : String;
    offset = json['offset'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.filter != String) {
      data['filter'] = this.filter.toJson();
    }
    data['offset'] = this.offset;
    data['size'] = this.size;
    return data;
  }
}

class HomeTerm {
  List<String> categoryId;
  List<String> brandId;
  List<String> subCategory1Id;

  HomeTerm({this.categoryId, this.brandId, this.subCategory1Id});

  HomeTerm.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'].cast<String>();
    brandId = json['brandId'].cast<String>();
    subCategory1Id = json['subCategory1Id'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['brandId'] = this.brandId;
    data['subCategory1Id'] = this.subCategory1Id;
    return data;
  }
}
