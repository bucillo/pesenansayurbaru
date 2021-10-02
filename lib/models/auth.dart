import 'package:PesenSayur/screens/content_login.dart';
import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class Auth {
  final String token;
  final String hash;
  final String type; //2:manager; 3:kasir
  final String name;
  final String storeId;
  final String storeName;
  final String storeAddress;
  final String storePhone;
  final String storeCity;

  Auth.fromJson(Map<String, dynamic> json)
      : token = json["token"],
        hash = json["hash"],
        type = json["type_user_id"],
        name = json["name"],
        storeId = json["store_id"],
        storeName = json["store_name"],
        storeAddress = json["store_address"],
        storePhone = json["store_phone"],
        storeCity = json["store_city"];

  static void logout(BuildContext context) {
    Global.setShared(key: Prefs.PREFS_USER_TOKEN, value: "");
    Global.setShared(key: Prefs.PREFS_USER_HASH, value: "");
    Global.setShared(key: Prefs.PREFS_USER_TYPE, value: "");
    Global.setShared(key: Prefs.PREFS_USER_NAME, value: "");
    Global.setShared(key: Prefs.PREFS_USER_STORE_ID, value: "");
    Global.setShared(key: Prefs.PREFS_USER_STORE_NAME, value: "");
    Global.setShared(key: Prefs.PREFS_USER_STORE_ADDRESS, value: "");
    Global.setShared(key: Prefs.PREFS_USER_STORE_PHONE, value: "");
    Global.setShared(key: Prefs.PREFS_USER_STORE_CITY, value: "");
    Navigator.pushAndRemoveUntil<void>(context, MaterialPageRoute(builder: (_) {
      return ContentLogin();
    }), (_) => false);
  }

  static Future<Map> login(
      {@required BuildContext context,
      @required String email,
      @required String password,
      bool showLoading = true}) async {
    Map _parameter = {"email": email, "password": password};

    final response = await Global.postTimeout(
        context: context,
        url: "Frontend_Login/selectData",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }
}
