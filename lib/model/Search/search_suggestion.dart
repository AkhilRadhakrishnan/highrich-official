import 'dart:convert';

class SearchSuggestionModel {
  String status;
  String message;
  List<Documents> documents;

  SearchSuggestionModel({this.status, this.message, this.documents});

  factory SearchSuggestionModel.fromRawJson(String str) =>
      SearchSuggestionModel.fromJson(json.decode(str));


  SearchSuggestionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['documents'] != null) {
      documents = new List<Documents>();
      json['documents'].forEach((v) {
        documents.add(new Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.documents != null) {
      data['documents'] = this.documents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Documents {
  String id;
  String name;
  int level;
  String currentCategory;
  String currentCategoryId;

  Documents(
      {this.id,
        this.name,
        this.level,
        this.currentCategory,
        this.currentCategoryId});

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    level = json['level'];
    currentCategory = json['currentCategory'];
    currentCategoryId = json['currentCategoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['level'] = this.level;
    data['currentCategory'] = this.currentCategory;
    data['currentCategoryId'] = this.currentCategoryId;
    return data;
  }
}