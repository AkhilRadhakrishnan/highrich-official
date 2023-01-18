import 'dart:convert';

class DeliveryCharge {
  String status;
  double subTotal;
  double deliveryCharge;
  double totalPrice;

  DeliveryCharge({this.status, this.subTotal,this.deliveryCharge,
    this.totalPrice});


  factory DeliveryCharge.fromRawJson(String str) =>
      DeliveryCharge.fromJson(json.decode(str));

  DeliveryCharge.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    subTotal = json['priceSummary']['subTotal'];
    deliveryCharge = json['priceSummary']['deliveryCharge'];
    totalPrice = json['priceSummary']['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['subTotal'] = this.subTotal;
    data['deliveryCharge'] = this.deliveryCharge;
    data['totalPrice'] = this.totalPrice;
    return data;
  }
}
