import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// class SharedPref {
//
//   static final SharedPref _singleton = SharedPref._internal();
//   factory SharedPref() => _singleton;
//   SharedPref._internal();
//   static SharedPref get shared => _singleton;
//
//   read(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     return json.decode(prefs.getString(key));
//   }
//
//   save(String key, value) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString(key, json.encode(value));
//   }
//
//   Future<String> readToken(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(key);
//   }
//
//   saveToken(String key, value) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString(key, value);
//   }
//
//   remove(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove(key);
//   }
//
//   saveLogin(String key, value) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setBool(key, value);
//   }
//
//   Future<bool> readLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     bool isLogged = prefs.getBool("LOGIN");
//     if (isLogged != null){
//       return isLogged;
//     }else {
//       return false;
//     }
//   }
//
// }

class SharedPref {

  static final SharedPref _singleton = SharedPref._internal();
  factory SharedPref() => _singleton;
  SharedPref._internal();
  static SharedPref get shared => _singleton;

  final String _login = "LOGIN";
  final String _token = "token";

  Future<bool> getLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_login) ?? false;
  }
  Future<bool> setLogin(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_login, value);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_token);
  }
  Future<bool> setToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_token, value);
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    prefs.clear();
    prefs.commit();
  }

  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key)) ?? "";
  }

}