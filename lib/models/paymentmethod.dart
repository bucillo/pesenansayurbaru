import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class Paymentmethod {
  final String id;
  final String name;
  final String type;
  final String icon;

  Paymentmethod.fromJson(Map<String, dynamic> json)
      : id = json["paymentmethod_id"],
        name = json["paymentmethod_name"],
        type = json["paymentmethod_type"],
        icon = json["paymentmethod_icon"];

  static Future<Map> select(
      {@required BuildContext context, bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH)
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Master_Metode_Pembayaran/selectData",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }
}
