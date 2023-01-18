import 'dart:convert';

class HomeCateogryModel {
  String sectionTitle;
  String sectionType;
  int sectionOrder;
  String sectionId;
  int version;
  List<SectionData> sectionData;

  HomeCateogryModel(
      {this.sectionTitle,
        this.sectionType,
        this.sectionOrder,
        this.sectionId,
        this.version,
        this.sectionData});

  factory HomeCateogryModel.fromRawJson(String str) =>
      HomeCateogryModel.fromJson(json.decode(str));

  HomeCateogryModel.fromJson(Map<String, dynamic> json) {
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
  String image;
  String popularCategoryId;
  String popularCategoryName;
  String categoryName;
  String categoryId;

  SectionData(
      {this.image,
        this.popularCategoryId,
        this.popularCategoryName,
        this.categoryName,
        this.categoryId});

  SectionData.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    popularCategoryId = json['popularCategoryId'];
    popularCategoryName = json['popularCategoryName'];
    categoryName = json['categoryName'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['popularCategoryId'] = this.popularCategoryId;
    data['popularCategoryName'] = this.popularCategoryName;
    data['categoryName'] = this.categoryName;
    data['categoryId'] = this.categoryId;
    return data;
  }
}