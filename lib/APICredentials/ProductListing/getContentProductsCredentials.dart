/*
 *  2021 Highrich.in
 */
class GetContentProductsCredentials {
  String sectionId;
  String type;
  int offset;
  int size;
  String sortBy;
  String sortType;
  bool hasRangeAndSort;
  bool forMobileApp;
  FilterCredentialsContent filter;
  GetContentProductsCredentials({this.sectionId, this.offset, this.size,this.filter,this.hasRangeAndSort,this.forMobileApp});

  GetContentProductsCredentials.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    sortBy = json['sortBy'];
    sortType = json['sortType'];
    hasRangeAndSort = json['hasRangeAndSort'];
    forMobileApp = json['forMobileApp'];
    sectionId = json['sectionId'];
    offset = json['offset'];
    size = json['size'];
    filter =
    json['filter'] != null ? new FilterCredentialsContent.fromJson(json['filter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['sortBy'] = this.sortBy;
    data['sortType'] = this.sortType;
    data['hasRangeAndSort'] = this.hasRangeAndSort;
    data['forMobileApp'] = this.forMobileApp;
    data['sectionId'] = this.sectionId;
    data['offset'] = this.offset;
    data['size'] = this.size;
    if (this.filter != null) {
      data['filter'] = this.filter.toJson();
    }
    return data;
  }
}

class FilterCredentialsContent {
 TermCredentialsContent term;

 RangeFilterContent range;

  FilterCredentialsContent({this.term,this.range});


  FilterCredentialsContent.fromJson(Map<String, dynamic> json) {
    term =
    json['term'] != null ? new TermCredentialsContent.fromJson(json['term']) : null;

    range =
    json['range'] != null ? new RangeFilterContent.fromJson(json['range']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.term != null) {
      print("-=-=-===================");
      data['term'] = this.term.toJson();
    }
    if (this.range != null) {
      data['range'] = this.range.toJson();
    }
    return data;
  }
}


class RangeFilterContent {
  PriceRangesContent priceRanges;
  OutOfStockGetContent outOfStock;

  RangeFilterContent({this.priceRanges,this.outOfStock});

  RangeFilterContent.fromJson(Map<String, dynamic> json) {
    priceRanges = json['priceRanges'] != null
        ? new PriceRangesContent.fromJson(json['priceRanges'])
        : null;

    outOfStock = json['outOfStock'] != null
        ? new OutOfStockGetContent.fromJson(json['outOfStock'])
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
class OutOfStockGetContent {
  String gte;

  OutOfStockGetContent({this.gte});

  OutOfStockGetContent.fromJson(Map<String, dynamic> json) {
    gte = json['gte'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gte'] = this.gte;
    return data;
  }
}


class PriceRangesContent {
  int gte;
  int lte;

  PriceRangesContent({this.gte, this.lte});

  PriceRangesContent.fromJson(Map<String, dynamic> json) {
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

class TermCredentialsContent {
  List<String> categoryId;
  List<String> subCategory1Id;
  List<String> subCategory0Id;
  List<String> subCategory2Id;
  List<String> subCategory3Id;
  List<String> brandId;
  List<String> serviceLocations;

  TermCredentialsContent({this.categoryId,this.subCategory1Id});

  TermCredentialsContent.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'].cast<String>();
    subCategory1Id = json['subCategory1Id'].cast<String>();
    subCategory0Id = json['subCategory0Id'].cast<String>();
    subCategory2Id = json['subCategory2Id'].cast<String>();
    subCategory3Id = json['subCategory3Id'].cast<String>();
    brandId = json['brandId'].cast<String>();
    serviceLocations = json['serviceLocations'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();


    if (this.categoryId != null) {
      data['categoryId'] = this.categoryId;
    }
    if (this.subCategory1Id != null) {
      data['subCategory1Id'] = this.subCategory1Id;
    }
    if (this.subCategory0Id != null) {
      data['subCategory0Id'] = this.subCategory0Id;
    }
    if (this.subCategory3Id != null) {
      data['subCategory3Id'] = this.subCategory3Id;
    }
    if (this.brandId != null) {
      data['brandId'] = this.brandId;
    }
    if (this.serviceLocations != null) {
      data['serviceLocations'] = this.serviceLocations;
    }
    return data;
  }
}