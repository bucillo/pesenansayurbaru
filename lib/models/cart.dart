import 'dart:convert';

import 'package:PesenSayur/models/cart_detail.dart';
import 'package:PesenSayur/models/product_print.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/cupertino.dart';

class Cart {
  final String date;
  final String server;

  Cart.fromJson(Map<String, dynamic> json)
      : date = json["date"],
        server = json["server"];

  static clearCart() async {
    List<String> cart = [];
    Global.setSharedList(key: Prefs.PREFS_CART_DETAIL, value: cart);
  }

  static addToCart(
      {@required BuildContext context, @required CartDetail cartDetail}) async {
    for (int i = 0; i < cartDetail.productPrints.length; i++) {
      print(new ProductPrint.fromJson(cartDetail.productPrints[i]).product);
    }

    bool alreadyAdd = false;
    bool canAdd = false; // CHECK STOCK
    List<String> currentCartDetail = [];
    currentCartDetail = Global.getSharedList(key: Prefs.PREFS_CART_DETAIL);
    for (int i = 0; i < currentCartDetail.length; i++) {
      CartDetail cartDetailExisting =
          CartDetail.fromJson(jsonDecode(currentCartDetail[i]));
      if (!alreadyAdd) {
        if (cartDetailExisting.product == cartDetail.product &&
            cartDetailExisting.price == cartDetail.price) {
          if (cartDetail.hasStock == "0")
            canAdd = true;
          else if (cartDetailExisting.qty + cartDetail.qty <=
              double.parse(cartDetail.qtyDatabase)) canAdd = true;

          if (canAdd) {
            cartDetailExisting.qty = cartDetailExisting.qty + cartDetail.qty;
            cartDetailExisting.notes = cartDetail.notes;
            currentCartDetail[i] = jsonEncode(cartDetailExisting);
          }
          alreadyAdd = true;
        }
      }
      if (cartDetailExisting.qty <= 0) currentCartDetail.removeAt(i);
    }

    if (!alreadyAdd) {
      if (cartDetail.hasStock == "0")
        canAdd = true;
      else if (cartDetail.qty <= double.parse(cartDetail.qtyDatabase))
        canAdd = true;

      if (canAdd) currentCartDetail.add(jsonEncode(cartDetail));
    }

    if (canAdd) {
      print(currentCartDetail);
      Global.setSharedList(
          key: Prefs.PREFS_CART_DETAIL, value: currentCartDetail);
    } else {
      Dialogs.showSimpleText(context: context, text: "stock tidak mencukupi");
    }
  }
}
