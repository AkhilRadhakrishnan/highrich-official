import 'dart:convert';
import 'package:highrich/APICredentials/ProductListing/getContentProductsCredentials.dart';
import 'package:highrich/APICredentials/ProductListing/productlistingcredentials.dart';
import 'package:highrich/APICredentials/add_to_cart.dart';
import 'package:highrich/APICredentials/update_status_credential.dart';
import 'package:highrich/APICredentials/updatecart_credential.dart';
import 'package:highrich/Network/api.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/model/Address/address_list_model.dart';
import 'package:highrich/model/CartModel/cart_count_model.dart';
import 'package:highrich/model/CartModel/delivery_charge_model.dart';
import 'package:highrich/model/LogInModel.dart';
import 'package:highrich/model/MyOrders/orders_model.dart';
import 'package:highrich/model/MyOrders/subscription_response_model.dart';
import 'package:highrich/model/MyReturns/my_returns.dart';
import 'package:highrich/model/MyReturns/reason_for_return_model.dart';
import 'package:highrich/model/PlaceOrderModel/place_order_model.dart';
import 'package:highrich/model/Profile/profile_model.dart';
import 'package:highrich/model/Search/search_suggestion.dart';
import 'package:highrich/model/fast_moving_model.dart';
import 'package:highrich/model/cancel_order_reason.dart';
import 'package:highrich/model/cart_model.dart';
import 'package:highrich/model/category_model.dart';
import 'package:highrich/model/check_availability_model.dart';
import 'package:highrich/model/check_deliverylocation_model.dart';
import 'package:highrich/model/default_model.dart';
import 'package:highrich/model/deliveryCharge.dart';
import 'package:highrich/model/filter_response_model.dart';
import 'package:highrich/model/home_model.dart';
import 'package:highrich/model/get_brand_model.dart';
import 'package:highrich/model/product_detail_model.dart';
import 'package:highrich/model/product_model.dart';
import 'package:highrich/model/HomeModel/app_update_model.dart';
import 'package:highrich/model/Address/district_suggestion_model.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RequestType { GET, POST, DELETE, PATCH, PUT }

class RequestTypeNotFoundException implements Exception {
  String cause;

  RequestTypeNotFoundException(this.cause);
}

class Nothing {
  Nothing._();
}

class RemoteDataSource {
  ApiClient client = new ApiClient(Client());

