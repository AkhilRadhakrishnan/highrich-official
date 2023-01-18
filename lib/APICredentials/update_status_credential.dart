/*
 *  2021 Highrich.in
 */
class UpdateStatusModel {
  bool isNewBankAccount;
  bool isPrimaryAccount;
  String id;
  ShipmentTrackerCredential shipmentTracker;
  AccountCredential account;

  UpdateStatusModel(
      {this.isNewBankAccount,
        this.isPrimaryAccount,
        this.id,
        this.shipmentTracker,
        this.account});

  UpdateStatusModel.fromJson(Map<String, dynamic> json) {

    isNewBankAccount = json['isNewBankAccount'];
    isPrimaryAccount = json['isPrimaryAccount'];
    id = json['id'];
    shipmentTracker = json['shipmentTracker'] =new ShipmentTrackerCredential.fromJson(json['shipmentTracker']);
    // shipmentTracker = json['shipmentTracker'] != null
    //     ? new ShipmentTrackerCredential.fromJson(json['shipmentTracker'])
    //     : null;

    if (this.account != null) {
      account = json['account'] != null ? new AccountCredential.fromJson(json['account']) : null;
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.isNewBankAccount != null) {
      data['isNewBankAccount'] = this.isNewBankAccount;
    }
    if (this.isPrimaryAccount != null) {
      data['isPrimaryAccount'] = this.isPrimaryAccount;
    }

    data['id'] = this.id;
    if (this.shipmentTracker != null) {
      data['shipmentTracker'] = this.shipmentTracker.toJson();
    }
    if (this.account != null) {
      data['account'] = this.account.toJson();
    }
    return data;
  }
}

class ShipmentTrackerCredential {
  String trackingId;
  String trackingLink;

  ShipmentTrackerCredential({this.trackingId, this.trackingLink});

  ShipmentTrackerCredential.fromJson(Map<String, dynamic> json) {
    trackingId = json['trackingId'];
    trackingLink = json['trackingLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trackingId'] = this.trackingId;
    data['trackingLink'] = this.trackingLink;
    return data;
  }
}

class AccountCredential {
  String accountHolderName;
  String bankName;
  String ifscCode;
  String accountNumber;
  String branch;

  AccountCredential(
      {this.accountHolderName,
        this.bankName,
        this.ifscCode,
        this.accountNumber,
        this.branch});

  AccountCredential.fromJson(Map<String, dynamic> json) {
    accountHolderName = json['accountHolderName'];
    bankName = json['bankName'];
    ifscCode = json['ifscCode'];
    accountNumber = json['accountNumber'];
    branch = json['branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountHolderName'] = this.accountHolderName;
    data['bankName'] = this.bankName;
    data['ifscCode'] = this.ifscCode;
    data['accountNumber'] = this.accountNumber;
    data['branch'] = this.branch;
    return data;
  }
}