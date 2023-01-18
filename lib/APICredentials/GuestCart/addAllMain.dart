import 'package:highrich/APICredentials/GuestCart/addAllToCartCredentials.dart';
/*
 *  2021 Highrich.in
 */
class AddAllMain{
String userId;
String accountType;
List<AddAllToCartCredentials> cartItems;
AddAllMain(
    {
       this.userId,
       this.accountType,
       this.cartItems,
    });

AddAllMain.fromJson(Map<String, dynamic> json) {
  userId = json['userId'];
  accountType = json['accountType'];
  if (json['cartItems'] != null) {
    cartItems = new List<AddAllToCartCredentials>();
    json['cartItems'].forEach((v) {
      cartItems.add(new AddAllToCartCredentials.fromJson(v));
    });
  }
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['userId'] = this.userId;
  data['accountType'] = this.accountType;
  if (this.cartItems != null) {
    data['cartItems'] =
        this.cartItems.map((v) => v.toJson()).toList();
  }
  return data;
}
}