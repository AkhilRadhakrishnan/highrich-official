import 'dart:convert';

class CancelOrderReasonModel {
  String status;
  String message;
  List<String> cancelReasons;

  CancelOrderReasonModel({this.status, this.message, this.cancelReasons});

  factory CancelOrderReasonModel.fromRawJson(String str) =>
      CancelOrderReasonModel.fromJson(json.decode(str));

  CancelOrderReasonModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    cancelReasons = json['cancelReasons'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['cancelReasons'] = this.cancelReasons;
    return data;
  }
}