import 'dart:convert';

class SubscriptionModel {
  String subscriptionValue;
  String  daysBetweenOrder;
  

  factory SubscriptionModel.fromRawJson(String str) =>
      SubscriptionModel.fromJson(json.decode(str));

  SubscriptionModel(this.subscriptionValue, this.daysBetweenOrder);

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    subscriptionValue = json['subscriptionValue'];
    daysBetweenOrder = json['daysBetweenOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscriptionValue'] = this.subscriptionValue;
    data['daysBetweenOrder'] = this.daysBetweenOrder;
    return data;
  }
}


