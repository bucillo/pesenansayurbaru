import 'package:PesenSayur/models/product_print.dart';
import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class Product {
  final String id;
  final String categoryCode;
  final String category;
  final String name;
  final String price;
  final String photo;
  final String hasStock;
  double qty;
  final String qtyDatabase;
  final String unit;
  final String unit2;
  final String unit3;
  final String unit4;
  final String unit5;
  final String unitConversion2;
  final String unitConversion3;
  final String unitConversion4;
  final String unitConversion5;
  final String customer;
  final String alamat;
  final String telp;
  final String desc;
  bool favourite;
  final List<dynamic> productPrints;

  Product.fromJson(Map<String, dynamic> json)
      : id = json["product_id"],
        categoryCode = json["product_category"],
        category = json["category_name"],
        name = json["product_name"],
        price = json["product_price"],
        photo = json["product_photo"],
        hasStock = json["has_stock"],
        qty = 0,
        qtyDatabase = json["qty_database"],
        unit = json["unit"],
        unit2 = json["unit_2"],
        unit3 = json["unit_3"],
        unit4 = json["unit_4"],
        unit5 = json["unit_5"],
        unitConversion2 = json["unit_conversion_2"],
        unitConversion3 = json["unit_conversion_3"],
        unitConversion4 = json["unit_conversion_4"],
        unitConversion5 = json["unit_conversion_5"],
        customer = json["customer"],
        alamat = json["alamat"],
        telp = json["telp"],
        desc = json["desc"],
        favourite = false,
        productPrints = json["product_print"];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'product_id': this.id,
        'product_category': this.categoryCode,
        'category_name': this.category,
        'product_name': this.name,
        'product_price': this.price,
        'product_photo': this.photo,
        'has_stock': this.hasStock,
        'qty': this.qty,
        'qty_database': this.qtyDatabase,
        'unit': this.unit,
        'unit_2': this.unit2,
        'unit_3': this.unit3,
        'unit_4': this.unit4,
        'unit_5': this.unit5,
        'unit_conversion_2': this.unitConversion2,
        'unit_conversion_3': this.unitConversion3,
        'unit_conversion_4': this.unitConversion4,
        'unit_conversion_5': this.unitConversion5,
        'favourite': this.favourite,
        'product_print': this.productPrints,
      };

  static Future<Map> select(
      {@required BuildContext context, bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "id_store": Global.getShared(key: Prefs.PREFS_USER_STORE_ID)
    };

    final response = await Global.postTimeout(
        context: context,
        url: "Master_Barang/selectData",
        data: _parameter,
        withLoading: showLoading,
        timeout: Duration(seconds: 60));

    return response;
  }
}
