import 'dart:convert';

class GetBrandModel{
  String status;
  int count;
  int total;
  List<ImageBrands> brands;

  factory GetBrandModel.fromRawJson(String str) =>
      GetBrandModel.fromJson(json.decode(str));

  GetBrandModel({this.status, this.count, this.brands,this.total});

  GetBrandModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    total= json['total'];
    if (json['brands'] != null) {
      brands = new List<ImageBrands>();
      json['brands'].forEach((v) {
        brands.add(new ImageBrands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['count'] = this.count;
    data['total'] = this.total;
    if (this.brands != null) {
      data['brands'] =
          this.brands.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageBrands {
  String index;
  String type;
  String id;
  dynamic version;
  BrandSource source;

  ImageBrands({this.index, this.type, this.id, this.version, this.source});

  ImageBrands.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    type = json['type'];
    id = json['id'];
    version = json['version'];
    source =
        json['source'] != null ? new BrandSource.fromJson(json['source']) : null;
  }
  

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['type'] = this.type;
    data['id'] = this.id;
    data['version'] = this.version;
    if (this.source != null) {
      data['source'] = this.source.toJson();
    }
    return data;
  }
}

class BrandSource{
  String avgRating;
  String brandId;
  String brandName;
  String image;
  bool popularBrand;

  BrandSource({
    this.avgRating,
    this.brandId,
    this.image,
    this.popularBrand,
    this.brandName
  });

  BrandSource.fromJson(Map<String, dynamic> json) {
    avgRating = json['avgRating'];
    brandName = json['brandName'];
    brandId = json['brandId'];
    image = json['image'];
    popularBrand = json['popularBrand'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avgRating'] = this.avgRating;
    data['brandName'] = this.brandName;
    data['brandId'] = this.brandId;
    data['image'] = this.image;
    data['popularBrand'] = this.popularBrand;
    return data;
  }

}