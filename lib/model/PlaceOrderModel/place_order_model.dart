import 'dart:convert';

class PlaceOrderModel {
  String status;
  String message;
  String failureType;
  List<String> cartItemIds;
  Order order;

  PlaceOrderModel(
      {this.status,
        this.message,
        this.failureType,
        this.cartItemIds,
        this.order});

  factory PlaceOrderModel.fromRawJson(String str) =>
      PlaceOrderModel.fromJson(json.decode(str));


  PlaceOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    failureType = json['failureType'];
    cartItemIds = json['cartItemIds']?.cast<String>();
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['failureType'] = this.failureType;
    data['cartItemIds'] = this.cartItemIds;
    if (this.order != null) {
      data['order'] = this.order.toJson();
    }
    return data;
  }
}

class Order {
  String customerId;
  String paymentMode;
  String cartId;
  double deliveryCharge;
  double totalPrice;
  dynamic subTotal;
  String customerName;
  String customerEmail;
  ShippingAddress shippingAddress;
  double bagTotal;
  double totalDiscount;
  double totalTax;
  int orderedDate;
  List<OrderedItems> orderedItems;
  String orderGroupId;
  String orderStatus;
  String paymentStatus;
  String razorPayCustomerId;
  String razorPayOrderId;

  Order(
      {this.customerId,
        this.paymentMode,
        this.cartId,
        this.deliveryCharge,
        this.totalPrice,
        this.subTotal,
        this.customerName,
        this.customerEmail,
        this.shippingAddress,
        this.bagTotal,
        this.totalDiscount,
        this.totalTax,
        this.orderedDate,
        this.orderedItems,
        this.orderGroupId,
        this.orderStatus,
        this.paymentStatus,
        this.razorPayCustomerId,
        this.razorPayOrderId
      });

  Order.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    paymentMode = json['paymentMode'];
    cartId = json['cartId'];
    deliveryCharge = json['deliveryCharge'];
    totalPrice = json['totalPrice'];
    subTotal = json['subTotal'];
    customerName = json['customerName'];
    customerEmail = json['customerEmail'];
    shippingAddress = json['shippingAddress'] != null
        ? new ShippingAddress.fromJson(json['shippingAddress'])
        : null;
    bagTotal = json['bagTotal'];
    totalDiscount = json['totalDiscount'];
    totalTax = json['totalTax'];
    orderedDate = json['orderedDate'];
    if (json['orderedItems'] != null) {
      orderedItems = new List<OrderedItems>();
      json['orderedItems'].forEach((v) {
        orderedItems.add(new OrderedItems.fromJson(v));
      });
    }
    orderGroupId = json['orderGroupId'];
    orderStatus = json['orderStatus'];
    paymentStatus = json['paymentStatus'];
    razorPayCustomerId = json['razorPayCustomerId'];
    razorPayOrderId = json['razorPayOrderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['paymentMode'] = this.paymentMode;
    data['cartId'] = this.cartId;
    data['deliveryCharge'] = this.deliveryCharge;
    data['totalPrice'] = this.totalPrice;
    data['subTotal'] = this.subTotal;
    data['customerName'] = this.customerName;
    data['customerEmail'] = this.customerEmail;
    if (this.shippingAddress != null) {
      data['shippingAddress'] = this.shippingAddress.toJson();
    }
    data['bagTotal'] = this.bagTotal;
    data['totalDiscount'] = this.totalDiscount;
    data['totalTax'] = this.totalTax;
    data['orderedDate'] = this.orderedDate;
    if (this.orderedItems != null) {
      data['orderedItems'] = this.orderedItems.map((v) => v.toJson()).toList();
    }
    data['orderGroupId'] = this.orderGroupId;
    data['orderStatus'] = this.orderStatus;
    data['paymentStatus'] = this.paymentStatus;
    data['razorPayCustomerId'] = this.razorPayCustomerId;
    data['razorPayOrderId'] = this.razorPayOrderId;
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

class OrderedItems {
  String id;
  String orderId;
  String productId;
  String productName;
  String brandName;
  String overview;
  String image;
  String vendorId;
  String vendorType;
  String vendor;
  String windowType;
  String categoryId;
  String subCategory1Id;
  String subCategory2Id;
  String subCategory3Id;
  int quantity;
  List<ProcessedPriceAndStocks> processedPriceAndStocks;
  ProcessedPriceAndStocks itemCurrentPrice;
  double totalAmount;
  ItemOrderStatus itemOrderStatus;

  OrderedItems(
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
        this.windowType,
        this.categoryId,
        this.subCategory1Id,
        this.subCategory2Id,
        this.subCategory3Id,
        this.quantity,
        this.processedPriceAndStocks,
        this.itemCurrentPrice,
        this.totalAmount,
        this.itemOrderStatus});

  OrderedItems.fromJson(Map<String, dynamic> json) {
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
    windowType = json['windowType'];
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
    itemOrderStatus = json['itemOrderStatus'] != null
        ? new ItemOrderStatus.fromJson(json['itemOrderStatus'])
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
    data['windowType'] = this.windowType;
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

  ProcessedPriceAndStocks(
      {this.serialNumber,
        this.batchNumbers,
        this.variant,
        this.quantity,
        this.unit,
        this.price,
        this.discount,
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

class ItemOrderStatus {
  String currentStatus;
  int orderedDate;
  String expectedDeliveryDate;
  String packedDate;
  String shippedDate;
  String shipmentTracker;
  String outForDelivery;
  String deliveredDate;
  String cancelledDate;
  String returnedDate;
  String refundReferenceId;
  String refundProcessedDate;

  ItemOrderStatus(
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

  ItemOrderStatus.fromJson(Map<String, dynamic> json) {
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