import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class ProductPrint {
  final String product;
  final String type;

  ProductPrint(this.product, this.type);

  ProductPrint.fromJson(Map<String, dynamic> json)
      : product = json["product"],
        type = json["type"];

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'product': this.product, 'type': this.type};
}
