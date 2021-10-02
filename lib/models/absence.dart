import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class Absence {
  static Future<Map> check(
      {@required BuildContext context,
      @required String employee,
      @required String absenceType,
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "employee_id": employee,
      "absence_type_id": absenceType
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Absen/checkAbsence",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  static Future<Map> checkEmployee(
      {@required BuildContext context,
      @required String employee,
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "employee_id": employee
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Absen/checkAbsenceEmployee",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  static Future<Map> insert(
      {@required BuildContext context,
      @required String employee,
      @required String absenceType,
      @required String type,
      @required String attachment,
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "store_id": Global.getShared(key: Prefs.PREFS_USER_STORE_ID),
      "employee_id": employee,
      "absence_type_id": absenceType,
      "type": type,
      "attachment": attachment
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Absen/insertData",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }
}
