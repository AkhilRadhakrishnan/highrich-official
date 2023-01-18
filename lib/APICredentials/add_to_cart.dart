/*
 *  2021 Highrich.in
 */
class AddToCartModel {
  String userId;
  String accountType;
  Item item;

  AddToCartModel({this.userId,this.accountType, this.item});

  AddToCartModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    accountType = json['accountType'];
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['accountType'] = this.accountType;
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }
    return data;
  }
}

class Item {
  String productId;
  String vendorId;
  String vendorType;
  int quantity;
  ItemCurrentPrice itemCurrentPrice;

  Item(
      {this.productId,
        this.vendorId,
        this.vendorType,
        this.quantity,
        this.itemCurrentPrice});

  Item.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    vendorId = json['vendorId'];
    vendorType = json['vendorType'];
    quantity = json['quantity'];
    itemCurrentPrice = json['itemCurrentPrice'] != null
        ? new ItemCurrentPrice.fromJson(json['itemCurrentPrice'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['vendorId'] = this.vendorId;
    data['vendorType'] = this.vendorType;
    data['quantity'] = this.quantity;
    if (this.itemCurrentPrice != null) {
      data['itemCurrentPrice'] = this.itemCurrentPrice.toJson();
    }
    return data;
  }
}

class ItemCurrentPrice {
  int serialNumber;
  List<String> batchNumbers;
  int variant;
  String quantity;
  String unit;
  dynamic batchType;
  dynamic addedDate;
  dynamic expiryDate;
  double price;
  double discount;
  double weightInKg;
  int stock;
  double sellingPrice;
  double salesIncentive;

  ItemCurrentPrice(
      {this.serialNumber,
        this.batchNumbers,
        this.variant,
        this.quantity,
        this.unit,
        this.batchType,
        this.addedDate,
        this.expiryDate,
        this.price,
        this.discount,
        this.weightInKg,
        this.stock,
        this.sellingPrice,
        this.salesIncentive

      });

  ItemCurrentPrice.fromJson(Map<String, dynamic> json) {
    serialNumber = json['serialNumber'];
    batchNumbers = json['batchNumbers'].cast<String>();
    variant = json['variant'];
    quantity = json['quantity'];
    unit = json['unit'];
    batchType = json['batchType'];
    addedDate = json['addedDate'];
    expiryDate = json['expiryDate'];
    price = json['price'];
    discount = json['discount'];
    weightInKg = json['weightInKg'];
    stock = json['stock'];
    sellingPrice = json['sellingPrice'];
    salesIncentive = json['salesIncentive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serialNumber'] = this.serialNumber;
    data['batchNumbers'] = this.batchNumbers;
    data['variant'] = this.variant;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['batchType'] = this.batchType;
    data['addedDate'] = this.addedDate;
    data['expiryDate'] = this.expiryDate;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['weightInKg'] = this.weightInKg;
    data['stock'] = this.stock;
    data['sellingPrice'] = this.sellingPrice;
    data['salesIncentive'] = this.salesIncentive;
    return data;
  }
}