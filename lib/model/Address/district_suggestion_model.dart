import 'dart:convert';

class DistrictModel {
  String status;
  dynamic count;
  List<Districts> documents;

  factory DistrictModel.fromRawJson(String str) =>
      DistrictModel.fromJson(json.decode(str));

  DistrictModel({this.status, this.count, this.documents});

  DistrictModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    if (json['documents'] != null) {
      if (json['documents'] != dynamic) {
        documents = new List<Districts>();
        json['documents'].forEach((v) {
          documents.add(new Districts.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['count'] = this.count;
    if (this.documents != dynamic) {
      data['documents'] = this.documents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Districts {
  String index;
  String type;
  String id;
  dynamic version;
  Source source;

  Districts({this.index, this.type, this.id, this.version, this.source});

  Districts.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    type = json['type'];
    id = json['id'];
    version = json['version'];
    source =
        json['source'] != dynamic ? new Source.fromJson(json['source']) : dynamic;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['type'] = this.type;
    data['id'] = this.id;
    data['version'] = this.version;
    if (this.source != dynamic) {
      data['source'] = this.source.toJson();
    }
    return data;
  }
}

class Source {
  String state;
  List<String> districts;

  Source(
      {this.state,
        this.districts});

  Source.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    districts = json['districts'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['districts'] = this.districts;
    return data;
  }
}