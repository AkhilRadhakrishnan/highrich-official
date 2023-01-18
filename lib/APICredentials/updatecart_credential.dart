/*
 *  2021 Highrich.in
 */
class UpdateCartCredential {
  String id;
  String cartId;
  String productId;
  int quantity;
  ItemCurrentPriceUpdateCart itemCurrentPrice;

  UpdateCartCredential({this.id,this.cartId,this.productId, this.quantity, this.itemCurrentPrice});

  UpdateCartCredential.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    cartId = json['cartId'];
    quantity = json['quantity'];
    itemCurrentPrice = json['itemCurrentPrice'] != null
        ? new ItemCurrentPriceUpdateCart.fromJson(json['itemCurrentPrice'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['cartId'] = this.cartId;
    data['quantity'] = this.quantity;
    if (this.itemCurrentPrice != null) {
      data['itemCurrentPrice'] = this.itemCurrentPrice.toJson();
    }
    return data;
  }
}

class ItemCurrentPriceUpdateCart {
  String unit;
  dynamic sellingPrice;
  int serialNumber;
  String quantity;
  dynamic price;
  int variant;
  dynamic discount;
  List<String> batchNumbers;
  int stock;

  ItemCurrentPriceUpdateCart(
      {this.unit,
        this.sellingPrice,
        this.serialNumber,
        this.quantity,
        this.price,
        this.variant,
        this.discount,
        this.batchNumbers,
        this.stock});

  ItemCurrentPriceUpdateCart.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    sellingPrice = json['sellingPrice'];
    serialNumber = json['serialNumber'];
    quantity = json['quantity'];
    price = json['price'];
    variant = json['variant'];
    discount = json['discount'];
    batchNumbers = json['batchNumbers'].cast<String>();
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unit'] = this.unit;
    data['sellingPrice'] = this.sellingPrice;
    data['serialNumber'] = this.serialNumber;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['variant'] = this.variant;
    data['discount'] = this.discount;
    data['batchNumbers'] = this.batchNumbers;
    data['stock'] = this.stock;
    return data;
  }
}