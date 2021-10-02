import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class Category {
  final String id;
  final String name;

  Category.fromJson(Map<String, dynamic> json)
      : id = json["category_id"],
        name = json["category_name"];

  static Future<Map> select(
      {@required BuildContext context, bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "id_store": Global.getShared(key: Prefs.PREFS_USER_STORE_ID)
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Master_Barang_Kategori/selectData",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }
}
