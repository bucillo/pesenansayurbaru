import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class Salestype {
  final String id;
  final String name;

  Salestype.fromJson(Map<String, dynamic> json)
      : id = json["salestype_id"],
        name = json["salestype_name"];

  static Future<Map> select(
      {@required BuildContext context, bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH)
    };

    print("PRAMETER :: " + _parameter.toString());

    final response = await Global.postTimeout(
        context: context,
        url: "Master_Penjualan_Tipe/selectData",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }
}
