import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class System {
  static Future<Map> date(
      {@required BuildContext context, bool showLoading = true}) async {
    Map _parameter = {};

    final response = await Global.postTimeout(
        context: context,
        url: "System/date",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }
}
