import 'dart:async';
import 'dart:convert';

import 'package:PesenSayur/models/order.dart';
import 'package:PesenSayur/models/printer.dart';
import 'package:PesenSayur/models/product_print.dart';
import 'package:PesenSayur/models/shift.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'models/invoice.dart';

import 'util/dialog.dart';
import 'util/global.dart';

class PrinterType {
  static const PRINTER_INVOICE = 'invoice';
  static const PRINTER_KITCHEN = 'dapur';
  static const PRINTER_FOOD = 'makanan';
  static const PRINTER_DRINK = 'minuman';
}

class Printing {
  bool isPrinterInvAvailable() {
    String jsonPrinter =
        Global.getShared(key: Prefs.PREFS_BLUETOOTH_PRINTER_INVOICE);
    if (jsonPrinter == null || jsonPrinter.isEmpty) return false;

    List<Printer> printers =
        ArrayOfPrinter.fromJson(jsonDecode(jsonPrinter)).printers;
    return (printers != null && printers.length > 0);
  }

  Future<bool> isBTEnabled() async {
    const platform = const MethodChannel("printer");
    try {
      bool tempBool = await platform.invokeMethod('isBluetoothEnabled');
      return tempBool;
    } catch (e) {
      return false;
    }
  }

  Future<bool> beginPrint({List<Order> order, String printerId}) async {
    if (order == null) return false;
    if (order.isEmpty) return false;

    Map<String, String> data = Map();
    var platform = const MethodChannel("printer");
    bool _isPrintSuccess = false;
    String row = convertToResellerString(order);

    data['device_address'] = printerId;
    data['data'] = '$row';

    try {
      bool result = await platform.invokeMethod('beginPrint', data);
      _isPrintSuccess = result;
    } catch (e) {
      _isPrintSuccess = false;
      print(e);
    }
    return _isPrintSuccess;
  }

  Future<bool> printReseller(BuildContext context, List<Order> order,
      {void Function() failedAction,
      void Function() successAction,
      bool showLoading = true}) async {
    if (!Printing().isPrinterInvAvailable()) {
      Dialogs.showSimpleText(
          context: context, text: 'Cetak gagal. Printer belum disetting.');
      return false;
    }
    if (showLoading) Dialogs.showLoading(context: context);

    List<Printer> printers = [];
    String jsonPrinter =
        Global.getShared(key: Prefs.PREFS_BLUETOOTH_PRINTER_INVOICE);

    printers = ArrayOfPrinter.fromJson(jsonDecode(jsonPrinter)).printers;
    if (printers == null || printers.length == 0) {
      Navigator.pop(context);
      Dialogs.showSimpleText(
          context: context, text: 'Printer belum disetting.');
      return false;
    }

    for (var printer in printers) {
      print("TEST " + printer.printerId);
      bool isPrintSuccess =
          await beginPrint(order: order, printerId: printer.printerId);
      Navigator.pop(context);
      if (!isPrintSuccess) {
        if (failedAction != null) {
          failedAction();
        }
        return false;
      }
    }
    if (successAction != null) {
      successAction();
    }
    return true;
  }

  String convertToResellerString(List<Order> list) {
    String result = "";
    list.forEach((n) {
      if (n.active == "1") {
        if (n.statusConfirm == "2") result += "ON PROSES\n";
        if (n.statusConfirm == "3") result += "ON SEND\n";
        // result += "================================\n";
        result += n.code + "\n";
        result += n.date + "\n";
        result += "Nama: " + n.customerName + "\n";
        result += "Alamat: " + n.customerAddress + "\n";
        result += "Phone: " + n.customerPhone + "\n";
        result += "Order:\n";
        result += n.description + "\n\n\n";
      }
    });
    return result;
  }
}
