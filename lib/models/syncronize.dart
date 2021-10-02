import 'dart:convert';

import 'package:PesenSayur/models/api.dart';
import 'package:PesenSayur/models/sales.dart';
import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class Syncronize {
  static void addPendingSales(
      {@required String customerName,
      @required String customerAddress,
      @required String customerPhone,
      @required String salestype,
      @required String offlinecode,
      @required String date,
      @required int subtotal,
      @required int discountPercent,
      @required int discountNominal,
      @required List<SalesDetail> salesDetail,
      @required List<PaymentDetail> paymentDetail}) {
    List pending = [];
    int grandtotal = subtotal - discountNominal;
    pending = Global.getSharedList(key: Prefs.PREFS_PENDING_SALES);

    Map newPending = {
      'store_id': Global.getShared(key: Prefs.PREFS_USER_STORE_ID),
      'customer_name': customerName,
      'customer_address': customerAddress,
      'customer_phone': customerPhone,
      'salestype_id': salestype,
      'code_offline': offlinecode,
      'sales_date': date,
      'subtotal': subtotal,
      'discount_percent': discountPercent,
      'discount_nominal': discountNominal,
      'grandtotal': grandtotal,
      'description': "",
      'payment_detail': paymentDetail,
      'sales_detail': salesDetail,
    };
    pending.add(jsonEncode(newPending));
    Global.setSharedList(key: Prefs.PREFS_PENDING_SALES, value: pending);
  }

  static void addPendingShift(
      {@required int type,
      @required String date,
      @required int value,
      @required String note}) {
    Map newPending = {
      'token': Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      'hash': Global.getShared(key: Prefs.PREFS_USER_HASH),
      'type_id': type,
      'shift_date': date,
      'grandtotal': value,
      'remark': note
    };
    Global.setShared(
        key: Prefs.PREFS_PENDING_SHIFT, value: jsonEncode(newPending));
  }

  static Future<Map> syncSales(
      {@required BuildContext context, bool showLoading = false}) async {
    if (Global.getSharedList(key: Prefs.PREFS_PENDING_SALES).length > 0) {
      Map _parameter = {
        "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
        "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
        "header_detail": jsonDecode(
            Global.getSharedList(key: Prefs.PREFS_PENDING_SALES).toString())
      };

      final response = await Global.postTimeout(
          context: context,
          url: "Transaksi_Penjualan/insertDataSync",
          data: _parameter,
          withLoading: showLoading);

      if (API.fromJson(response).success) {
        List<String> pending = [];
        Global.setSharedList(key: Prefs.PREFS_PENDING_SALES, value: pending);
      }

      return response;
    } else
      return null;
  }

  static Future<Map> syncShift(
      {@required BuildContext context, bool showLoading = false}) async {
    if (Global.getShared(key: Prefs.PREFS_PENDING_SHIFT, defaults: "") != "") {
      Map shift = jsonDecode(Global.getShared(key: Prefs.PREFS_PENDING_SHIFT));

      final response = await Global.postTimeout(
          context: context,
          url: "Transaksi_Shift/insertData",
          data: shift,
          withLoading: showLoading);

      if (API.fromJson(response).success) {
        Global.setShared(key: Prefs.PREFS_PENDING_SHIFT, value: "");
      }

      return response;
    } else
      return null;
  }
}
