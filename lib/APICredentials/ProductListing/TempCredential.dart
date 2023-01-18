/*
 *  2021 Highrich.in
 */
class TempCredentials {
  String key;
  String type;
  int offset;
  int size;
  FilterTempCredentials filter;

  TempCredentials({this.key,this.type, this.offset, this.size, this.filter});

  TempCredentials.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    type = json['type'];
    offset = json['offset'];
    size = json['size'];
    filter =
    json['filter'] != null ? new FilterTempCredentials.fromJson(json['filter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;

    data['offset'] = this.offset;
    data['size'] = this.size;
    if (this.type != null) {
      data['type'] = this.type;
    }
    if (this.filter != null) {
      data['filter'] = this.filter.toJson();
    }
    return data;
  }
}

class FilterTempCredentials {
  List<TermCredentialsTemp> term;

  List<RangeTempFilter> range;

  FilterTempCredentials({this.term,this.range});

  FilterTempCredentials.fromJson(Map<String, dynamic> json) {
    if (json['term'] != null) {
      term = new List<TermCredentialsTemp>();
      json['term'].forEach((v) {
        term.add(new TermCredentialsTemp.fromJson(v));
      });
    }

    if (json['range'] != null) {
      range = new List<RangeTempFilter>();
      json['range'].forEach((v) {
        range.add(new RangeTempFilter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.term != null) {
      data['term'] = this.term.map((v) => v.toJson()).toList();
    }
    if (this.range != null) {
      data['range'] = this.range.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class RangeTempFilter {
  PriceRangesTemp priceRanges;

  RangeTempFilter({this.priceRanges});

  RangeTempFilter.fromJson(Map<String, dynamic> json) {
    priceRanges = json['priceRanges'] != null
        ? new PriceRangesTemp.fromJson(json['priceRanges'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.priceRanges != null) {
      data['priceRanges'] = this.priceRanges.toJson();
    }
    return data;
  }
}

class PriceRangesTemp {
  String gte;
  String lte;

  PriceRangesTemp({this.gte, this.lte});

  PriceRangesTemp.fromJson(Map<String, dynamic> json) {
    gte = json['gte'];
    lte = json['lte'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gte'] = this.gte;
    data['lte'] = this.lte;
    return data;
  }
}

class TermCredentialsTemp {
  List<String> categoryId;
  List<String> subCategory1Id;
  List<String> subCategory2Id;
  List<String> subCategory3Id;
  List<String> brandId;

  TermCredentialsTemp({this.categoryId,this.subCategory1Id});

  TermCredentialsTemp.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'].cast<String>();
    subCategory1Id = json['subCategory1Id'].cast<String>();
    subCategory2Id = json['subCategory2Id'].cast<String>();
    subCategory3Id = json['subCategory3Id'].cast<String>();
    brandId = json['brandId'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();


    if (this.categoryId != null) {
      data['categoryId'] = this.categoryId;
    }
    if (this.subCategory1Id != null) {
      data['subCategory1Id'] = this.subCategory1Id;
    }
    if (this.subCategory3Id != null) {
      data['subCategory3Id'] = this.subCategory3Id;
    }
    if (this.brandId != null) {
      data['brandId'] = this.brandId;
    }
    return data;
  }
}