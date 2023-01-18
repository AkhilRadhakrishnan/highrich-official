





import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/constants.dart';
import 'package:highrich/general/shared_pref.dart';
import 'package:http/http.dart';

class ApiClient {
  //Base url

   static const String _baseUrl = base_url;
  static const String _port = port;
 // static const String _port = "";

  final Client _client;
  String _token = '';

  ApiClient(this._client);

  Future<Response> request(
      {@required RequestType requestType,
        @required String path,
        dynamic parameter = Nothing}) async {
    _token = await SharedPref.shared.getToken() ?? '';
    print(_token);
    switch (requestType) {
      case RequestType.GET:
        if (_token.isNotEmpty) {
          return _client.get(Uri.parse("$_baseUrl$_port$path"),
              headers: {"Authorization": 'Bearer $_token'});
        }
        return _client.get(Uri.parse("$_baseUrl$_port$path"));

      case RequestType.POST:
        if (_token.isNotEmpty) {
          return _client.post(Uri.parse("$_baseUrl$_port$path"),
              headers: {
                "Content-Type": "application/json",
                "Authorization": 'Bearer $_token'
              },
              body: json.encode(parameter));
        }
        return _client.post(Uri.parse("$_baseUrl$_port$path"),
            headers: {"Content-Type": "application/json"},
            body: json.encode(parameter));

      case RequestType.PATCH:
        if (_token.isNotEmpty) {
          return _client.patch(Uri.parse("$_baseUrl$_port$path"),
              headers: {
                "Content-Type": "application/json",
                "Authorization": 'Bearer $_token'
              },
              body: json.encode(parameter));
        }
        return _client.patch(Uri.parse("$_baseUrl$_port$path"),
            headers: {"Content-Type": "application/json"},
            body: json.encode(parameter));

      case RequestType.PUT:
        if (_token.isNotEmpty) {
          return _client.put(Uri.parse("$_baseUrl$_port$path"),
              headers: {
                "Content-Type": "application/json",
                'Accept': 'application/json',
                "Authorization": 'Bearer $_token'
              },
              body: json.encode(parameter));
        }
        return _client.put(Uri.parse("$_baseUrl$_port$path"),
            headers: {"Content-Type": "application/json"},
            body: json.encode(parameter));

      case RequestType.DELETE:
        if (_token.isNotEmpty) {
          return _client.delete(Uri.parse("$_baseUrl$_port$path"),
              headers: {
                "Content-Type": "application/json",
                'Accept': 'application/json',
            "Authorization": 'Bearer $_token'});
        }
        return _client.delete(Uri.parse("$_baseUrl$_port$path"));

      default:
        return throw RequestTypeNotFoundException(
            "The HTTP request mentioned is not found");
    }
  }
}
