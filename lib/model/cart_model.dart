import 'dart:convert';

class CartModel {
  String status;
  String message;
  Cart cart;

  factory CartModel.fromRawJson(String str) =>
      CartModel.fromJson(json.decode(str));


  CartModel({this.status, this.message, this.cart});

  CartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    cart = json['cart'] != null ? new Cart.fromJson(json['cart']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.cart != null) {
      data['cart'] = this.cart.toJson();
    }
    return data;
  }
}

class Cart {
  String cartId;
  double totalPrice;
  double totalDiscount;
  double bagTotal;
  List<CartItems> cartItems;

  Cart(
      {this.cartId,
        this.totalPrice,
        this.totalDiscount,
        this.bagTotal,
        this.cartItems});

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cartId'];
    totalPrice = json['totalPrice'];
    totalDiscount = json['totalDiscount'];
    bagTotal = json['bagTotal'];
    if (json['cartItems'] != null) {
      cartItems = new List<CartItems>();
      json['cartItems'].forEach((v) {
        cartItems.add(new CartItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartId'] = this.cartId;
    data['totalPrice'] = this.totalPrice;
    data['totalDiscount'] = this.totalDiscount;
    data['bagTotal'] = this.bagTotal;
    if (this.cartItems != null) {
      data['cartItems'] = this.cartItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItems {
  String id;
  String productId;
  String productName;
  String brandName;
  String overview;
  String vendorId;
  String vendorType;
  String vendor;
  String windowType;
  String image;
  String categoryId;
  String subCategory1Id;
  String subCategory2Id;
  String subCategory3Id;
  int quantity;
  bool cartStockFlage=false;
  bool lowStock=false;
  bool outOfStock=false;
  List<ProcessedPriceAndStocks> processedPriceAndStocks;
  ProcessedPriceAndStocks itemCurrentPrice;
  dynamic totalAmount;
  bool isCODEnabled;
  List<String> serviceLocations;
  int version;

  CartItems(
      {this.id,
        this.productId,
        this.productName,
        this.lowStock,
        this.outOfStock,
        this.brandName,
        this.overview,
        this.vendorId,
        this.vendorType,
        this.vendor,
        this.windowType,
        this.image,
        this.categoryId,
        this.subCategory1Id,
        this.subCategory2Id,
        this.subCategory3Id,
        this.quantity,
        this.cartStockFlage,
        this.processedPriceAndStocks,
        this.itemCurrentPrice,
        this.totalAmount,
        this.isCODEnabled,
        this.serviceLocations,
        this.version});

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    productName = json['productName'];
    outOfStock = json['outOfStock'];
    lowStock = json['lowStock'];
    brandName = json['brandName'];
    overview = json['overview'];
    vendorId = json['vendorId'];
    vendorType = json['vendorType'];
    vendor = json['vendor'];
    windowType = json['windowType'];
    image = json['image'];
    categoryId = json['categoryId'];
    subCategory1Id = json['subCategory1Id'];
    subCategory2Id = json['subCategory2Id'];
    subCategory3Id = json['subCategory3Id'];
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
    totalAmount = json['totalAmount'];
    isCODEnabled = json['isCODEnabled'];
    if (json['serviceLocations'] != null) {
      serviceLocations = json['serviceLocations'].cast<String>();
    }

    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['lowStock'] = this.lowStock;
    data['outOfStock'] = this.outOfStock;
    data['brandName'] = this.brandName;
    data['overview'] = this.overview;
    data['vendorId'] = this.vendorId;
    data['vendorType'] = this.vendorType;
    data['vendor'] = this.vendor;
    data['windowType'] = this.windowType;
    data['image'] = this.image;
    data['categoryId'] = this.categoryId;
    data['subCategory1Id'] = this.subCategory1Id;
    data['subCategory2Id'] = this.subCategory2Id;
    data['subCategory3Id'] = this.subCategory3Id;
    data['quantity'] = this.quantity;
    if (this.processedPriceAndStocks != null) {
      data['processedPriceAndStocks'] =
          this.processedPriceAndStocks.map((v) => v.toJson()).toList();
    }
    if (this.itemCurrentPrice != null) {
      data['itemCurrentPrice'] = this.itemCurrentPrice.toJson();
    }
    data['totalAmount'] = this.totalAmount;
    data['isCODEnabled'] = this.isCODEnabled;
    data['serviceLocations'] = this.serviceLocations;
    data['version'] = this.version;
    return data;
  }
}

class ProcessedPriceAndStocks {
  String unit;
  dynamic batchType;
  dynamic addedDate;
  dynamic expiryDate;
  dynamic sellingPrice;
  int serialNumber;
  String quantity;
  double price;
  int variant;
  dynamic discount;
  double salesIncentive;
  double weightInKg;
  List<String> batchNumbers;
  int stock;

  ProcessedPriceAndStocks(
      {this.unit,
        this.batchType,
        this.addedDate,
        this.expiryDate,
        this.sellingPrice,
        this.serialNumber,
        this.quantity,
        this.price,
        this.variant,
        this.discount,
        this.batchNumbers,
        this.salesIncentive,
        this.weightInKg,
        this.stock});

  ProcessedPriceAndStocks.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    batchType = json['batchType'];
    addedDate = json['addedDate'];
    expiryDate = json['expiryDate'];
    sellingPrice = json['sellingPrice'];
    serialNumber = json['serialNumber'];
    quantity = json['quantity'];
    price = json['price'];
    variant = json['variant'];
    discount = json['discount'];
    if(json['batchNumbers']!=null)
      {
        batchNumbers = json['batchNumbers'].cast<String>();
      }
    stock = json['stock'];
    weightInKg = json['weightInKg'];
    salesIncentive = json['salesIncentive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unit'] = this.unit;
    data['batchType'] = this.batchType;
    data['addedDate'] = this.addedDate;
    data['expiryDate'] = this.expiryDate;
    data['sellingPrice'] = this.sellingPrice;
    data['serialNumber'] = this.serialNumber;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['variant'] = this.variant;
    data['discount'] = this.discount;
    data['batchNumbers'] = this.batchNumbers;
    data['stock'] = this.stock;
    data['weightInKg'] = this.weightInKg;
    data['salesIncentive'] = this.salesIncentive;
    return data;
  }
}