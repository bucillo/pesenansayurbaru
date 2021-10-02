
//tutup 16-02-2021
//import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Invoice {
  final String code;
  final InvoiceHeader invoiceHeader;
  final List<InvoiceDetail> invoiceDetail;
  final String footer;

  Invoice({this.code, this.invoiceHeader, this.invoiceDetail, this.footer});

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      code: json['title'],
      invoiceHeader: json['invoiceHeader'],
      invoiceDetail: json['invoiceDetail'] != null
          ? (json['invoiceDetail'] as List)
              .map((i) => InvoiceDetail.fromJson(i))
              .toList()
          : null,
      footer: json['footer'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.code;
    data['invoiceHeader'] = this.invoiceHeader;
    if (this.invoiceDetail != null) {
      data['invoiceDetail'] =
          this.invoiceDetail.map((v) => v.toJson()).toList();
    }
    data['footer'] = this.footer;
    return data;
  }
}

class InvoiceHeader {
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final String customerName2;
  final String headerSubtotal;
  final String headerDiscPercent;
  final String headerDiscValue;
  final String headerDpp;
  final String headerTaxPercent;
  final String headerTaxValue;
  final String headerTotal;
  final String payAmount;
  final String paymentMethod;
  final String keterangan;
  final String keterangan2;
  final String keterangan3;
  final String date;
  final String change; //? kembalian

  InvoiceHeader({
      this.customerName,
      this.customerAddress = "",
      this.customerPhone = "",
      this.customerName2,
      this.headerSubtotal,
      this.headerDiscPercent,
      this.headerDiscValue,
      this.headerDpp,
      this.headerTaxPercent,
      this.headerTaxValue,
      this.headerTotal,
      this.payAmount,
      this.paymentMethod,
      this.keterangan,
      this.keterangan2,
      this.keterangan3,
      this.date,
      this.change});

  factory InvoiceHeader.fromJson(Map<String, dynamic> json) {
    return InvoiceHeader(
      customerName: json['customerName'],
      customerAddress: json['customerAddress'],
      customerPhone: json['customerPhone'],
      customerName2: json['customerName2'],
      headerSubtotal: json['headerSubtotal'],
      headerDiscPercent: json['headerDiscPercent'],
      headerDiscValue: json['headerDiscValue'],
      headerDpp: json['headerDpp'],
      headerTaxPercent: json['headerTaxPercent'],
      headerTaxValue: json['headerTaxValue'],
      headerTotal: json['headerTotal'],
      payAmount: json['payAmount'],
      paymentMethod: json['paymentMethod'],
      keterangan: json['keterangan'],
      keterangan2: json['keterangan'],
      keterangan3: json['keterangan'],
      date: json['date'],
      change: json['change'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerName'] = this.customerName;
    data['customerAddress'] = this.customerAddress;
    data['customerPhone'] = this.customerPhone;
    data['headerSubtotal'] = this.headerSubtotal;
    data['headerTaxPercent'] = this.headerTaxPercent;
    data['headerTaxValue'] = this.headerTaxValue;
    data['headerDiscPercent'] = this.headerDiscPercent;
    data['headerDiscValue'] = this.headerDiscValue;
    data['payAmount'] = this.payAmount ?? '0';
    data['paymentMethod'] = this.paymentMethod ?? 'CASH';
    data['keterangan'] = this.keterangan;
    data['keterangan'] = this.keterangan2;
    data['change'] = this.change;
    return data;
  }
}

class InvoiceDetail {
  final String itemSku;
  final String itemName;
  final String price;
  final String qty;
  final String unit;
  final String detailSubtotal;
  final String detailTaxPercent;
  final String detailTaxValue;
  final String detailDiscPercent;
  final String detailDiscValue;
  final String notes;
  final List<dynamic> productPrints;

  InvoiceDetail({
    this.itemSku,
    this.itemName,
    this.price,
    this.qty,
    this.unit,
    this.detailSubtotal,
    this.detailTaxPercent,
    this.detailTaxValue,
    this.detailDiscPercent,
    this.detailDiscValue,
    this.notes,
    @required this.productPrints
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'itemSku': this.itemSku,
        'itemName': this.itemName,
        'price': this.price,
        'qty': this.qty,
        'unit': this.unit,
        'detailSubtotal': this.detailSubtotal,
        'detailTaxPercent': this.detailTaxPercent,
        'detailTaxValue': this.detailTaxValue,
        'detailDiscPercent': this.detailDiscPercent,
        'detailDiscValue': this.detailDiscValue,
        'notes': this.notes,
        'productPrints': this.productPrints,
      };

  InvoiceDetail.fromJson(Map json)
      : itemSku = json['itemSku'],
        itemName = json['itemName'],
        price = json['price'],
        qty = json['qty'],
        unit = json['unit'],
        detailSubtotal = json['detailSubtotal'],
        detailTaxPercent = json['detailTaxPercent'],
        detailTaxValue = json['detailTaxValue'],
        detailDiscPercent = json['detailDiscPercent'],
        detailDiscValue = json['detailDiscValue'],
        notes = json['notes'],
        productPrints = json['productPrints'];
}
