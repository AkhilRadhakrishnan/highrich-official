class HomeTempBannerModel {
  String bannerCategoryName;
  String image;
  BannerConditions bannerConditions;
  String bannerType;
  String bannerId;
  int lastModifiedDate;
  String bannerCategory;

  HomeTempBannerModel(
      {this.bannerCategoryName,
        this.image,
        this.bannerConditions,
        this.bannerType,
        this.bannerId,
        this.lastModifiedDate,
        this.bannerCategory});

  HomeTempBannerModel.fromJson(Map<String, dynamic> json) {
    bannerCategoryName = json['bannerCategoryName'];
    image = json['image'];
    bannerConditions = json['bannerConditions'] != null
        ? new BannerConditions.fromJson(json['bannerConditions'])
        : null;
    bannerType = json['bannerType'];
    bannerId = json['bannerId'];
    lastModifiedDate = json['lastModifiedDate'];
    bannerCategory = json['bannerCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bannerCategoryName'] = this.bannerCategoryName;
    data['image'] = this.image;
    if (this.bannerConditions != null) {
      data['bannerConditions'] = this.bannerConditions.toJson();
    }
    data['bannerType'] = this.bannerType;
    data['bannerId'] = this.bannerId;
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['bannerCategory'] = this.bannerCategory;
    return data;
  }
}

class BannerConditions {
  Filter filter;

  BannerConditions({this.filter});

  BannerConditions.fromJson(Map<String, dynamic> json) {
    filter =
    json['filter'] != null ? new Filter.fromJson(json['filter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.filter != null) {
      data['filter'] = this.filter.toJson();
    }
    return data;
  }
}

class Filter {
  List<Term> term;

  Filter({this.term});

  Filter.fromJson(Map<String, dynamic> json) {
    if (json['term'] != null) {
      term = new List<Term>();
      json['term'].forEach((v) {
        term.add(new Term.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.term != null) {
      data['term'] = this.term.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Term {
  List<String> categoryId;

  Term({this.categoryId});

  Term.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    return data;
  }
}