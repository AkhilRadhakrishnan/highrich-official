import 'dart:convert';

class OrdersModel {
  String status;
  int count;
  List<Orders> orders;

  OrdersModel({this.status, this.count, this.orders});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    if (json['orders'] != null) {
      orders = new List<Orders>();
      json['orders'].forEach((v) {
        orders.add(new Orders.fromJson(v));
      });
    }
  }

  factory OrdersModel.fromRawJson(String str) =>
      OrdersModel.fromJson(json.decode(str));

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['count'] = this.count;
    if (this.orders != null) {
      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  String index;
  String type;
  String id;
  int version;
  Source source;


  Orders({this.index, this.type, this.id, this.version, this.source});

  Orders.fromJson(Map<String, dynamic> json) {
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
  String paymentMode;
  String cartId;
  dynamic deliveryCharge;
  dynamic totalPrice;
  dynamic subTotal;
  String customerId;
  String customerName;
  String customerEmail;
  ShippingAddress shippingAddress;
  dynamic bagTotal;
  dynamic totalDiscount;
  int orderedDate;
  String orderGroupId;
  String referralId;
  String orderStatus;
  String paymentStatus;
  String razorPayCustomerId;
  String razorPayOrderId;
  String razorPayPaymentId;
  List<ProcessedOrderedItems> processedOrderedItems;

  Source(
      {this.paymentMode,
      this.cartId,
      this.deliveryCharge,
      this.totalPrice,
      this.subTotal,
      this.customerId,
      this.customerName,
      this.customerEmail,
      this.shippingAddress,
      this.bagTotal,
      this.totalDiscount,
      this.orderedDate,
      this.orderGroupId,
      this.referralId,
      this.orderStatus,
      this.paymentStatus,
      this.razorPayCustomerId,
      this.razorPayOrderId,
      this.razorPayPaymentId,
      this.processedOrderedItems});

  Source.fromJson(Map<String, dynamic> json) {
    paymentMode = json['paymentMode'];
    cartId = json['cartId'];
    deliveryCharge = json['deliveryCharge'];
    totalPrice = json['totalPrice'];
    subTotal = json['subTotal'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    customerEmail = json['customerEmail'];
    shippingAddress = json['shippingAddress'] != null
        ? new ShippingAddress.fromJson(json['shippingAddress'])
        : null;
    bagTotal = json['bagTotal'];
    totalDiscount = json['totalDiscount'];
    orderedDate = json['orderedDate'];
    orderGroupId = json['orderGroupId'];
    referralId = json['referralId'];
    orderStatus = json['orderStatus'];
    paymentStatus = json['paymentStatus'];
    razorPayCustomerId = json['razorPayCustomerId'];
    razorPayOrderId = json['razorPayOrderId'];
    razorPayPaymentId = json['razorPayPaymentId'];
    if (json['processedOrderedItems'] != null) {
      processedOrderedItems = new List<ProcessedOrderedItems>();
      json['processedOrderedItems'].forEach((v) {
        processedOrderedItems.add(new ProcessedOrderedItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentMode'] = this.paymentMode;
    data['cartId'] = this.cartId;
    data['deliveryCharge'] = this.deliveryCharge;
    data['totalPrice'] = this.totalPrice;
    data['subTotal'] = this.subTotal;
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['customerEmail'] = this.customerEmail;
    if (this.shippingAddress != null) {
      data['shippingAddress'] = this.shippingAddress.toJson();
    }
    data['bagTotal'] = this.bagTotal;
    data['totalDiscount'] = this.totalDiscount;
    data['orderedDate'] = this.orderedDate;
    data['orderGroupId'] = this.orderGroupId;
    data['referralId'] = this.referralId;
    data['orderStatus'] = this.orderStatus;
    data['paymentStatus'] = this.paymentStatus;
    data['razorPayCustomerId'] = this.razorPayCustomerId;
    data['razorPayOrderId'] = this.razorPayOrderId;
    data['razorPayPaymentId'] = this.razorPayPaymentId;
    if (this.processedOrderedItems != null) {
      data['processedOrderedItems'] =
          this.processedOrderedItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShippingAddress {
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

  ShippingAddress(
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

  ShippingAddress.fromJson(Map<String, dynamic> json) {
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

class  ProcessedOrderedItems {
  String vendor;
  String vendorType;
  String vendorGstNumber;
  String windowType;
  VendorAddress vendorAddress;
  List<OrderedItemsOfVendor> orderedItemsOfVendor;
  bool invoice = true;
  VendorOrderSummary vendorOrderSummary;
  ProcessedOrderedItems(
      {this.vendor, this.vendorType,this.vendorAddress, this.orderedItemsOfVendor});

  ProcessedOrderedItems.fromJson(Map<String, dynamic> json) {
    vendor = json['vendor'];
    vendorType = json['vendorType'];
     vendorGstNumber = json['vendorGstNumber'];
     windowType = json['windowType'];
    vendorAddress = json['vendorAddress'] != null
        ? new VendorAddress.fromJson(json['vendorAddress'])
        : null;
    if (json['orderedItemsOfVendor'] != null) {
      orderedItemsOfVendor = new List<OrderedItemsOfVendor>();
      json['orderedItemsOfVendor'].forEach((v) {
        orderedItemsOfVendor.add(new OrderedItemsOfVendor.fromJson(v));
      });
    }
    vendorOrderSummary = json['vendorOrderSummary'] != null
        ? new VendorOrderSummary.fromJson(json['vendorOrderSummary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendor'] = this.vendor;
    data['vendorGstNumber'] = this.vendorGstNumber;
    data['windowType'] = this.windowType;
    data['vendorType'] = this.vendorType;
    if (this.vendorAddress != null) {
      data['vendorAddress'] = this.vendorAddress.toJson();
    }
    if (this.orderedItemsOfVendor != null) {
      data['orderedItemsOfVendor'] =
          this.orderedItemsOfVendor.map((v) => v.toJson()).toList();
    }
    if (this.vendorOrderSummary != null) {
      data['vendorOrderSummary'] = this.vendorOrderSummary.toJson();
    }
    return data;
  }
}
class VendorAddress {
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
  String primary;

  VendorAddress(
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

  VendorAddress.fromJson(Map<String, dynamic> json) {
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
class OrderedItemsOfVendor {
  String id;
  String orderId;
  String productId;
  String productName;
  String brandName;
  String overview;
  String image;
  String vendorId;
  String taxPerCent;
  String vendorType;
  String vendor;
  String categoryId;
  String subCategory1Id;
  String subCategory2Id;
  String subCategory3Id;
  int quantity;
  int returnPeriod;
  List<ProcessedPriceAndStocks> processedPriceAndStocks;
  ProcessedPriceAndStocks itemCurrentPrice;
  double totalAmount;
  ItemOrderStatus_ itemOrderStatus;
  bool Expired = true;
  OrderedItemsOfVendor(
      {this.id,
      this.orderId,
      this.productId,
      this.productName,
      this.brandName,
      this.overview,
      this.image,
      this.vendorId,
      this.vendorType,
      this.vendor,
      this.categoryId,
      this.taxPerCent,
      this.subCategory1Id,
      this.subCategory2Id,
      this.subCategory3Id,
      this.quantity,
      this.returnPeriod,
      this.processedPriceAndStocks,
      this.itemCurrentPrice,
      this.totalAmount,
      this.itemOrderStatus});

  OrderedItemsOfVendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
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
    taxPerCent = json['taxPerCent'].toString();
    quantity = json['quantity'];
    returnPeriod = json['returnPeriod'];
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
    itemOrderStatus = json['itemOrderStatus'] != null
        ? new ItemOrderStatus_.fromJson(json['itemOrderStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderId'] = this.orderId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['brandName'] = this.brandName;
    data['overview'] = this.overview;
    data['image'] = this.image;
    data['vendorId'] = this.vendorId;
    data['vendorType'] = this.vendorType;
    data['vendor'] = this.vendor;
    data['taxPerCent'] = this.taxPerCent;
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
    if (this.itemOrderStatus != null) {
      data['itemOrderStatus'] = this.itemOrderStatus.toJson();
    }
    return data;
  }
}

class ProcessedPriceAndStocks {
  int serialNumber;
  List<String> batchNumbers;
  int variant;
  String quantity;
  String unit;
  double price;
  dynamic discount;
  int stock;
  double sellingPrice;
  double salesIncentive;

  ProcessedPriceAndStocks(
      {this.serialNumber,
      this.batchNumbers,
      this.variant,
      this.quantity,
      this.unit,
      this.price,
      this.discount,
      this.salesIncentive,
      this.stock,
      this.sellingPrice});

  ProcessedPriceAndStocks.fromJson(Map<String, dynamic> json) {
    serialNumber = json['serialNumber'];
    batchNumbers = json['batchNumbers'].cast<String>();
    variant = json['variant'];
    quantity = json['quantity'];
    unit = json['unit'];
    price = json['price'];
    discount = json['discount'];
    salesIncentive = json['salesIncentive'];
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
    data['salesIncentive'] = this.salesIncentive;
    data['discount'] = this.discount;
    data['stock'] = this.stock;
    data['sellingPrice'] = this.sellingPrice;
    return data;
  }
}

class ItemOrderStatus_ {
  String currentStatus;
  int orderedDate;
  int expectedDeliveryDate;
  int packedDate;
  int shippedDate;
  dynamic shipmentTracker;
  int outForDelivery;
  int deliveredDate;
  int cancelledDate;
  int returnedDate;
  String refundReferenceId;
  int refundProcessedDate;
  bool cancelled = true;

  ItemOrderStatus_(
      {this.currentStatus,
      this.orderedDate,
      this.expectedDeliveryDate,
      this.packedDate,
      this.shippedDate,
      this.shipmentTracker,
      this.outForDelivery,
      this.deliveredDate,
      this.cancelledDate,
      this.returnedDate,
      this.refundReferenceId,
      this.refundProcessedDate});

  ItemOrderStatus_.fromJson(Map<String, dynamic> json) {
    currentStatus = json['currentStatus'];
    orderedDate = json['orderedDate'];
    expectedDeliveryDate = json['expectedDeliveryDate'];
    packedDate = json['packedDate'];
    shippedDate = json['shippedDate'];
    shipmentTracker = json['shipmentTracker'];
    outForDelivery = json['outForDelivery'];
    deliveredDate = json['deliveredDate'];
    cancelledDate = json['cancelledDate'];
    returnedDate = json['returnedDate'];
    refundReferenceId = json['refundReferenceId'];
    refundProcessedDate = json['refundProcessedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentStatus'] = this.currentStatus;
    data['orderedDate'] = this.orderedDate;
    data['expectedDeliveryDate'] = this.expectedDeliveryDate;
    data['packedDate'] = this.packedDate;
    data['shippedDate'] = this.shippedDate;
    data['shipmentTracker'] = this.shipmentTracker;
    data['outForDelivery'] = this.outForDelivery;
    data['deliveredDate'] = this.deliveredDate;
    data['cancelledDate'] = this.cancelledDate;
    data['returnedDate'] = this.returnedDate;
    data['refundReferenceId'] = this.refundReferenceId;
    data['refundProcessedDate'] = this.refundProcessedDate;
    return data;
  }
}
class VendorOrderSummary {
  dynamic bagTotal;
  dynamic totalDiscount;
  dynamic totalTax;
  dynamic subTotal;
  dynamic deliveryCharge;
  dynamic totalPrice;

  VendorOrderSummary(
      {this.bagTotal,
        this.totalDiscount,
        this.totalTax,
        this.subTotal,
        this.deliveryCharge,
        this.totalPrice});

  VendorOrderSummary.fromJson(Map<String, dynamic> json) {
    bagTotal = json['bagTotal'];
    totalDiscount = json['totalDiscount'];
    totalTax = json['totalTax'];
    subTotal = json['subTotal'];
    deliveryCharge = json['deliveryCharge'];
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bagTotal'] = this.bagTotal;
    data['totalDiscount'] = this.totalDiscount;
    data['totalTax'] = this.totalTax;
    data['subTotal'] = this.subTotal;
    data['deliveryCharge'] = this.deliveryCharge;
    data['totalPrice'] = this.totalPrice;
    return data;
  }
}
