import 'dart:convert';

class DeliveryChargeModel {
  String status;
  String message;
  PriceSummary priceSummary;
  List<String> cartItemIds;
  List<String> lowStockIds;
  String failureType;
  //VendorDeliveryChargeMap vendorDeliveryChargeMap;

  DeliveryChargeModel(
      {this.status,
        this.message,
        this.priceSummary,
        this.cartItemIds, this.lowStockIds, this.failureType
       // this.vendorDeliveryChargeMap
      });

  factory DeliveryChargeModel.fromRawJson(String str) =>
      DeliveryChargeModel.fromJson(json.decode(str));


  DeliveryChargeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    priceSummary = json['priceSummary'] != null
        ? new PriceSummary.fromJson(json['priceSummary'])
        : null;

    if(json['cartItemIds']!=null)
    {
      cartItemIds = json['cartItemIds'].cast<String>();
    }
if(json['lowStockIds']!=null)
  {
    lowStockIds = json['lowStockIds'].cast<String>();
  }

    failureType = json['failureType'];
    // vendorDeliveryChargeMap = json['vendorDeliveryChargeMap'] != null
    //     ? new VendorDeliveryChargeMap.fromJson(json['vendorDeliveryChargeMap'])
    //     : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.priceSummary != null) {
      data['priceSummary'] = this.priceSummary.toJson();
    }
    if (this.cartItemIds != null) {
      data['cartItemIds'] = this.cartItemIds;
    }
    if (this.lowStockIds != null) {
      data['lowStockIds'] = this.lowStockIds;
    }
    if (this.failureType != null) {
      data['failureType'] = this.failureType;
    }

    // if (this.vendorDeliveryChargeMap != null) {
    //   data['vendorDeliveryChargeMap'] = this.vendorDeliveryChargeMap.toJson();
    // }
    return data;
  }
}

class PriceSummary {
  double subTotal;
  double deliveryCharge;
  double totalPrice;

  PriceSummary({this.subTotal, this.deliveryCharge, this.totalPrice});

  PriceSummary.fromJson(Map<String, dynamic> json) {
    subTotal = json['subTotal'];
    deliveryCharge = json['deliveryCharge'];
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subTotal'] = this.subTotal;
    data['deliveryCharge'] = this.deliveryCharge;
    data['totalPrice'] = this.totalPrice;
    return data;
  }
}

// class VendorDeliveryChargeMap {
//   int fe867cf7c10f81e832d57c409d6bbccd;
//
//   VendorDeliveryChargeMap({this.fe867cf7c10f81e832d57c409d6bbccd});
//
//   VendorDeliveryChargeMap.fromJson(Map<String, dynamic> json) {
//     fe867cf7c10f81e832d57c409d6bbccd = json['fe867cf7c10f81e832d57c409d6bbccd'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['fe867cf7c10f81e832d57c409d6bbccd'] =
//         this.fe867cf7c10f81e832d57c409d6bbccd;
//     return data;
//   }
// }



