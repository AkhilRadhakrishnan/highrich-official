import 'dart:convert';


ImageUploadModel imageUploadModelFromJson(String str) => ImageUploadModel.fromJson(json.decode(str));
class ImageUploadModel {
  String status;
  String message;
  String documents;

  factory ImageUploadModel.fromRawJson(String str) =>
      ImageUploadModel.fromJson(json.decode(str));

  ImageUploadModel({this.status, this.message, this.documents});

  ImageUploadModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    documents = json['documents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['documents'] = this.documents;
    return data;
  }
}