  //LogIn api call
  Future<Result> login(String email, String password) async {
    ApiClient client = new ApiClient(Client());
    final response = await client.request(
        requestType: RequestType.POST,
        path: "login",
        parameter: {
          "username": email,
          "password": password,
          "accountType": "customer"
        });
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<LogInModel>.success(LogInModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<LogInModel>.unAuthored(
          LogInModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //SignUp api call
  Future<Result> signup(Map reqBody) async {
    print(reqBody);
    final response = await client.request(
        requestType: RequestType.PUT, path: "user/signup", parameter: reqBody);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<DefaultModel>.success(defaultModelFromJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          defaultModelFromJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Forgot password api call
  Future<Result> forgot_password(String email) async {
    final response = await client.request(
        requestType: RequestType.POST,
        path: "forgot-password",
        parameter: {"email": email, "accountType": "customer"});
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<DefaultModel>.success(defaultModelFromJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          defaultModelFromJson(response.body));
    } else {
      print('Failed.');
      return Result.error('Failed..');
    }
  }

  //Reset password api call
  Future<Result> reset_password(String otp, String email, String newPassword,
      String confirmPassword, String highrichID) async {
    final response = await client.request(
        requestType: RequestType.POST,
        path: "reset/forgot-password",
        parameter: {
          "otp": int.parse(otp),
          "email": email,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
          "highRichId": highrichID
        });
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<DefaultModel>.success(defaultModelFromJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          defaultModelFromJson(response.body));
    } else {
      print('Failed.');
      return Result.error('Failed..');
    }
  }

  //Change  password api call
  Future<Result> change_password(String email, String currentPassword,
      String newPassword, String confirmPassword, String userId) async {
    final response = await client.request(
        requestType: RequestType.POST,
        path: "user/reset-password",
        parameter: {
          "email": email,
          "currentPassword": currentPassword,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
          "userId": userId
        });

    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<DefaultModel>.success(defaultModelFromJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          defaultModelFromJson(response.body));
    } else {
      print('Failed.');
      return Result.error('Failed..');
    }
  }

  //Home Listing api call
  Future<Result> getHomeAPI(String pinCode) async {
    try {
      final response = await client.request(
          requestType: RequestType.POST, path: "home", parameter: pinCode);
      print(response.request);

      if (response.statusCode == 200) {
        print(response.body);
        var rawCookie = response.headers['set-cookie'];
        return Result<HomeModel>.success(HomeModel.fromRawJson(response.body));
      }
      if (response.statusCode == 401) {
        return Result<HomeModel>.unAuthored(
            HomeModel.fromRawJson(response.body));
      } else {
        print('Failed ');
        return Result.error('Failed ');
      }
    } on Exception catch (exception) {
      print(exception.toString());
      if (exception.toString().contains('Connection failed') ||
          exception.toString().contains('Network is unreachable')) {
        return Result.error(exception.toString());
      }
      return Result.error('Something went wrong. Please try again');
    } catch (error) {
      return Result.error(error);
    }
  }

  //Product Listing api call
  Future<Result> productListing(
      ProductListingCredentials productListingCredentials,
      {bool isFromFMCG = false}) async {
    print("*** Params ProductListing  ****");
    print(json.encode(productListingCredentials));

    final response = await client.request(
        requestType: RequestType.POST,
        path: isFromFMCG ? "product/fast-moving/list" : "product/search/filter",
        parameter: productListingCredentials);
    print("============search=========");
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<ProductsModel>.success(
          ProductsModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<ProductsModel>.unAuthored(
          ProductsModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Product Listing api section/get-contents call
  Future<Result> getContentProducts(
      GetContentProductsCredentials getContentProductsCredentials,
      {bool isFromFMCG = false}) async {
    print("*** Params Contents  ****");
    print(json.encode(getContentProductsCredentials));
    final response = await client.request(
        requestType: RequestType.POST,
        path: isFromFMCG ? "product/fast-moving/list" : "section/get-contents",
        parameter: getContentProductsCredentials);
    print("****get-contents***");
    print(response.request);
    print(jsonEncode(getContentProductsCredentials));

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<ProductsModel>.success(
          ProductsModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<ProductsModel>.unAuthored(
          ProductsModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Product Listing api section/get-contents call
  Future<Result> productFilterSection(var getContentProductsCredentials) async {
    print(json.encode(getContentProductsCredentials));
    final response = await client.request(
        requestType: RequestType.POST,
        path: "product/brand-category-list",
        parameter: getContentProductsCredentials);
    print("**BRAND CATEGORY LIST");
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<FilterResponseModel>.success(
          FilterResponseModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<FilterResponseModel>.unAuthored(
          FilterResponseModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Product Listing api section/get-contents call
  Future<Result> productFilterSearchFilter(
      dynamic productListingCredentials) async {
    print(json.encode(productListingCredentials));
    final response = await client.request(
        requestType: RequestType.POST,
        path: "product/brand-category-list",
        parameter: productListingCredentials);
    print("**BRAND CATEGORY LIST---productListingCredentials");
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<FilterResponseModel>.success(
          FilterResponseModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<FilterResponseModel>.unAuthored(
          FilterResponseModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Brand images api category/get-brand call
  Future<Result> getBrand(dynamic getBrand) async {
    print(json.encode(getBrand));
    final response = await client.request(
        requestType: RequestType.POST,
        path: "category/get-brand",
        parameter: getBrand);
    print("response.request**************");
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<GetBrandModel>.success(
          GetBrandModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<GetBrandModel>.unAuthored(
          GetBrandModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Fast moving api
  Future<Result> fastMovingProducts(dynamic fastMovingProducts) async {
    print(json.encode(fastMovingProducts));
    final response = await client.request(
        requestType: RequestType.POST,
        path: "product/fast-moving",
        parameter: fastMovingProducts);
    print("*****FAST MOVING REQUEST******");
    print(response.request);

    if (response.statusCode == 200) {
      print("*****FAST MOVING RESPONSE******");
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<FastMovingModel>.success(
          FastMovingModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<FastMovingModel>.unAuthored(
          FastMovingModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Advertisement Api
  Future<Result> advertismentClick(dynamic advertismentClick) async {
    print(json.encode(advertismentClick));
    final response = await client.request(
        requestType: RequestType.POST,
        path: "advertisement/users/action",
        parameter: advertismentClick);
    print("*****Advertisement Banner Request******");
    print(response.request);

    if (response.statusCode == 200) {
      print("*****Advertisement Click Response******");
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<FastMovingModel>.success(
          FastMovingModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<FastMovingModel>.unAuthored(
          FastMovingModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Product Detail api call
  Future<Result> productDetail(String userId, String accountType,
      String productID, String pinCode) async {
    final response = await client.request(
        requestType: RequestType.POST,
        path: "product/details/" + productID,
        parameter: {
          "userId": userId,
          "accountType": accountType,
          "pinCode": pinCode
        });

    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<ProductDetailModel>.success(
          ProductDetailModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<ProductDetailModel>.unAuthored(
          ProductDetailModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  // Delivery charge for subscription
  Future<Result> deliveryCharge(double totalAmount, double totalWeight) async {
    final response = await client.request(
        requestType: RequestType.POST,
        path: "user/cart/calculate-delivery-charge_subscription",
        parameter: {"totalAmount": totalAmount, "totalWeights": totalWeight});

    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<DeliveryCharge>.success(
          DeliveryCharge.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DeliveryCharge>.unAuthored(
          DeliveryCharge.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Check Availability API
  Future<Result> checkAvailabilityAPI(String productID, String pinCode) async {
    String url = "product/" + productID + "/availability/" + pinCode;
    final response =
        await client.request(requestType: RequestType.GET, path: url);
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<CheckAvailabilityModel>.success(
          CheckAvailabilityModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<CheckAvailabilityModel>.unAuthored(
          CheckAvailabilityModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Check Delivery location using pincode
  Future<Result> checkDeliveryLocation(String pinCode) async {
    String url = "product/availability-pincode/" + pinCode;
    final response =
        await client.request(requestType: RequestType.GET, path: url);
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<CheckDeliveryLocationModel>.success(
          CheckDeliveryLocationModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<CheckDeliveryLocationModel>.unAuthored(
          CheckDeliveryLocationModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

//Category api call
  Future<Result> getCategory() async {
    final response = await client.request(
        requestType: RequestType.POST,
        path: "multilevel/category",
        parameter: {"processResponse": true});
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<CategoryModel>.success(
          CategoryModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<CategoryModel>.unAuthored(
          CategoryModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Add Subscription
  Future<Result> addSubscription(Map reqBody) async {
    final response = await client.request(
        requestType: RequestType.POST,
        path: "order/add-subscription",
        parameter: reqBody);
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<DefaultModel>.success(
          DefaultModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          DefaultModel.fromRawJson(response.body));
    } else {
      print('Failed to Cart ');
      return Result.error('Failed Cart');
    }
  }

  //Add All to Cart
  Future<Result> addAllToCart(Map reqBody) async {
    final response = await client.request(
        requestType: RequestType.PUT,
        path: "user/cart/add-all",
        parameter: reqBody);
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<DefaultModel>.success(
          DefaultModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          DefaultModel.fromRawJson(response.body));
    } else {
      print('Failed to Cart ');
      return Result.error('Failed Cart');
    }
  }

// Add to cart
  Future<Result> addToCart(
      String userId,
      String productId,
      String vendorId,
      String vendorType,
      int quantity,
      String token,
      ItemCurrentPrice itemCurrentPrice) async {
    AddToCartModel addToCartCredential = new AddToCartModel();
    addToCartCredential.userId = userId;
    addToCartCredential.accountType = "customer";

    Item item = new Item();
    item.productId = productId;
    item.vendorId = vendorId;
    item.vendorType = vendorType;
    item.quantity = quantity;
    item.itemCurrentPrice = itemCurrentPrice;

    addToCartCredential.item = item;

    final response = await client.request(
      requestType: RequestType.PUT,
      path: "user/cart/add",
      parameter: addToCartCredential,
    );
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<DefaultModel>.success(
          DefaultModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          DefaultModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

// Add to cart
  Future<Result> updateCart(UpdateCartCredential updateCartCredential) async {
    print("update Params");
    print(jsonEncode(updateCartCredential));

    final response = await client.request(
      requestType: RequestType.POST,
      path: "user/cart/update",
      parameter: updateCartCredential,
    );
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<DefaultModel>.success(
          DefaultModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          DefaultModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //get Delivery Charge api call
  Future<Result> getDeliveryCharge(Map reqBody) async {
    final response = await client.request(
        requestType: RequestType.POST,
        path: "user/cart/calculate-delivery-charge",
        parameter: reqBody);
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<DeliveryChargeModel>.success(
          DeliveryChargeModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DeliveryChargeModel>.unAuthored(
          DeliveryChargeModel.fromRawJson(response.body));
    } else {
      print('Failed to Cart ');
      return Result.error('Failed Cart');
    }
  }

  //get Cart api call
  Future<Result> getCart(Map reqBody) async {
    final response = await client.request(
        requestType: RequestType.POST,
        path: "user/cart/get",
        parameter: reqBody);
    print(reqBody);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<CartModel>.success(CartModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<CartModel>.unAuthored(CartModel.fromRawJson(response.body));
    } else {
      print('Failed to Cart ');
      return Result.error('Failed Cart');
    }
  }

  //get Cart api call
  Future<Result> getCartCount(String userId) async {
    String url = "user/" + userId + "/customer/cart-items/count";
    final response = await client.request(
      requestType: RequestType.GET,
      path: url,
    );
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<CartCountModel>.success(
          CartCountModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<CartCountModel>.unAuthored(
          CartCountModel.fromRawJson(response.body));
    } else {
      print('Failed to Cart ');
      return Result.error('Failed Cart');
    }
  }

  //Address Listing api call
  Future<Result> addressListing(userId) async {
    String url = "user/" + userId + "/address/all";
    final response = await client.request(
      requestType: RequestType.GET,
      path: url,
    );
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<AddressListModel>.success(
          AddressListModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<AddressListModel>.unAuthored(
          AddressListModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Add address api call
  Future<Result> addAddress(Map reqBody) async {
    print(jsonEncode(reqBody));
    final response = await client.request(
        requestType: RequestType.PUT,
        path: "user/address/create",
        parameter: reqBody);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<DefaultModel>.success(defaultModelFromJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          defaultModelFromJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Update address api call
  Future<Result> updateAddress(Map reqBody) async {
    print(reqBody);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "user/address/update",
        parameter: reqBody);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<DefaultModel>.success(defaultModelFromJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          defaultModelFromJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Set Default address api call
  Future<Result> setDefaultAddress(userId, addressId) async {
    String url = "user/address/set-default";
    final response = await client.request(
        requestType: RequestType.POST,
        path: url,
        parameter: {"userId": userId, "addressId": addressId});
    print(response.request);

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<DefaultModel>.success(
          DefaultModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          DefaultModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed');
    }
  }

  //Place order API
  Future<Result> placeOrderAPI(Map reqBody) async {
    String url = "order/add";
    final response = await client.request(
        requestType: RequestType.POST, path: url, parameter: reqBody);
    print(jsonEncode(reqBody));

    if (response.statusCode == 200) {
      print(response.body);
      var rawCookie = response.headers['set-cookie'];
      return Result<PlaceOrderModel>.success(
          PlaceOrderModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<PlaceOrderModel>.unAuthored(
          PlaceOrderModel.fromRawJson(response.body));
    } else {
      print('Failed');
      return Result.error('Failed');
    }
  }

  //Online paymenet verification api call
  Future<Result> verifyPayment(Map paymentBody, String) async {
    print(paymentBody);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "order/verify-payment",
        parameter: paymentBody);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<DefaultModel>.success(defaultModelFromJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          defaultModelFromJson(response.body));
    } else {
      print('Failed');
      return Result.error('Failed');
    }
  }

  //Delete Single Item From Cart
  Future<Result> deleteSingleItemFromCart(Map reqBody) async {
    print(reqBody);
    final response = await client.request(
        requestType: RequestType.DELETE,
        path: "user/cart/item/delete",
        parameter: reqBody);
    print(response.request);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<DefaultModel>.success(defaultModelFromJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          defaultModelFromJson(response.body));
    } else {
      print('Failed');
      return Result.error('Failed');
    }
  }

  //Get My Orders  api call
  Future<Result> getMyOrders(Map myOrdersReqBody) async {
    print(myOrdersReqBody);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "order/customer/list-search",
        parameter: myOrdersReqBody);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<OrdersModel>.success(
          OrdersModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<OrdersModel>.unAuthored(
          OrdersModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Get My Orders  api call
  Future<Result> getSubscriptonListing(Map myOrdersReqBody) async {
    print(myOrdersReqBody);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "order/get-subscriptions",
        parameter: myOrdersReqBody);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<SubscriptionResponseModel>.success(
          SubscriptionResponseModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<SubscriptionResponseModel>.unAuthored(
          SubscriptionResponseModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

//TeOrders  api call
  Future<Result> reorderAPI(Map reorderPayLoad) async {
    print(reorderPayLoad);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "order/re-order",
        parameter: reorderPayLoad);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<DefaultModel>.success(
          DefaultModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          DefaultModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Get My Orders  api call
  Future<Result> cancelSubscription(Map myOrdersReqBody) async {
    print(myOrdersReqBody);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "order/cancel-subscriptions",
        parameter: myOrdersReqBody);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<DefaultModel>.success(
          DefaultModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          DefaultModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Get My Returns  api call
  Future<Result> getMyReturns(Map myreturnsReqBody) async {
    print(myreturnsReqBody);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "return/customer/list-orders",
        parameter: myreturnsReqBody);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<MyRetunsModel>.success(
          MyRetunsModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<MyRetunsModel>.unAuthored(
          MyRetunsModel.fromRawJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //Cancel  api call
  Future<Result> cancelOrders(Map cancelOrdersReqBody) async {
    print(cancelOrdersReqBody);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "order/item/cancel",
        parameter: cancelOrdersReqBody);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<DefaultModel>.success(
          DefaultModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          DefaultModel.fromRawJson(response.body));
    } else {
      print('Failed');
      return Result.error('Failed');
    }
  }

  //Return order  api call
  Future<Result> returnOrderRequest(Map returnOrdersReqBody) async {
    print(returnOrdersReqBody);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "return/raise-request",
        parameter: returnOrdersReqBody);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<DefaultModel>.success(
          DefaultModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          DefaultModel.fromRawJson(response.body));
    } else {
      print('Failed');
      return Result.error('Failed');
    }
  }

  //updateStatus from My returns
  Future<Result> updateStatus(UpdateStatusModel updateStatusModel) async {
    print(jsonEncode(updateStatusModel));
    final response = await client.request(
        requestType: RequestType.POST,
        path: "return/customer/update-details",
        parameter: updateStatusModel);

    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<DefaultModel>.success(
          DefaultModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          DefaultModel.fromRawJson(response.body));
    } else {
      print('Failed');
      return Result.error('Failed');
    }
  }

  //Cancel  Order reasons for drop down
  Future<Result> cancelOrderReason() async {
    final response = await client.request(
        requestType: RequestType.GET, path: "admin/get/cancel-reasons");
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<CancelOrderReasonModel>.success(
          CancelOrderReasonModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<CancelOrderReasonModel>.unAuthored(
          CancelOrderReasonModel.fromRawJson(response.body));
    } else {
      print('Failed');
      return Result.error('Failed');
    }
  }

  //Reason for Return
  Future<Result> returnReasons() async {
    final response = await client.request(
        requestType: RequestType.GET, path: "admin/get/return-reasons");
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<ReasonForReturnModel>.success(
          ReasonForReturnModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<ReasonForReturnModel>.unAuthored(
          ReasonForReturnModel.fromRawJson(response.body));
    } else {
      print('Failed');
      return Result.error('Failed');
    }
  }

  //Profile  api call
  Future<Result> getProfile(Map profileReqBody) async {
    print(profileReqBody);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "user/profile",
        parameter: profileReqBody);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<ProfileModel>.success(
          ProfileModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<ProfileModel>.unAuthored(
          ProfileModel.fromRawJson(response.body));
    } else {
      print('Failed to fetch profile ');
      return Result.error('Failed to fetch profile ');
    }
  }

  //Update Profile Details
  Future<Result> updateProfile(Map reqBody) async {
    print(reqBody);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "user/account/update",
        parameter: reqBody);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<DefaultModel>.success(defaultModelFromJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DefaultModel>.unAuthored(
          defaultModelFromJson(response.body));
    } else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  //District
  Future<Result> districtSuggestion(Map districtSuggestion) async {
    print(districtSuggestion);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "get-districts-by-state",
        parameter: districtSuggestion);
    print(response.request);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<DistrictModel>.success(
          DistrictModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<DistrictModel>.unAuthored(
          DistrictModel.fromRawJson(response.body));
    } else {
      print('Failed to fetch profile ');
      return Result.error('Failed to fetch profile ');
    }
  }

  //Search Suggeston api call
  Future<Result> searchSuggestion(Map searchSuggestion) async {
    print(searchSuggestion);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "product/suggestion",
        parameter: searchSuggestion);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<SearchSuggestionModel>.success(
          SearchSuggestionModel.fromRawJson(response.body));
    }
    if (response.statusCode == 401) {
      return Result<SearchSuggestionModel>.unAuthored(
          SearchSuggestionModel.fromRawJson(response.body));
    } else {
      print('Failed to fetch profile ');
      return Result.error('Failed to fetch profile ');
    }
  }

  Future<Result> appUpdate(Map reqBody) async {
    final response = await client.request(
        requestType: RequestType.POST,
        path: "verify-version",
        parameter: reqBody);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<AppUpdateModel>.success(
          AppUpdateModel.fromRawJson(response.body));
    } else {
      print('Failed');
      return Result.error('Failed');
    }
  }

  Future<Result> deleteAccount(Map reqBody) async {
    final response = await client.request(
        requestType: RequestType.POST,
        path: "user/delete-customer",
        parameter: reqBody);
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      return Result<AppUpdateModel>.success(
          AppUpdateModel.fromRawJson(response.body));
    } else {
      print('Failed');
      return Result.error('Failed');
    }
  }

  Future<Result> availabilityAtPinCode(Map reqBody) async {
    print(reqBody);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "product/availability-at-pincode",
        parameter: reqBody);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Result<PinCodeAvailabilityModel>.success(
          PinCodeAvailabilityModel.fromJson(json));
    }
    else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }

  Future<Result> nearestForPinCode(Map reqBody) async {
    print(reqBody);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "product/nearest-for-pincode",
        parameter: reqBody);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Result<PinCodeAvailabilityModel>.success(
          PinCodeAvailabilityModel.fromJson(json));
    }
    else {
      print('Failed ');
      return Result.error('Failed ');
    }
  }
}
