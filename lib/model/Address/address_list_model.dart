import 'dart:convert';

class AddressListModel {
  String status;
  int count;
  List<Address> address;

  AddressListModel({this.status, this.count, this.address});

  factory AddressListModel.fromRawJson(String str) =>
      AddressListModel.fromJson(json.decode(str));


  AddressListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    if (json['address'] != null) {
      address = new List<Address>();
      json['address'].forEach((v) {
        address.add(new Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['count'] = this.count;
    if (this.address != null) {
      data['address'] = this.address.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  String addressType;
  String emailId;
  String phoneNo;
  String buildingName;
  String ownerName;
  String pinCode;
  String district;
  String addressLine1;
  String addressLine2;
  String id;
  String alternatePhoneNo;
  String state;
  bool primary;

  Address(
      {this.addressType,
        this.emailId,
        this.phoneNo,
        this.buildingName,
        this.ownerName,
        this.pinCode,
        this.district,
        this.addressLine1,
        this.addressLine2,
        this.id,
        this.alternatePhoneNo,
        this.state,
        this.primary});

  Address.fromJson(Map<String, dynamic> json) {
    addressType = json['addressType'];
    emailId = json['emailId'];
    phoneNo = json['phoneNo'];
    buildingName = json['buildingName'];
    ownerName = json['ownerName'];
    pinCode = json['pinCode'];
    district = json['district'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    id = json['id'];
    alternatePhoneNo = json['alternatePhoneNo'];
    state = json['state'];
    primary = json['primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressType'] = this.addressType;
    data['emailId'] = this.emailId;
    data['phoneNo'] = this.phoneNo;
    data['buildingName'] = this.buildingName;
    data['ownerName'] = this.ownerName;
    data['pinCode'] = this.pinCode;
    data['district'] = this.district;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['id'] = this.id;
    data['alternatePhoneNo'] = this.alternatePhoneNo;
    data['state'] = this.state;
    data['primary'] = this.primary;
    return data;
  }
}