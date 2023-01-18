/*
 *  2021 Highrich.in
 */
class ProductAPI {
  String key;
  String offset;
  String size;
  Filter filter;

  ProductAPI({this.key, this.offset, this.size, this.filter});

  ProductAPI.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    offset = json['offset'];
    size = json['size'];
    filter =
    json['filter'] != null ? new Filter.fromJson(json['filter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['offset'] = this.offset;
    data['size'] = this.size;
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
    categoryId = json['categoryId'].cast<String>();
    subCategory1Id = json['subCategory1Id'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['subCategory1Id'] = this.subCategory1Id;
    return data;
  }
}