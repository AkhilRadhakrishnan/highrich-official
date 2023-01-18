import 'dart:convert';

class HomeBannerModel {
  String sectionTitle;
  String sectionType;
  int sectionOrder;
  String sectionId;
  int version;
  List<SectionData> sectionData;

  HomeBannerModel(
      {this.sectionTitle,
        this.sectionType,
        this.sectionOrder,
        this.sectionId,
        this.version,
        this.sectionData});

  factory HomeBannerModel.fromRawJson(String str) =>
      HomeBannerModel.fromJson(json.decode(str));


  HomeBannerModel.fromJson(Map<String, dynamic> json) {
    sectionTitle = json['sectionTitle'];
    sectionType = json['sectionType'];
    sectionOrder = json['sectionOrder'];
    sectionId = json['sectionId'];
    version = json['version'];
    if (json['sectionData'] != null) {
      sectionData = new List<SectionData>();
      json['sectionData'].forEach((v) {
        sectionData.add(new SectionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sectionTitle'] = this.sectionTitle;
    data['sectionType'] = this.sectionType;
    data['sectionOrder'] = this.sectionOrder;
    data['sectionId'] = this.sectionId;
    data['version'] = this.version;
    if (this.sectionData != null) {
      data['sectionData'] = this.sectionData.map((v) => v.toJson()).toList();
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

  String bannerCategory;

  SectionData(
      {this.bannerCategoryName,
        this.image,
        this.bannerConditions,
        this.bannerType,
        this.bannerId,
        this.bannerCategory});

  SectionData.fromJson(Map<String, dynamic> json) {
    bannerCategoryName = json['bannerCategoryName'];
    image = json['image'];
    bannerConditions = json['bannerConditions'] != null
        ? new BannerConditions.fromJson(json['bannerConditions'])
        : null;
    bannerType = json['bannerType'];
    bannerId = json['bannerId'];
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
  List<String> subCategory1Id;

  Term({this.categoryId,this.subCategory1Id});

  Term.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId']?.cast<String>();
    subCategory1Id = json['subCategory1Id']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['subCategory1Id'] = this.subCategory1Id;
    return data;
  }
}