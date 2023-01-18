import 'dart:convert';

class CartCountModel {
  String status;
  String message;
  int cartCount;
  List<CartItemsCartCount> cartItems;

  CartCountModel({this.status, this.message, this.cartCount,this.cartItems});

  factory CartCountModel.fromRawJson(String str) =>
      CartCountModel.fromJson(json.decode(str));

  CartCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    cartCount = json['cartCount'];
    if (json['cartItems'] != null) {
      cartItems = new List<CartItemsCartCount>();
      json['cartItems'].forEach((v) {
        cartItems.add(new CartItemsCartCount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['cartCount'] = this.cartCount;
    if (this.cartItems != null) {
      data['cartItems'] = this.cartItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
  
}
class CartItemsCartCount {
  String productId;
  int serialNumber;
  String variant;

  CartItemsCartCount({this.productId, this.serialNumber, this.variant});

  CartItemsCartCount.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    serialNumber = json['serialNumber'];
    variant = json['variant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['serialNumber'] = this.serialNumber;
    data['variant'] = this.variant;
    return data;
  }
}