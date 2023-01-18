import 'dart:convert';

class SubscriptionResponseModel {
  List<Documents> documents;
  String status;
  int count;

  SubscriptionResponseModel({this.documents, this.status, this.count});


  factory SubscriptionResponseModel.fromRawJson(String str) =>
      SubscriptionResponseModel.fromJson(json.decode(str));

  SubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = new List<Documents>();
      json['documents'].forEach((v) {
        documents.add(new Documents.fromJson(v));
      });
    }
    status = json['status'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.documents != null) {
      data['documents'] = this.documents.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['count'] = this.count;
    return data;
  }
}

class Documents {
  String index;
  String type;
  String id;
  int version;
  Source source;

  Documents({this.index, this.type, this.id, this.version, this.source});

  Documents.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    type = json['type'];
    id = json['id'];
    version = json['version'];
    source =
    json['source'] != null ? new Source.fromJson(json['source']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['type'] = this.type;
    data['id'] = this.id;
    data['version'] = this.version;
    if (this.source != null) {
      data['source'] = this.source.toJson();
    }
    return data;
  }
}

class Source {
  String customerId;
  String addressId;
  String subscriptionTitle;
  String productId;
  String productName;
  String image;
  ItemCurrentPriceSubscription itemCurrentPrice;
  int quantity;
  bool isActive;
  String period;
  int daysBetweenOrder;
  int subscribedDate;
  int lastOrderedDate;

  Source(
      {this.customerId,
        this.addressId,
        this.subscriptionTitle,
        this.productId,
        this.productName,
        this.image,
        this.itemCurrentPrice,
        this.quantity,
        this.isActive,
        this.period,
        this.daysBetweenOrder,
        this.subscribedDate,
        this.lastOrderedDate});

  Source.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    addressId = json['addressId'];
    subscriptionTitle = json['subscriptionTitle'];
    productId = json['productId'];
    productName = json['productName'];
    image = json['image'];
    itemCurrentPrice = json['itemCurrentPrice'] != null
        ? new ItemCurrentPriceSubscription.fromJson(json['itemCurrentPrice'])
        : null;
    quantity = json['quantity'];
    isActive = json['isActive'];
    period = json['period'];
    daysBetweenOrder = json['daysBetweenOrder'];
    subscribedDate = json['subscribedDate'];
    lastOrderedDate = json['lastOrderedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['addressId'] = this.addressId;
    data['subscriptionTitle'] = this.subscriptionTitle;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['image'] = this.image;
    if (this.itemCurrentPrice != null) {
      data['itemCurrentPrice'] = this.itemCurrentPrice.toJson();
    }
    data['quantity'] = this.quantity;
    data['isActive'] = this.isActive;
    data['period'] = this.period;
    data['daysBetweenOrder'] = this.daysBetweenOrder;
    data['subscribedDate'] = this.subscribedDate;
    data['lastOrderedDate'] = this.lastOrderedDate;
    return data;
  }
}

class ItemCurrentPriceSubscription {
  int serialNumber;
  List<String> batchNumbers;
  String batchType;
  int addedDate;
  dynamic expiryDate;
  dynamic notificationPeriodForToBeExpiredBatch;
  int variant;
  String quantity;
  String unit;
  dynamic price;
  dynamic discount;
  int stock;
  double sellingPrice;
  dynamic dealerPrice;
  double weightInKg;
  double salesIncentive;

  ItemCurrentPriceSubscription(
      {this.serialNumber,
        this.batchNumbers,
        this.batchType,
        this.addedDate,
        this.expiryDate,
        this.notificationPeriodForToBeExpiredBatch,
        this.variant,
        this.quantity,
        this.unit,
        this.price,
        this.discount,
        this.stock,
        this.sellingPrice,
        this.dealerPrice,
        this.weightInKg,
        this.salesIncentive});

  ItemCurrentPriceSubscription.fromJson(Map<String, dynamic> json) {
    serialNumber = json['serialNumber'];
    batchNumbers = json['batchNumbers'].cast<String>();
    batchType = json['batchType'];
    addedDate = json['addedDate'];
    expiryDate = json['expiryDate'];
    notificationPeriodForToBeExpiredBatch =
    json['notificationPeriodForToBeExpiredBatch'];
    variant = json['variant'];
    quantity = json['quantity'];
    unit = json['unit'];
    price = json['price'];
    discount = json['discount'];
    stock = json['stock'];
    sellingPrice = json['sellingPrice'];
    dealerPrice = json['dealerPrice'];
    weightInKg = json['weightInKg'];
    salesIncentive = json['salesIncentive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serialNumber'] = this.serialNumber;
    data['batchNumbers'] = this.batchNumbers;
    data['batchType'] = this.batchType;
    data['addedDate'] = this.addedDate;
    data['expiryDate'] = this.expiryDate;
    data['notificationPeriodForToBeExpiredBatch'] =
        this.notificationPeriodForToBeExpiredBatch;
    data['variant'] = this.variant;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['stock'] = this.stock;
    data['sellingPrice'] = this.sellingPrice;
    data['dealerPrice'] = this.dealerPrice;
    data['weightInKg'] = this.weightInKg;
    data['salesIncentive'] = this.salesIncentive;
    return data;
  }
}