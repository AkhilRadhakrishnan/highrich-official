import 'dart:convert';

class CategoryModel {
  
  String status;
  String message;
  int count;
  List<SubCategoryLevelMinusOne> documents;

  factory CategoryModel.fromRawJson(String str) =>
      CategoryModel.fromJson(json.decode(str));


  CategoryModel(
      {this.status, this.message, this.count, this.documents});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['documents'] != null) {
      documents = new List<SubCategoryLevelMinusOne>();
      json['documents'].forEach((v) {
        documents.add(new SubCategoryLevelMinusOne.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['count'] = this.count;
    if (this.documents != null) {
      data['documents'] = this.documents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class SubCategoryLevelMinusOne {
  String categoryName;
  int level;
  String categoryNameAnalyzed;
  bool active;
  int timeStamp;
  String id;
  String image;
  
  int version;
  List<SubCategoryLevelZero> subCategories;

  SubCategoryLevelMinusOne({this.categoryName,
    this.level,
    this.categoryNameAnalyzed,
    this.active,
    this.timeStamp,
    this.id,
    this.version,
    this.image,
    this.subCategories});

  SubCategoryLevelMinusOne.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    level = json['level'];
    categoryNameAnalyzed = json['categoryNameAnalyzed'];
    active = json['active'];
    timeStamp = json['timeStamp'];
    id = json['id'];
    image = json['image'];
    version = json['version'];
    if (json['subCategories'] != null) {
      subCategories = new List<SubCategoryLevelZero>();
      json['subCategories'].forEach((v) {
        subCategories.add(new SubCategoryLevelZero.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    data['level'] = this.level;
    data['categoryNameAnalyzed'] = this.categoryNameAnalyzed;
    data['active'] = this.active;
    data['timeStamp'] = this.timeStamp;
    data['id'] = this.id;
    data['id'] = this.image;
    data['version'] = this.version;
    if (this.subCategories != null) {
      data['subCategories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoryLevelZero {
  String categoryName;
  List<String> brandIds;
  List<String> topBrandIds;
  int level;
  List<String> parentCategoryId;
  String categoryNameAnalyzed;
  bool active;
  int timeStamp;
  String id;
  
  int version;
  List<Brands> brands;
  List<SubCategoryLevelOne> subCategories;

  SubCategoryLevelZero({this.categoryName,
    this.brandIds,
    this.topBrandIds,
    this.level,
    this.parentCategoryId,
    this.categoryNameAnalyzed,
    this.active,
    this.timeStamp,
    this.id,
    this.version,
    this.brands,
    this.subCategories});

  SubCategoryLevelZero.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    if(json['brandIds']!=null)
      {
        brandIds = json['brandIds'].cast<String>();
      }

    topBrandIds = json['topBrandIds'].cast<String>();
    level = json['level'];
    parentCategoryId = json['parentCategoryId'].cast<String>();
    categoryNameAnalyzed = json['categoryNameAnalyzed'];
    active = json['active'];
    timeStamp = json['timeStamp'];
    id = json['id'];
    version = json['version'];
    if (json['brands'] != null) {
      brands = new List<Brands>();
      json['brands'].forEach((v) {
        brands.add(new Brands.fromJson(v));
      });
    }
    if (json['subCategories'] != null) {
      subCategories = new List<SubCategoryLevelOne>();
      json['subCategories'].forEach((v) {
        subCategories.add(new SubCategoryLevelOne.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    if(this.brandIds!=null)
      {
        data['brandIds'] = this.brandIds;
      }

    data['topBrandIds'] = this.topBrandIds;
    data['level'] = this.level;
    data['parentCategoryId'] = this.parentCategoryId;
    data['categoryNameAnalyzed'] = this.categoryNameAnalyzed;
    data['active'] = this.active;
    data['timeStamp'] = this.timeStamp;
    data['id'] = this.id;
   
    data['version'] = this.version;
    if (this.brands != null) {
      data['brands'] = this.brands.map((v) => v.toJson()).toList();
    }

    if (this.subCategories != null) {
      data['subCategories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoryLevelOne {
  String categoryName;
  List<String> brandIds;
  List<String> topBrandIds;
  int level;
  String categoryNameAnalyzed;
  bool active;
  int timeStamp;
  String id;
  
  int version;
  List<Brands> brands;
  List<SubCategoryLevelTwo> subCategories;

  SubCategoryLevelOne({this.categoryName,
    this.brandIds,
    this.topBrandIds,
    this.level,
    this.categoryNameAnalyzed,
    this.active,
    this.timeStamp,
    this.id,
   
    this.version,
    this.brands,
    this.subCategories});

  SubCategoryLevelOne.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    if(json['brandIds']!=null)
      {
        brandIds = json['brandIds'].cast<String>();
      }

    topBrandIds = json['topBrandIds'].cast<String>();
    level = json['level'];
    categoryNameAnalyzed = json['categoryNameAnalyzed'];
    active = json['active'];
    timeStamp = json['timeStamp'];
    id = json['id'];
    
    version = json['version'];
    if (json['brands'] != null) {
      brands = new List<Brands>();
      json['brands'].forEach((v) {
        brands.add(new Brands.fromJson(v));
      });
    }

    if (json['subCategories'] != null) {
      subCategories = new List<SubCategoryLevelTwo>();
      json['subCategories'].forEach((v) {
        subCategories.add(new SubCategoryLevelTwo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    if(this.brandIds!=null)
      {
        data['brandIds'] = this.brandIds;
      }
    data['topBrandIds'] = this.topBrandIds;
    data['level'] = this.level;
    data['categoryNameAnalyzed'] = this.categoryNameAnalyzed;
    data['active'] = this.active;
    data['timeStamp'] = this.timeStamp;
    data['id'] = this.id;
   
    data['version'] = this.version;
    if (this.brands != null) {
      data['brands'] = this.brands.map((v) => v.toJson()).toList();
    }

    if (this.subCategories != null) {
      data['subCategories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Brands {
  String brandId;
  String brandName;
  Null avgRating;
  String image;
  bool popularBrand;
  bool block;
  bool isArchived;
  int lastModifiedDate;
  bool topBrand;

  Brands({this.brandId,
    this.brandName,
    this.avgRating,
    this.image,
    this.popularBrand,
    this.block,
    this.isArchived,
    this.lastModifiedDate,
    this.topBrand});

  Brands.fromJson(Map<String, dynamic> json) {
    brandId = json['brandId'];
    brandName = json['brandName'];
    avgRating = json['avgRating'];
    image = json['image'];
    popularBrand = json['popularBrand'];
    block = json['block'];
    isArchived = json['isArchived'];
    lastModifiedDate = json['lastModifiedDate'];
    topBrand = json['topBrand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandId'] = this.brandId;
    data['brandName'] = this.brandName;
    data['avgRating'] = this.avgRating;
    data['image'] = this.image;
    data['popularBrand'] = this.popularBrand;
    data['block'] = this.block;
    data['isArchived'] = this.isArchived;
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['topBrand'] = this.topBrand;
    return data;
  }
}

class SubCategoryLevelTwo {
  String categoryName;
  List<String> brandIds;
  List<String> topBrandIds;
  int level;
  List<String> parentCategoryId;
  String categoryNameAnalyzed;
  bool active;
  int timeStamp;
  String id;
  
  int version;
  List<Brands> brands;
  List<SubCategoryLevelThree> subCategories;

  SubCategoryLevelTwo({this.categoryName,
    this.brandIds,
    this.topBrandIds,
    this.level,
    this.parentCategoryId,
    this.categoryNameAnalyzed,
    this.active,
    this.timeStamp,
    this.id,
    this.version,
    this.brands,
    this.subCategories});

  SubCategoryLevelTwo.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    if(json['brandIds']!=null)
      {
        brandIds = json['brandIds'].cast<String>();
      }

    topBrandIds = json['topBrandIds'].cast<String>();
    level = json['level'];
    parentCategoryId = json['parentCategoryId'].cast<String>();
    categoryNameAnalyzed = json['categoryNameAnalyzed'];
    active = json['active'];
    timeStamp = json['timeStamp'];
    id = json['id'];
    version = json['version'];
    if (json['brands'] != null) {
      brands = new List<Brands>();
      json['brands'].forEach((v) {
        brands.add(new Brands.fromJson(v));
      });
    }
    if (json['subCategories'] != null) {
      subCategories = new List<SubCategoryLevelThree>();
      json['subCategories'].forEach((v) {
        subCategories.add(new SubCategoryLevelThree.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    if(this.brandIds!=null)
      {
        data['brandIds'] = this.brandIds;
      }

    data['topBrandIds'] = this.topBrandIds;
    data['level'] = this.level;
    data['parentCategoryId'] = this.parentCategoryId;
    data['categoryNameAnalyzed'] = this.categoryNameAnalyzed;
    data['active'] = this.active;
    data['timeStamp'] = this.timeStamp;
    data['id'] = this.id;
   
    data['version'] = this.version;
    if (this.brands != null) {
      data['brands'] = this.brands.map((v) => v.toJson()).toList();
    }

    if (this.subCategories != null) {
      data['subCategories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoryLevelThree {
  String categoryName;
  List<String> brandIds;
  List<Null> topBrandIds;
  int level;
  List<String> parentCategoryId;
  String categoryNameAnalyzed;
  bool active;
  int timeStamp;
  String id;
  
  int version;
  List<Brands> brands;
  List<SubCategoryLevelFour> subCategories;

  SubCategoryLevelThree({this.categoryName,
    this.brandIds,
    this.topBrandIds,
    this.level,
    this.parentCategoryId,
    this.categoryNameAnalyzed,
    this.active,
    this.timeStamp,
    this.id,
   
    this.version,
    this.brands,
    this.subCategories});

  SubCategoryLevelThree.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    if(json['brandIds']!=null)
      {
        brandIds = json['brandIds'].cast<String>();
      }
    level = json['level'];
    parentCategoryId = json['parentCategoryId'].cast<String>();
    categoryNameAnalyzed = json['categoryNameAnalyzed'];
    active = json['active'];
    timeStamp = json['timeStamp'];
    id = json['id'];
    
    version = json['version'];
    if (json['brands'] != null) {
      brands = new List<Brands>();
      json['brands'].forEach((v) {
        brands.add(new Brands.fromJson(v));
      });
    }
    if (json['subCategories'] != null) {
      subCategories = new List<SubCategoryLevelFour>();
      json['subCategories'].forEach((v) {
        subCategories.add(new SubCategoryLevelFour.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    if(this.brandIds!=null)
      {
        data['brandIds'] = this.brandIds;
      }
    data['level'] = this.level;
    data['parentCategoryId'] = this.parentCategoryId;
    data['categoryNameAnalyzed'] = this.categoryNameAnalyzed;
    data['active'] = this.active;
    data['timeStamp'] = this.timeStamp;
    data['id'] = this.id;
   
    data['version'] = this.version;
    if (this.brands != null) {
      data['brands'] = this.brands.map((v) => v.toJson()).toList();
    }

    if (this.subCategories != null) {
      data['subCategories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoryLevelFour {
  String categoryName;
  List<String> brandIds;
  List<Null> topBrandIds;
  int level;
  List<String> parentCategoryId;
  String categoryNameAnalyzed;
  bool active;
  int timeStamp;
  String id;
  int version;
  List<Brands> brands;
  List<Null> topBrands;

  SubCategoryLevelFour({this.categoryName,
    this.brandIds,
    this.topBrandIds,
    this.level,
    this.parentCategoryId,
    this.categoryNameAnalyzed,
    this.active,
    this.timeStamp,
    this.id,
    this.version,
    this.brands,
    this.topBrands});

  SubCategoryLevelFour.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    if(json['brandIds']!=null)
      {
        brandIds = json['brandIds'].cast<String>();
      }
    level = json['level'];
    parentCategoryId = json['parentCategoryId'].cast<String>();
    categoryNameAnalyzed = json['categoryNameAnalyzed'];
    active = json['active'];
    timeStamp = json['timeStamp'];
    id = json['id'];
    version = json['version'];
    if (json['brands'] != null) {
      brands = new List<Brands>();
      json['brands'].forEach((v) {
        brands.add(new Brands.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    if(this.brandIds!=null)
      {
        data['brandIds'] = this.brandIds;
      }
    data['level'] = this.level;
    data['parentCategoryId'] = this.parentCategoryId;
    data['categoryNameAnalyzed'] = this.categoryNameAnalyzed;
    data['active'] = this.active;
    data['timeStamp'] = this.timeStamp;
    data['id'] = this.id;
    data['version'] = this.version;
    if (this.brands != null) {
      data['brands'] = this.brands.map((v) => v.toJson()).toList();
    }

    return data;
  }
}