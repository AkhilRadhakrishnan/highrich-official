import 'dart:convert';

class ReasonForReturnModel {
  String status;
  String message;
  List<String> returnReasons;

  ReasonForReturnModel({this.status, this.message, this.returnReasons});

  factory ReasonForReturnModel.fromRawJson(String str) =>
      ReasonForReturnModel.fromJson(json.decode(str));

  ReasonForReturnModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    returnReasons = json['returnReasons'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['returnReasons'] = this.returnReasons;
    return data;
  }
}