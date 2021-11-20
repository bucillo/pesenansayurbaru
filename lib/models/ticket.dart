import 'package:flutter/material.dart';
import 'package:PesenSayur/util/global.dart';

class Ticket {
  final String id;
  final String title;
  final String date;
  final String dateEnd;
  final String status;
  final String customer;

  Ticket.fromJson(Map<String, dynamic> json)
      : id = json["ticket_id"],
        title = json["title"],
        date = json["date"],
        dateEnd = json["date_end"],
        customer = json["customer"],
        status = json["close"];
  
  Map<String, dynamic> toJson() => <String, dynamic>{
        'ticket_id': this.id,
        'title': this.title,
        'close': this.status,
        'customer': this.customer,
        'date': this.date,
        'date_end': this.dateEnd
      };

  static Future<Map> select(
      {@required BuildContext context, bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH)
    };

    print("PRAMETER :: " + _parameter.toString());

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Ticket/selectTicket",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }


  static Future<Map> selectReseller(
      {@required BuildContext context, bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH)
    };

    print("PRAMETER :: " + _parameter.toString());

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Ticket/selectTicketReseller",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }


  static Future<Map> create(
      {@required BuildContext context, String title, String text, bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "title": title,
      "text": text
    };

    print("PRAMETER :: " + _parameter.toString());

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Ticket/createTicket",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }

  static Future<Map> close(
      {@required BuildContext context, String ticket, bool showLoading = true}) async {
    Map _parameter = {
      "token": Global.getShared(key: Prefs.PREFS_USER_TOKEN),
      "hash": Global.getShared(key: Prefs.PREFS_USER_HASH),
      "ticket_id": ticket
    };

    print("PRAMETER :: " + _parameter.toString());

    final response = await Global.postTimeout(
        context: context,
        url: "Transaksi_Ticket/closeTicket",
        data: _parameter,
        withLoading: showLoading);

    return response;
  }
}
