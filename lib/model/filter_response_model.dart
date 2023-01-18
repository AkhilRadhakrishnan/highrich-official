import 'dart:convert';

class FilterResponseModel {
  String status;
  String message;
  List<BrandFilter> brand;
  List<SubCategoryLevelZeroFilter> category;

  FilterResponseModel({this.status, this.message, this.brand, this.category});

  factory FilterResponseModel.fromRawJson(String str) =>
      FilterResponseModel.fromJson(json.decode(str));

  FilterResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['brand'] != null) {
      brand = new List<BrandFilter>();
      json['brand'].forEach((v) {
        brand.add(new BrandFilter.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = new List<SubCategoryLevelZeroFilter>();
      json['category'].forEach((v) {
        category.add(new SubCategoryLevelZeroFilter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.brand != null) {
      data['brand'] = this.brand.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BrandFilter {
  String brandId;
  String brandName;
  int count;

  BrandFilter({this.brandId, this.brandName, this.count});

  BrandFilter.fromJson(Map<String, dynamic> json) {
    brandId = json['brandId'];
    brandName = json['brandName'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandId'] = this.brandId;
    data['brandName'] = this.brandName;
    data['count'] = this.count;
    return data;
  }
}

class SubCategoryLevelZeroFilter {
  String id;
  String categoryName;
  int level;
  List<String> childCategoryId;
  List<SubCategoryLevelOneFilter> subCategories;

  SubCategoryLevelZeroFilter(
      {this.id,
        this.categoryName,
        this.level,
        this.childCategoryId,
        this.subCategories});

  SubCategoryLevelZeroFilter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    level = json['level'];
    childCategoryId = json['childCategoryId'].cast<String>();
    if (json['subCategories'] != null) {
      subCategories = new List<SubCategoryLevelOneFilter>();
      json['subCategories'].forEach((v) {
        subCategories.add(new SubCategoryLevelOneFilter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['level'] = this.level;
    data['childCategoryId'] = this.childCategoryId;
    if (this.subCategories != null) {
      data['subCategories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class SubCategoryLevelOneFilter {
  String id;
  String categoryName;
  int level;
  List<String> childCategoryId;
  List<SubCategoryLevelTwoFilter> subCategories;

  SubCategoryLevelOneFilter(
      {this.id,
        this.categoryName,
        this.level,
        this.childCategoryId,
        this.subCategories});

  SubCategoryLevelOneFilter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    level = json['level'];
    childCategoryId = json['childCategoryId'].cast<String>();
    if (json['subCategories'] != null) {
      subCategories = new List<SubCategoryLevelTwoFilter>();
      json['subCategories'].forEach((v) {
        subCategories.add(new SubCategoryLevelTwoFilter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['level'] = this.level;
    data['childCategoryId'] = this.childCategoryId;
    if (this.subCategories != null) {
      data['subCategories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoryLevelTwoFilter {
  String id;
  String categoryName;
  int level;
  List<String> childCategoryId;
  List<SubCategoryLevelThreeFilter> subCategories;

  SubCategoryLevelTwoFilter(
      {this.id,
        this.categoryName,
        this.level,
        this.childCategoryId,
        this.subCategories});

  SubCategoryLevelTwoFilter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    level = json['level'];
    childCategoryId = json['childCategoryId'].cast<String>();
    if (json['subCategories'] != null) {
      subCategories = new List<SubCategoryLevelThreeFilter>();
      json['subCategories'].forEach((v) {
        subCategories.add(new SubCategoryLevelThreeFilter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['level'] = this.level;
    data['childCategoryId'] = this.childCategoryId;
    if (this.subCategories != null) {
      data['subCategories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoryLevelThreeFilter {
  String categoryName;
//  List<String> brandIds;
  List<Null> topBrandIds;
  int level;
  //List<String> parentCategoryId;
  String categoryNameAnalyzed;
  bool active;
  int timeStamp;
  String id;

  int version;
  List<SubCategoryLevelFourFilter> subCategories;

  SubCategoryLevelThreeFilter({this.categoryName,
   // this.brandIds,
    this.topBrandIds,
    this.level,
 //   this.parentCategoryId,
    this.categoryNameAnalyzed,
    this.active,
    this.timeStamp,
    this.id,
    this.version,
    this.subCategories});

  SubCategoryLevelThreeFilter.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
   // brandIds = json['brandIds'].cast<String>();

    level = json['level'];
  //  parentCategoryId = json['parentCategoryId'].cast<String>();
    categoryNameAnalyzed = json['categoryNameAnalyzed'];
    active = json['active'];
    timeStamp = json['timeStamp'];
    id = json['id'];

    version = json['version'];

    if (json['subCategories'] != null) {
      subCategories = new List<SubCategoryLevelFourFilter>();
      json['subCategories'].forEach((v) {
        subCategories.add(new SubCategoryLevelFourFilter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
  //  data['brandIds'] = this.brandIds;

    data['level'] = this.level;
 //   data['parentCategoryId'] = this.parentCategoryId;
    data['categoryNameAnalyzed'] = this.categoryNameAnalyzed;
    data['active'] = this.active;
    data['timeStamp'] = this.timeStamp;
    data['id'] = this.id;

    data['version'] = this.version;


    if (this.subCategories != null) {
      data['subCategories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoryLevelFourFilter {
  String categoryName;
//  List<String> brandIds;
  //List<Null> topBrandIds;
  int level;
//  List<String> parentCategoryId;
  String categoryNameAnalyzed;
  bool active;
  int timeStamp;
  String id;
  int version;
  List<Null> topBrands;

  SubCategoryLevelFourFilter({this.categoryName,
  //  this.brandIds,
  //  this.topBrandIds,
    this.level,
   // this.parentCategoryId,
    this.categoryNameAnalyzed,
    this.active,
    this.timeStamp,
    this.id,
    this.version,
    this.topBrands});

  SubCategoryLevelFourFilter.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
  //  brandIds = json['brandIds'].cast<String>();

    level = json['level'];
 //   parentCategoryId = json['parentCategoryId'].cast<String>();
    categoryNameAnalyzed = json['categoryNameAnalyzed'];
    active = json['active'];
    timeStamp = json['timeStamp'];
    id = json['id'];
    version = json['version'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
 //   data['brandIds'] = this.brandIds;

    data['level'] = this.level;
  //  data['parentCategoryId'] = this.parentCategoryId;
    data['categoryNameAnalyzed'] = this.categoryNameAnalyzed;
    data['active'] = this.active;
    data['timeStamp'] = this.timeStamp;
    data['id'] = this.id;
    data['version'] = this.version;


    return data;
  }
}