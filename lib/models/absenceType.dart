import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class AbsenceType {
  final String id;
  final String name;
  final String start;
  final String end;

  AbsenceType.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        start = json["start"],
        end = json["end"];

  static Future<Map> select(
      {@required BuildContext context, bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH)
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Master_Absen_Tipe/selectData",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }
}
