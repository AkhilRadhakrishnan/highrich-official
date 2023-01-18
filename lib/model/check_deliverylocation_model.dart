import 'dart:convert';

class CheckDeliveryLocationModel {
  String status;
  String message;
  bool availability;
  String pinCode;

  CheckDeliveryLocationModel(
      {this.status, this.message, this.availability, this.pinCode});



  factory CheckDeliveryLocationModel.fromRawJson(String str) =>
      CheckDeliveryLocationModel.fromJson(json.decode(str));

  CheckDeliveryLocationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    availability = json['availability'];
    pinCode = json['pinCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['availability'] = this.availability;
    data['pinCode'] = this.pinCode;
    return data;
  }
}
