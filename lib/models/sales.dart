import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class Sales {
  final String id;
  final String code;
  final String subtotal;
  final String discountPercent;
  final String discountNominal;
  final String grandtotal;
  final String paymentTotal;
  final String changeTotal;
  final String date;
  final String status;
  final String salestypeName;
  final String paymentmethodName;
  final String salesStatusVoid;
  final String salesCashier;
  final String salesCustomerName;
  final String salesCustomerAddress;
  final String salesCustomerPhone;

  Sales.fromJson(Map<String, dynamic> json)
      : id = json["sales_id"],
        code = json["sales_code"],
        subtotal = json["sales_subtotal"],
        discountPercent = json["sales_discount_percent"],
        discountNominal = json["sales_discount_nominal"],
        grandtotal = json["sales_grandtotal"],
        paymentTotal = json["sales_paymenttotal"],
        changeTotal = json["sales_changetotal"],
        date = json["sales_date"],
        status = json["sales_status_active"],
        salestypeName = json["salestype_name"],
        paymentmethodName = json["paymentmethod_name"],
        salesStatusVoid = json["sales_status_void"],
        salesCashier = json["sales_cashier"],
        salesCustomerName = json["sales_customer_name"],
        salesCustomerAddress = json["sales_customer_address"],
        salesCustomerPhone = json["sales_customer_phone"];

  static Future<Map> get(
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

    // Map _parameter = {
    //   "token": "f4c3d4b91df31d1cff57d2c4476d6647db50bd5d",
    //   "hash": "",
    //   "sales_date_start": "2020-04-09",
    //   "sales_date_end": "2020-04-09"
    // };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Penjualan/selectData",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  static Future<Map> insert(
      {@required BuildContext context,
      @required String customerName,
      @required String customerAddress,
      @required String customerPhone,
      @required String salestype,
      @required String offlinecode,
      @required int subtotal,
      @required String date,
      @required int discountPercent,
      @required int discountNominal,
      @required List<SalesDetail> salesDetail,
      @required List<PaymentDetail> paymentDetail,
      bool showLoading = true,
      String salestypeName}) async {
    int grandtotal = subtotal - discountNominal;

    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "store_id": Global.getShared(key: Prefs.PREFS_USER_STORE_ID),
      "customer_name": customerName,
      "customer_address": customerAddress,
      "customer_phone": customerPhone,
      "salestype_id": salestype,
      "code_offline": offlinecode,
      "sales_date": date,
      "subtotal": subtotal,
      "discount_percent": discountPercent,
      "discount_nominal": discountNominal,
      "grandtotal": grandtotal,
      "status_paid": 1,
      "description": '',
      "payment_detail": paymentDetail,
      "sales_detail": salesDetail,
    };

    final response = await Global.postTimeout(
      context: context,
      url: "Transaksi_Penjualan/insertData",
      data: _parameter,
      withLoading: showLoading,
      //timeout: Duration(milliseconds: 2000)
    );

    return response;
  }
}

class SalesDetail {
  final String id;
  final String productId;
  final String productName;
  final double qty;
  final int price;
  final int total;
  final String notes;

  SalesDetail(
      {this.id,
      this.productId,
      this.productName,
      this.qty,
      this.price,
      this.total,
      this.notes});

  static Future<Map> get(
      {@required BuildContext context,
      @required String salesId,
      bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "sales_id": salesId,
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Penjualan/selectDataDetail",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  SalesDetail.fromJson(Map<String, dynamic> json)
      : productName = json["product_name"],
        productId = json["product_id"] != '' ? json["product_id"] : '0',
        id = json["sales_detail_id"],
        qty = json["sales_detail_qty"] != ''
            ? double.parse(json["sales_detail_qty"])
            : 0,
        price = json["sales_detail_price"] != ''
            ? int.parse(json["sales_detail_price"])
            : 0,
        total = json["sales_detail_total"] != ''
            ? int.parse(json["sales_detail_total"])
            : 0,
        notes = json["notes"];
  Map<String, dynamic> toJson() => <String, dynamic>{
        'product_id': this.productId,
        'product_name': this.productName,
        'sales_detail_id': this.id,
        'sales_detail_qty': this.qty,
        'sales_detail_price': this.price,
        'sales_detail_total': this.total,
        'notes': this.notes,
      };
}

class PaymentDetail {
  final String paymentmethodId;
  final double payment;
  final double changepayment;

  PaymentDetail({this.paymentmethodId, this.payment, this.changepayment});
  PaymentDetail.fromJson(Map<String, dynamic> json)
      : paymentmethodId = json["paymentmethod_id"],
        payment = json["payment"],
        changepayment = json["changepayment"];
  Map<String, dynamic> toJson() => <String, dynamic>{
        'paymentmethod_id': this.paymentmethodId,
        'payment': this.payment,
        'changepayment': this.changepayment
      };
}
