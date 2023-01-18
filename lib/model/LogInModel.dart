import 'dart:convert';

class LogInModel {
  String token;
  String userId;
  String accountType;
  int createdDate;
  String pinCode;
  String name;
  String status;
  String message;
  String type;
  String highRichId;

  LogInModel(
      {this.token,
        this.userId,
        this.accountType,
        this.createdDate,
        this.pinCode,
        this.name,
        this.status,
        this.message,
        this.type,
        this.highRichId
      });

  LogInModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userId = json['userId'];
    accountType = json['accountType'];
    createdDate = json['createdDate'];
    pinCode = json['pinCode'];
    name = json['name'];
    status = json['status'];
    message = json['message'];
    type = json['type'];
    highRichId = json['highRichId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['userId'] = this.userId;
    data['accountType'] = this.accountType;
    data['createdDate'] = this.createdDate;
    data['pinCode'] = this.pinCode;
    data['name'] = this.name;
    data['status'] = this.status;
    data['message'] = this.message;
    data['type'] = this.type;
    data['highRichId'] = this.highRichId;
    return data;
  }
  factory LogInModel.fromRawJson(String str) =>
      LogInModel.fromJson(json.decode(str));
}