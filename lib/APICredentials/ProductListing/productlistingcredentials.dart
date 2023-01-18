/*
 *  2021 Highrich.in
 */
class ProductListingCredentials {
  FilterCredentials filter;
  bool hasRangeAndSort;
  bool forMobileApp;
  String key;
  int offset;
  int size;
  String sortBy;
  String sortType;
  UserSearch userSearch;

  ProductListingCredentials(
      {this.filter,
        this.hasRangeAndSort,
        this.forMobileApp,
        this.key,
        this.offset,
        this.size,
        this.sortBy,
        this.sortType,
        this.userSearch});

  ProductListingCredentials.fromJson(Map<String, dynamic> json) {
    filter =
    json['filter'] != null ? new FilterCredentials.fromJson(json['filter']) : null;
    hasRangeAndSort = json['hasRangeAndSort'];
    forMobileApp = json['forMobileApp'];
    key = json['key'];
    offset = json['offset'];
    size = json['size'];
    sortBy = json['sortBy'];
    sortType = json['sortType'];
    userSearch = json['userSearch'] != null
        ? new UserSearch.fromJson(json['userSearch'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.filter != null) {
      data['filter'] = this.filter.toJson();
    }
    data['hasRangeAndSort'] = this.hasRangeAndSort;
    data['forMobileApp'] = this.forMobileApp;
    data['key'] = this.key;
    data['offset'] = this.offset;
    data['size'] = this.size;
    data['sortBy'] = this.sortBy;
    data['sortType'] = this.sortType;
    if (this.userSearch != null) {
      data['userSearch'] = this.userSearch.toJson();
    }
    return data;
  }
}

class FilterCredentials {
  RangeFilter range;
  TermCredentials term;

  FilterCredentials({this.range, this.term});

  FilterCredentials.fromJson(Map<String, dynamic> json) {
    term =
    json['term'] != null ? new TermCredentials.fromJson(json['term']) : null;

    range =
    json['range'] != null ? new RangeFilter.fromJson(json['range']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.term != null) {
      data['term'] = this.term.toJson();
    }
    if (this.range != null) {
      data['range'] = this.range.toJson();
    }
    return data;
  }
}

class RangeFilter {
  PriceRanges priceRanges;
  OutOfStockProduct outOfStock;

  RangeFilter({this.priceRanges, this.outOfStock});

  RangeFilter.fromJson(Map<String, dynamic> json) {
    priceRanges = json['priceRanges'] != null
        ? new PriceRanges.fromJson(json['priceRanges'])
        : null;
    outOfStock = json['outOfStock'] != null
        ? new OutOfStockProduct.fromJson(json['outOfStock'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.priceRanges != null) {
      data['priceRanges'] = this.priceRanges.toJson();
    }
    if (this.outOfStock != null) {
      data['outOfStock'] = this.outOfStock.toJson();
    }
    return data;
  }
}

class PriceRanges {
  int gte;
  int lte;

  PriceRanges({this.gte, this.lte});

  PriceRanges.fromJson(Map<String, dynamic> json) {
    if(json['gte']!=null)
      {
        gte = json['gte'];
      }
    if(json['lte']!=null)
    {
      lte = json['lte'];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.gte!=null)
      {
        data['gte'] = this.gte;
      }
    if(this.lte!=null)
    {
      data['lte'] = this.lte;
    }

    return data;
  }
}

class OutOfStockProduct {
  String gte;

  OutOfStockProduct({this.gte});

  OutOfStockProduct.fromJson(Map<String, dynamic> json) {
    gte = json['gte'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gte'] = this.gte;
    return data;
  }
}

class TermCredentials {
  List<String> categoryId;
  List<String> serviceLocations;
  List<String> subCategory0Id;
  List<String> subCategory1Id;
  List<String> subCategory2Id;
  List<String> subCategory3Id;
  List<String> brandId;
  List<String> vendorId;

  TermCredentials({this.categoryId, this.serviceLocations});

  TermCredentials.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'].cast<String>();
    serviceLocations = json['serviceLocations'].cast<String>();
    subCategory0Id = json['subCategory0Id'].cast<String>();
    subCategory1Id = json['subCategory1Id'].cast<String>();
    subCategory2Id = json['subCategory2Id'].cast<String>();
    subCategory3Id = json['subCategory3Id'].cast<String>();
    brandId = json['brandId'].cast<String>();
    vendorId = json['vendorId'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoryId != null) {
      data['categoryId'] = this.categoryId;
    }
    if (this.subCategory0Id != null) {
      data['subCategory0Id'] = this.subCategory0Id;
    }
    if (this.subCategory1Id != null) {
      data['subCategory1Id'] = this.subCategory1Id;
    }
    if (this.subCategory2Id != null) {
      data['subCategory2Id'] = this.subCategory2Id;
    }
    if (this.subCategory3Id != null) {
      data['subCategory3Id'] = this.subCategory3Id;
    }
    if (this.serviceLocations != null) {
      data['serviceLocations'] = this.serviceLocations;
    }
    if (this.brandId != null) {
      data['brandId'] = this.brandId;
    }
    if (this.vendorId != null) {
      data['vendorId'] = this.vendorId;
    }
    return data;
  }
}

class UserSearch {
  String key;
  String pinCode;

  UserSearch({this.key, this.pinCode});

  UserSearch.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    pinCode = json['pinCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['pinCode'] = this.pinCode;
    return data;
  }
}