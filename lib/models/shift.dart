import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class Shift {
  final String shiftId;
  final String usersId;
  final String usersName;
  final String grandtotalOpen;
  final String grandtotalData;
  final String grandtotalClosing;
  final String grandtotalSelisih;
  final String dateOpenShift;
  final String dateClosingShift;
  final String remark;

  Shift.fromJson(Map<String, dynamic> json)
      : shiftId = json["shift_id"],
        usersId = json["users_id"],
        usersName = json["users_name"],
        grandtotalOpen = json["grandtotal_open"],
        grandtotalData = json["grandtotal_data"],
        grandtotalClosing = json["grandtotal_closing"],
        grandtotalSelisih = json["grandtotal_selisih"],
        dateOpenShift = json["date_open_shift"],
        dateClosingShift = json["date_closing_shift"],
        remark = json["remark"];

  static Future<Map> selectExisting(
      {@required BuildContext context, bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "status_closing": 0
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Shift/selectData",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  static Future<Map> selectHistory(
      {@required BuildContext context,
      @required String dateStart,
      @required String dateEnd,
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "sales_date_start": dateStart,
      "sales_date_end": dateEnd
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Shift/selectDataHistoryRecapShift",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  static Future<Map> selectDetail(
      {@required BuildContext context,
      @required String id,
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "shift_id": id
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Shift/selectDataRingkasanCloseShift",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  static Future<Map> input(
      {@required BuildContext context,
      @required int type,
      @required String date,
      @required int value,
      @required String note,
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "type_id": type,
      "shift_date": date,
      "grandtotal": value,
      "remark": note
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Shift/insertData",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  static Future<Map> recap(
      {@required BuildContext context,
      @required String date,
      @required int total,
      @required List recap,
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "type_id": 2,
      "shift_date": date,
      "grandtotal": total,
      "payment_detail": recap
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Shift/insertDataRingkasan",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }
}

class ShiftDetail {
  final String paymentmethodName;
  final String shiftTotalSales;
  final String shiftTotalUsers;
  final String shiftOpen;
  final String shiftClose;
  final List<Item> detailItem;

  ShiftDetail(
      {this.paymentmethodName,
      this.shiftTotalSales,
      this.shiftTotalUsers,
      this.shiftOpen,
      this.shiftClose,
      this.detailItem});
  ShiftDetail.fromJson(Map<String, dynamic> json)
      : paymentmethodName = json["paymentmethod_name"],
        shiftTotalSales = json["shift_total_sales"],
        shiftTotalUsers = json["shift_total_users"],
        shiftOpen = json["shift_open"],
        shiftClose = json["shift_close"],
        detailItem = json['detail_item'] != null
            ? (json['detail_item'] as List)
                .map((i) => Item.fromJson(i))
                .toList()
            : null;

  // Map<String, dynamic> toJson() => <String, dynamic>{
  //       'paymentmethod_name': this.paymentmethodName,
  //       'shift_total_sales': this.shiftTotalSales,
  //       'shift_total_users': this.shiftTotalUsers,
  //       'shift_open': this.shiftOpen,
  //       'shift_close': this.shiftClose,
  //       if (this.detailItem != null)
  //         'detail_item': this.detailItem.map((v) => v.toJson()).toList(),
  //     };

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentmethod_name'] = this.paymentmethodName;
    data['shift_total_sales'] = this.shiftTotalSales;
    data['shift_total_users'] = this.shiftTotalUsers;
    data['shift_open'] = this.shiftOpen;
    data['shift_close'] = this.shiftClose;
    if (this.detailItem != null) {
      data['detail_item'] = this.detailItem.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  final String productName;
  final String productQty;
  final String productPrice;
  final String productSubtotal;
  Item(
      {this.productName,
      this.productQty,
      this.productPrice,
      this.productSubtotal});
  Item.fromJson(Map<String, dynamic> json)
      : productName = json["product_name"],
        productQty = json["product_qty"],
        productPrice = json["product_price"],
        productSubtotal = json["product_subtotal"];
  Map<String, dynamic> toJson() => <String, dynamic>{
        'product_name': this.productName,
        'product_qty': this.productQty,
        'product_price': this.productPrice,
        'product_subtotal': this.productSubtotal,
      };
}
