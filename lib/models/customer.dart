import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class Customer {
  final String id;
  final String code;
  final String name;
  final String phone;
  final String address;

  Customer.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        code = json["code"],
        name = json["name"],
        phone = json["phone"],
        address = json["address"];

  static Future<Map> select(
      {@required BuildContext context, bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "id_store": Global.getShared(key: Prefs.PREFS_USER_STORE_ID)
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Master_Pelanggan/selectDataUser",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }
}
