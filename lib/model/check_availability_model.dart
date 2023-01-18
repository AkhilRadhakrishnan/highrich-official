import 'dart:convert';

class CheckAvailabilityModel {
  String status;
  String message;
  bool availability;
  String pinCode;

  CheckAvailabilityModel(
      {this.status, this.message, this.availability, this.pinCode});

  factory CheckAvailabilityModel.fromRawJson(String str) =>
      CheckAvailabilityModel.fromJson(json.decode(str));

  CheckAvailabilityModel.fromJson(Map<String, dynamic> json) {
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