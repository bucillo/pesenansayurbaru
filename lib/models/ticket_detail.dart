import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class TicketDetail {
  final String user;
  final String me;
  final String text;
  final String date;

  TicketDetail.fromJson(Map<String, dynamic> json)
      : user = json["user"],
        text = json["text"],
        me = json["me"],
        date = json["date"];
  
  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': this.user,
        'text': this.text,
        'me': this.me,
        'date': this.date
      };

  static Future<Map> select(
      {@required BuildContext context, String ticket, bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "ticket_id": ticket
    };

    print("PRAMETER :: " + _parameter.toString());

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Ticket/selectTicketDetail",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  static Future<Map> fill(
      {@required BuildContext context, String ticket, String text, bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "ticket_id": ticket,
      "text": text
    };

    print("PRAMETER :: " + _parameter.toString());

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Ticket/fillTicket",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }
}
