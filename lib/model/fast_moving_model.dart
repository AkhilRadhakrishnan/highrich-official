import 'dart:convert';

class FastMovingModel{
  String status;
  String parentCategoryId;
  String parentCategoryName;
  List<SubCategory> subCategories;

    factory FastMovingModel.fromRawJson(String str) =>
      FastMovingModel.fromJson(json.decode(str));

  FastMovingModel(
    this.status,
    this.parentCategoryId,
    this.parentCategoryName,
    this.subCategories
  );

  FastMovingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    parentCategoryId = json['parentCategoryId'];
    parentCategoryName = json['parentCategoryName'];
    if (json['subCategories'] != null) {
      subCategories = new List<SubCategory>();
      json['subCategories'].forEach((v) {
        subCategories.add(new SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['parentCategoryId'] = this.parentCategoryId;
    data['parentCategoryName'] = this.parentCategoryName;
    if (this.subCategories != null) {
      data['subCategories'] = this.subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategory{
  String subCategory0Id;
  String subCategory0Name;
  List<SectionDataFast> sectionData;
  Advertisements advertisements;


   SubCategory(
    this.subCategory0Id,
    this.subCategory0Name,
    this.sectionData,
    this.advertisements
  );

  SubCategory.fromJson(Map<String, dynamic> json) {
    subCategory0Id = json['subCategory0Id'];
    subCategory0Name = json['subCategory0Name'];
    if (json['sectionData'] != null) {
      sectionData = new List<SectionDataFast>();
      json['sectionData'].forEach((v) {
        sectionData.add(new SectionDataFast.fromJson(v));
      });
    }
    advertisements =
    json['advertisements'] != null ? new Advertisements.fromJson(json['advertisements']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subCategory0Id'] = this.subCategory0Id;
    data['subCategory0Name'] = this.subCategory0Name;
    if (this.sectionData != null) {
      data['sectionData'] =
          this.sectionData.map((v) => v.toJson()).toList();
    }
    if (this.advertisements != null) {
      data['advertisements'] = this.advertisements.toJson();
    }
    return data;
  }

}

class Advertisements{
  bool active;
  // String lastModifiedDate;
  String categoryId;
  String subCategoryId;
  List<AdvertisementBanner> advertisementBanner;
  List<AdvertisementCard> advertisementCard;

  Advertisements(
    {this.active,
    this.categoryId,
    // this.lastModifiedDate,
    this.subCategoryId,
    this.advertisementBanner,
    this.advertisementCard
    }
  );

  Advertisements.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    categoryId = json['categoryId'];
    // lastModifiedDate = json['lastModifiedDate'];
    subCategoryId = json['subCategoryId'];
    if (json['advertisementBanner'] != null) {
      advertisementBanner = new List<AdvertisementBanner>();
      json['advertisementBanner'].forEach((v) {
        advertisementBanner.add(new AdvertisementBanner.fromJson(v));
      });
    }
    if (json['advertisementCard'] != null) {
      advertisementCard = new List<AdvertisementCard>();
      json['advertisementCard'].forEach((v) {
        advertisementCard.add(new AdvertisementCard.fromJson(v));
      });
    }
    
  }
  factory Advertisements.fromRawJson(String str) =>
      Advertisements.fromJson(json.decode(str));
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['categoryId'] = this.categoryId;
    data['subCategoryId'] = this.subCategoryId;
    // data['lastModifiedDate'] = this.lastModifiedDate;
    if (this.advertisementBanner != null) {
      data['advertisementBanner'] =
          this.advertisementBanner.map((v) => v.toJson()).toList();
    }
    if (this.advertisementCard != null) {
      data['advertisementCard'] =
          this.advertisementCard.map((v) => v.toJson()).toList();
    }
     return data;
  }

}

class AdvertisementBanner{
  List<String> images;
  bool makeDefault;
  String bannerId;
  // DateRange dateRange;
  String orderBy;
  int clicks;
  String id;
  String advertisementType;
  bool isActive;
  String imageType;
  int views;
  // String timestamp;

  AdvertisementBanner({
    this.advertisementType,
    this.bannerId,
    this.clicks,
    this.id,
    this.imageType,
    this.images,
    this.isActive,
    this.makeDefault,
    this.orderBy,
    // this.timestamp,
    this.views
  });

  AdvertisementBanner.fromJson(Map<String, dynamic> json) {
    makeDefault = json['makeDefault'];
    views = json['views'];
    id = json['id'];
    isActive = json['isActive'];
    imageType = json['imageType'];
    // timestamp = json['timestamp'];
    advertisementType = json['advertisementType'];
    bannerId = json['bannerId'];
    clicks = json['clicks'];
    orderBy = json['orderBy'];
    images = json['images'].cast<String>();
  }
  factory AdvertisementBanner.fromRawJson(String str) =>
      AdvertisementBanner.fromJson(json.decode(str));
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['makeDefault'] = this.makeDefault;
    data['views'] = this.views;
    data['id'] = this.id;
    data['isActive'] = this.isActive;
    data['imageType'] = this.imageType;
    // data['timestamp'] = this.timestamp;
    data['advertisementType'] = this.advertisementType;
    data['bannerId'] = this.bannerId;
    data['clicks'] = this.clicks;
    data['orderBy'] = this.orderBy;
    data['images'] = this.images;
     return data;

  }
}

class AdvertisementCard{
  List<String> images;
  bool makeDefault;
  String cardId;
  // DateRange dateRange;
  String orderBy;
  int clicks;
  String id;
  String advertisementType;
  bool isActive;
  String imageType;
  int views;
  // String timestamp;

  AdvertisementCard({
    this.advertisementType,
    this.cardId,
    this.clicks,
    this.id,
    this.imageType,
    this.images,
    this.isActive,
    this.makeDefault,
    this.orderBy,
    // this.timestamp,
    this.views
  });

  AdvertisementCard.fromJson(Map<String, dynamic> json) {
    makeDefault = json['makeDefault'];
    views = json['views'];
    id = json['id'];
    isActive = json['isActive'];
    imageType = json['imageType'];
    // timestamp = json['timestamp'];
    advertisementType = json['advertisementType'];
    cardId = json['bannerId'];
    clicks = json['clicks'];
    orderBy = json['orderBy'];
    images = json['images'].cast<String>();
  }
  factory AdvertisementCard.fromRawJson(String str) =>
      AdvertisementCard.fromJson(json.decode(str));
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['makeDefault'] = this.makeDefault;
    data['views'] = this.views;
    data['id'] = this.id;
    data['isActive'] = this.isActive;
    data['imageType'] = this.imageType;
    // data['timestamp'] = this.timestamp;
    data['advertisementType'] = this.advertisementType;
    data['bannerId'] = this.cardId;
    data['clicks'] = this.clicks;
    data['orderBy'] = this.orderBy;
    data['images'] = this.images;
     return data;
  }
}
 
 class SectionDataFast {
  String index;
  String type;
  String id;
  int version;
  Source source;

  SectionDataFast(
      {this.index, this.type, this.id, this.version, this.source});

  SectionDataFast.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    type = json['type'];
    id = json['id'];
    version = json['version'];
    source =
    json['source'] != null ? new Source.fromJson(json['source']) : null;
  }
  factory SectionDataFast.fromRawJson(String str) =>
      SectionDataFast.fromJson(json.decode(str));
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

class Source {
  String productId;
  String name;
  String nameNotAnalysed;
  String overview;
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
  double price;
  double discount;
  int stock;
  double salesIncentive;
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
        this.sellingPrice, this.salesIncentive});

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

