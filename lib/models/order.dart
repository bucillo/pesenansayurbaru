import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class Order {
  final String id;
  final String code;
  final String date;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final String description;
  final String statusConfirm;
  final String imageSent;
  final String imageReceipt;
  final String image;
  final String active;

  Order(
      {this.id = "0",
      this.imageSent = "",
      this.imageReceipt = "",
      this.image = "",
      this.code,
      this.date,
      this.customerName,
      this.customerAddress,
      this.customerPhone,
      this.description,
      this.statusConfirm,
      this.active});

  Order.fromJson(Map<String, dynamic> json)
      : id = json["order_id"],
        code = json["order_code"],
        date = json["date"],
        customerName = json["customer_name"],
        customerAddress = json["customer_address"],
        customerPhone = json["customer_phone"],
        description = json["description"],
        statusConfirm = json["status_confirm"],
        imageSent = json["image_sent"],
        imageReceipt = json["image_receipt"],
        image = json["image"],
        active = json["active"];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'order_id': this.id,
        'order_code': this.code,
        'date': this.date,
        'customer_': this.customerName,
        'customer_address': this.customerAddress,
        'customer_phone': this.customerPhone,
        'description': this.description,
        'status_confirm': this.statusConfirm,
        'image_sent': this.imageSent,
        'image_receipt': this.imageReceipt,
        'image': this.image,
        'active': this.active
      };

  static Future<Map> select(
      {@required BuildContext context,
      @required String dateStart,
      @required String dateEnd,
      String confirm = "%",
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "date_start": dateStart,
      "date_end": dateEnd,
      "confirm": confirm
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Pembelian/selectDataReseller",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  static Future<Map> insert(
      {@required BuildContext context,
      @required String date,
      @required String description,
      @required String customerName,
      @required String customerAddress,
      @required String customerPhone,
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "store_id": Global.getShared(key: Prefs.PREFS_USER_STORE_ID),
      "date": date,
      "description": description,
      "customer_name": customerName,
      "customer_address": customerAddress,
      "customer_phone": customerPhone,
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Pembelian/insertDataReseller",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  static Future<Map> update(
      {@required BuildContext context,
      @required String code,
      @required String date,
      @required String description,
      @required String customerName,
      @required String customerAddress,
      @required String customerPhone,
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "code": code,
      "date": date,
      "description": description,
      "customer_name": customerName,
      "customer_address": customerAddress,
      "customer_phone": customerPhone,
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Pembelian/updateDataReseller",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  static Future<Map> print(
      {@required BuildContext context,
      @required String code,
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "code": code
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Pembelian/printData",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  static Future<Map> send(
      {@required BuildContext context,
      @required String code,
      @required String attachment,
      @required String receipt,
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "code": code,
      "attachment": attachment,
      "receipt": receipt
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Pembelian/sendData",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }


  static Future<Map> setImage(
      {@required BuildContext context,
      @required String code,
      @required String attachment,
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "code": code,
      "attachment": attachment
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Pembelian/setImageData",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  static Future<Map> delete(
      {@required BuildContext context,
      @required String code,
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "code": code
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Pembelian/deleteData",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }
}
