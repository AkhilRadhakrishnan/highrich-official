import 'dart:convert';

class ProfileModel {
  String status;
  int count;
  Profile profile;
  String message;

  ProfileModel({this.status, this.count, this.profile, this.message});


  factory ProfileModel.fromRawJson(String str) =>
      ProfileModel.fromJson(json.decode(str));


  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['count'] = this.count;
    if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Profile {
  String index;
  String type;
  String id;
  int version;
  Source source;

  Profile({this.index, this.type, this.id, this.version, this.source});

  Profile.fromJson(Map<String, dynamic> json) {
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
  String name;
  String email;
  String mobile;
  String pinCode;
  bool socialSignIn;
  int date;
  String userCode;
  String memberId;
  String affiliateId;
  String referralId;
//  List<String> cartIds;
//  List<String> cartProductIds=[];
  List<Address> address;
  String primaryAddressId;
  String razorPayCustomerId;
  List<dynamic> image;

  Source(
      {this.name,
        this.email,
        this.mobile,
        this.pinCode,
        this.socialSignIn,
        this.date,
        this.userCode,
        this.memberId,
        this.affiliateId,
        this.referralId,
      //  this.cartIds,
       // this.cartProductIds,
        this.address,
        this.primaryAddressId,
        this.razorPayCustomerId,
        this.image
      });

  Source.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    pinCode = json['pinCode'];
    socialSignIn = json['socialSignIn'];
    date = json['date'];
    userCode = json['userCode'];
    memberId = json['memberId'];
    affiliateId = json['affiliateId'];
    referralId = json['referralId'];
  //  cartIds = json['cartIds'].cast<String>();

    image = json['image'];
  //  cartProductIds = json['cartProductIds'];

    if (json['address'] != null) {
      address = new List<Address>();
      json['address'].forEach((v) {
        address.add(new Address.fromJson(v));
      });
    }
    primaryAddressId = json['primaryAddressId'];
    razorPayCustomerId = json['razorPayCustomerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['pinCode'] = this.pinCode;
    data['socialSignIn'] = this.socialSignIn;
    data['date'] = this.date;
    data['userCode'] = this.userCode;
    data['memberId'] = this.memberId;
    data['affiliateId'] = this.affiliateId;
    data['referralId'] = this.referralId;
  //  data['cartIds'] = this.cartIds;
    data['image'] = this.image;
  //  data['cartProductIds'] = this.cartProductIds;

    if (this.address != null) {
      data['address'] = this.address.map((v) => v.toJson()).toList();
    }
    data['primaryAddressId'] = this.primaryAddressId;
    data['razorPayCustomerId'] = this.razorPayCustomerId;
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