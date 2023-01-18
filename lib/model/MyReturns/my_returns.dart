import 'dart:convert';

import 'dart:ffi';

class MyRetunsModel {
  List<Documents> documents;
  String status;
  int count;

  MyRetunsModel({this.documents, this.status, this.count});

  factory MyRetunsModel.fromRawJson(String str) =>
      MyRetunsModel.fromJson(json.decode(str));

  MyRetunsModel.fromJson(Map<String, dynamic> json) {
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
  SourceMyReturns source;

  Documents({this.index, this.type, this.id, this.version, this.source});

  Documents.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    type = json['type'];
    id = json['id'];
    version = json['version'];
    source =
    json['source'] != null ? new SourceMyReturns.fromJson(json['source']) : null;
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

class SourceMyReturns {
  String orderId;
  int requestedDate;
  String groupOrderId;
  int orderedDate;
  String status;
  int statusModifiedDate;
  ShipmentTracker shipmentTracker;
  String customerName;
  String customerEmail;
  String customerId;
  ShippedAddress shippedAddress;
  Account account;
  String reasonOfCancellation;
  String comments;
  String replyToTheRequest;
  String paymentMode;
  String productId;
  String productName;
  String brandName;
  String overview;
  String image;
  String vendorId;
  String vendorType;
  String vendor;
  String categoryId;
  String subCategory1Id;
  String subCategory2Id;
  String subCategory3Id;
  int quantity;
  ItemCurrentPriceMyReturns itemCurrentPrice;
  double totalAmount;

  SourceMyReturns(
      {this.orderId,
        this.requestedDate,
        this.groupOrderId,
        this.orderedDate,
        this.status,
        this.statusModifiedDate,
        this.shipmentTracker,
        this.customerName,
        this.customerEmail,
        this.customerId,
        this.shippedAddress,
        this.account,
        this.reasonOfCancellation,
        this.comments,
        this.replyToTheRequest,
        this.paymentMode,
        this.productId,
        this.productName,
        this.brandName,
        this.overview,
        this.image,
        this.vendorId,
        this.vendorType,
        this.vendor,
        this.categoryId,
        this.subCategory1Id,
        this.subCategory2Id,
        this.subCategory3Id,
        this.quantity,
        this.itemCurrentPrice,
        this.totalAmount});

  SourceMyReturns.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    requestedDate = json['requestedDate'];
    groupOrderId = json['groupOrderId'];
    orderedDate = json['orderedDate'];
    status = json['status'];
    statusModifiedDate = json['statusModifiedDate'];
    shipmentTracker = json['shipmentTracker'] != null
        ? new ShipmentTracker.fromJson(json['shipmentTracker'])
        : null;
    customerName = json['customerName'];
    customerEmail = json['customerEmail'];
    customerId = json['customerId'];
    shippedAddress = json['shippedAddress'] != null
        ? new ShippedAddress.fromJson(json['shippedAddress'])
        : null;
    account =
    json['account'] != null ? new Account.fromJson(json['account']) : null;
    reasonOfCancellation = json['reasonOfCancellation'];
    comments = json['comments'];
    replyToTheRequest = json['replyToTheRequest'];
    paymentMode = json['paymentMode'];
    productId = json['productId'];
    productName = json['productName'];
    brandName = json['brandName'];
    overview = json['overview'];
    image = json['image'];
    vendorId = json['vendorId'];
    vendorType = json['vendorType'];
    vendor = json['vendor'];
    categoryId = json['categoryId'];
    subCategory1Id = json['subCategory1Id'];
    subCategory2Id = json['subCategory2Id'];
    subCategory3Id = json['subCategory3Id'];
    quantity = json['quantity'];
    itemCurrentPrice = json['itemCurrentPrice'] != null
        ? new ItemCurrentPriceMyReturns.fromJson(json['itemCurrentPrice'])
        : null;
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['requestedDate'] = this.requestedDate;
    data['groupOrderId'] = this.groupOrderId;
    data['orderedDate'] = this.orderedDate;
    data['status'] = this.status;
    data['statusModifiedDate'] = this.statusModifiedDate;
    if (this.shipmentTracker != null) {
      data['shipmentTracker'] = this.shipmentTracker.toJson();
    }
    data['customerName'] = this.customerName;
    data['customerEmail'] = this.customerEmail;
    data['customerId'] = this.customerId;
    if (this.shippedAddress != null) {
      data['shippedAddress'] = this.shippedAddress.toJson();
    }
    if (this.account != null) {
      data['account'] = this.account.toJson();
    }
    data['reasonOfCancellation'] = this.reasonOfCancellation;
    data['comments'] = this.comments;
    data['replyToTheRequest'] = this.replyToTheRequest;
    data['paymentMode'] = this.paymentMode;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['brandName'] = this.brandName;
    data['overview'] = this.overview;
    data['image'] = this.image;
    data['vendorId'] = this.vendorId;
    data['vendorType'] = this.vendorType;
    data['vendor'] = this.vendor;
    data['categoryId'] = this.categoryId;
    data['subCategory1Id'] = this.subCategory1Id;
    data['subCategory2Id'] = this.subCategory2Id;
    data['subCategory3Id'] = this.subCategory3Id;
    data['quantity'] = this.quantity;
    if (this.itemCurrentPrice != null) {
      data['itemCurrentPrice'] = this.itemCurrentPrice.toJson();
    }
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}

class ShipmentTracker {
  String trackingLink;
  String trackingId;

  ShipmentTracker({this.trackingLink, this.trackingId});

  ShipmentTracker.fromJson(Map<String, dynamic> json) {
    trackingLink = json['trackingLink'];
    trackingId = json['trackingId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trackingLink'] = this.trackingLink;
    data['trackingId'] = this.trackingId;
    return data;
  }
}

class ShippedAddress {
  String id;
  String addressType;
  String emailId;
  String ownerName;
  String buildingName;
  String addressLine1;
  String addressLine2;
  String pinCode;
  String phoneNo;
  String alternatePhoneNo;
  String district;
  String state;
  bool primary;

  ShippedAddress(
      {this.id,
        this.addressType,
        this.emailId,
        this.ownerName,
        this.buildingName,
        this.addressLine1,
        this.addressLine2,
        this.pinCode,
        this.phoneNo,
        this.alternatePhoneNo,
        this.district,
        this.state,
        this.primary});

  ShippedAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['addressType'];
    emailId = json['emailId'];
    ownerName = json['ownerName'];
    buildingName = json['buildingName'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    pinCode = json['pinCode'];
    phoneNo = json['phoneNo'];
    alternatePhoneNo = json['alternatePhoneNo'];
    district = json['district'];
    state = json['state'];
    primary = json['primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['addressType'] = this.addressType;
    data['emailId'] = this.emailId;
    data['ownerName'] = this.ownerName;
    data['buildingName'] = this.buildingName;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['pinCode'] = this.pinCode;
    data['phoneNo'] = this.phoneNo;
    data['alternatePhoneNo'] = this.alternatePhoneNo;
    data['district'] = this.district;
    data['state'] = this.state;
    data['primary'] = this.primary;
    return data;
  }
}

class Account {
  String bankName;
  String accountNumber;
  String accountHolderName;
  String ifscCode;
  String branch;
  String iFSCCode;

  Account(
      {this.bankName,
        this.accountNumber,
        this.accountHolderName,
        this.ifscCode,
        this.branch,
        this.iFSCCode});

  Account.fromJson(Map<String, dynamic> json) {
    bankName = json['bankName'];
    accountNumber = json['accountNumber'];
    accountHolderName = json['accountHolderName'];
    ifscCode = json['ifscCode'];
    branch = json['branch'];
    iFSCCode = json['IFSCCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankName'] = this.bankName;
    data['accountNumber'] = this.accountNumber;
    data['accountHolderName'] = this.accountHolderName;
    data['ifscCode'] = this.ifscCode;
    data['branch'] = this.branch;
    data['IFSCCode'] = this.iFSCCode;
    return data;
  }
}

class ItemCurrentPriceMyReturns {
  int serialNumber;
  List<String> batchNumbers;
  int variant;
  String quantity;
  String unit;
  double price;
  dynamic discount;
  int stock;
  double sellingPrice;

  ItemCurrentPriceMyReturns(
      {this.serialNumber,
        this.batchNumbers,
        this.variant,
        this.quantity,
        this.unit,
        this.price,
        this.discount,
        this.stock,
        this.sellingPrice});

  ItemCurrentPriceMyReturns.fromJson(Map<String, dynamic> json) {
    serialNumber = json['serialNumber'];
    batchNumbers = json['batchNumbers'].cast<String>();
    variant = json['variant'];
    quantity = json['quantity'];
    unit = json['unit'];
    price = json['price'];
    discount = json['discount'];
    stock = json['stock'];
    sellingPrice = json['sellingPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serialNumber'] = this.serialNumber;
    data['batchNumbers'] = this.batchNumbers;
    data['variant'] = this.variant;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['stock'] = this.stock;
    data['sellingPrice'] = this.sellingPrice;
    return data;
  }
}