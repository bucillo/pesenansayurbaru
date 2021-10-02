import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class Employee {
  final String id;
  final String name;

  Employee.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];

  static Future<Map> select(
      {@required BuildContext context, bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "id_store": Global.getShared(key: Prefs.PREFS_USER_STORE_ID),
      "status": "1"
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Master_Pegawai/selectData",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }
}
