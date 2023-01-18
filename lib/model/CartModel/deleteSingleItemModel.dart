import 'dart:convert';

class DeleteSingleItemModel {
  String status;
  String message;

  DeleteSingleItemModel({this.status, this.message});

  factory DeleteSingleItemModel.fromRawJson(String str) =>
      DeleteSingleItemModel.fromJson(json.decode(str));


  DeleteSingleItemModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}