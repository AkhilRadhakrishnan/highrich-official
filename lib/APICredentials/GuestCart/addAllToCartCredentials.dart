import 'package:highrich/model/cart_model.dart';
/*
 *  2021 Highrich.in
 */
class AddAllToCartCredentials{
  String productId;
  String productName;
  String vendorId;
  String vendorType;
  int quantity;
  String image;
  ProcessedPriceAndStocks itemCurrentPrice;
  List<ProcessedPriceAndStocks> processedPriceAndStocks;
  AddAllToCartCredentials(
      {
        this.productId,
        this.productName,
        this.vendorId,
        this.vendorType,
        this.image,
        this.quantity,
        this.processedPriceAndStocks,
        this.itemCurrentPrice,
       });

  AddAllToCartCredentials.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    vendorId = json['vendorId'];
    vendorType = json['vendorType'];
    image = json['image'];
    quantity = json['quantity'];
    if (json['processedPriceAndStocks'] != null) {
      processedPriceAndStocks = new List<ProcessedPriceAndStocks>();
      json['processedPriceAndStocks'].forEach((v) {
        processedPriceAndStocks.add(new ProcessedPriceAndStocks.fromJson(v));
      });
    }
    itemCurrentPrice = json['itemCurrentPrice'] != null
        ? new ProcessedPriceAndStocks.fromJson(json['itemCurrentPrice'])
        : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['vendorId'] = this.vendorId;
    data['vendorType'] = this.vendorType;
    data['image'] = this.image;
    data['quantity'] = this.quantity;
    if (this.processedPriceAndStocks != null) {
      data['processedPriceAndStocks'] =
          this.processedPriceAndStocks.map((v) => v.toJson()).toList();
    }
    if (this.itemCurrentPrice != null) {
      data['itemCurrentPrice'] = this.itemCurrentPrice.toJson();
    }
    return data;
  }

}

