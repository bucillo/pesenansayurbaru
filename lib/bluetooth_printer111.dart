import 'dart:async';
import 'dart:convert';

import 'package:PesenSayur/models/printer.dart';
import 'package:PesenSayur/models/shift.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'models/invoice.dart';

import 'util/dialog.dart';
import 'util/global.dart';

class PrinterType {
  static const PRINTER_INVOICE = 'invoice';
  static const PRINTER_KITCHEN = 'dapur';
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

  bool isPrinterKitchenAvailable() {
    String jsonPrinter =
        Global.getShared(key: Prefs.PREFS_BLUETOOTH_PRINTER_KITCHEN);
    if (jsonPrinter == null || jsonPrinter.isEmpty) return false;

    List<Printer> printers =
        ArrayOfPrinter.fromJson(jsonDecode(jsonPrinter)).printers;
    return (printers != null && printers.length > 0);
  }

  Future<bool> beginPrintInv(
      {Invoice invoice, String printerId, String outletName}) async {
    if (invoice == null) {
      print('no invoice data, print cancelled');
      return false;
    }

    Map<String, String> data = Map();
    List<InvoiceDetail> listDetail = invoice.invoiceDetail;
    var platform = const MethodChannel("printer");
    bool _isPrintSuccess = false;

    //String title2 = invoice.code;
    int maxChar = 32;
    int maxCharLeft = 18;
    String storeName = Global.getShared(key: Prefs.PREFS_USER_STORE_NAME);
    String storeAddress = Global.getShared(key: Prefs.PREFS_USER_STORE_ADDRESS);
    String storeCity =
        Global.getShared(key: Prefs.PREFS_USER_STORE_CITY).toString();
    String storePhone = Global.getShared(key: Prefs.PREFS_USER_STORE_PHONE);
    String result = '';
    int tempIndex = 0;
    if (storeAddress.length > maxChar) {
      for (int i = 0; i < storeAddress.length ~/ maxChar; i++) {
        if (i == 0)
          result += storeAddress.substring(0, maxChar) + '\n';
        else
          result +=
              storeAddress.substring(i * (maxChar), (i + 1) * (maxChar)) + '\n';
        print('result $i: $result');
        tempIndex = i + 1;
      }
      print('tempIndex = $tempIndex');
      if (storeAddress.length % maxChar > 0) {
        if (storeAddress.substring(tempIndex * (maxChar)).length > maxChar) {
          int length = storeAddress.substring(tempIndex * (maxChar)).length;
          result += storeAddress
              .substring(tempIndex * (maxChar), (tempIndex + 1) * (maxChar))
              .padLeft(length + ((maxChar - length) ~/ 2));
        } else {
          result += storeAddress.substring(tempIndex * (maxChar));
        }
      }
      storeAddress = result;
    } else if (storeAddress.length < maxChar) {
      storeAddress = storeAddress.padLeft(
          storeAddress.length + ((maxChar - storeAddress.length) ~/ 2));
    }

    // if (storeAddress.length > maxChar) {
    //   int index = 1;
    //   String tempAddress = storeAddress.substring(0, maxChar);
    //   while (tempAddress.length > maxChar) {
    //     tempAddress += storeAddress.substring(index * maxChar, maxChar);
    //     index++;
    //   }
    //   tempAddress += storeAddress.substring(index * maxChar);
    //   storeAddress = tempAddress.padLeft(maxChar - storeAddress.length);
    // } else if (storeAddress.length < maxChar) {
    //   storeAddress = storeAddress.padLeft(
    //       storeAddress.length + ((maxChar - storeAddress.length) ~/ 2));
    // }
    storeName =
        storeName.padLeft(storeName.length + (maxChar - storeName.length) ~/ 2);
    // print('padding storename: ' + ((maxChar-storeName.length)~/2).toString());
    storeCity =
        storeCity.padLeft(storeCity.length + (maxChar - storeCity.length) ~/ 2);
    storePhone = storePhone
        .padLeft(storePhone.length + (maxChar - storePhone.length) ~/ 2);

    String header =
        storeName + '\n' + storeAddress + '\n' + storeCity + '\n' + storePhone;

    String date =
        //      'Tanggal : ' + Global.formatDate(date: invoice.invoiceHeader.date, outputPattern: Global.DATETIME_DATABASE);
        'Tanggal: ' + Global.getCurrentDate(format: Global.DATETIME_DATABASE);

    if (invoice.invoiceHeader.date != null) {
      //     String date = Global.formatDate(date: invoice.invoiceHeader.date, outputPattern: Global.DATETIME_DATABASE);
      // ignore: unused_local_variable

      date = 'Tanggal : ' +
          Global.formatDate(
              date: invoice.invoiceHeader.date,
              outputPattern: Global.DATETIME_DATABASE);
    }

    String cashier = 'Kasir: ' + Global.getShared(key: Prefs.PREFS_USER_NAME);
    String customer = 'Pelanggan: ' + invoice.invoiceHeader.customerName;

    if (invoice.invoiceHeader.customerName == '') {
      customer = '';
    }

    String salestype = invoice.invoiceHeader.keterangan2;
    if (invoice.invoiceHeader.keterangan2 == '') {
      salestype = '';
    }

    //String noinvoice = invoice.invoiceHeader.keterangan;

    String rowItem = convertToInvoiceString(listDetail);
    // String subtotal = Global.delimeter(number: invoice.invoiceHeader.headerSubtotal);
    String discPercent =
        Global.delimeter(number: invoice.invoiceHeader.headerDiscPercent);
    String discValue =
        Global.delimeter(number: invoice.invoiceHeader.headerDiscValue);
    // String dpp = Global.delimeter(number: invoice.invoiceHeader.headerDpp);
    // String taxPercent =
    //     Global.delimeter(number: invoice.invoiceHeader.headerTaxPercent);
    // String taxValue = Global.delimeter(number: invoice.invoiceHeader.headerTaxValue);
    String subtotal =
        Global.delimeter(number: invoice.invoiceHeader.headerTotal);
    double totalCalculate = double.parse(invoice.invoiceHeader.headerTotal) -
        double.parse(invoice.invoiceHeader.headerDiscValue);
    String total = Global.delimeter(number: totalCalculate.toString());
    String bayar =
        Global.delimeter(number: invoice.invoiceHeader.payAmount ?? '0');
    String kembali = Global.delimeter(number: invoice.invoiceHeader.change);
    String footer = invoice.footer.padLeft(
        invoice.footer.length + (maxChar - invoice.footer.length) ~/ 2);

    data['device_address'] = printerId;
    //? kode nota tidak perlu ditampilkan
    //data['data'] = '$title \n--------------------------------\n';
    data['data'] = 'Dapur \n\n';
    data['data'] = '$header \n\n';
//    data['data'] += '$noinvoice \n';
    String title = invoice.code;
    data['data'] += '$title \n';
    data['data'] += '$date \n';
    data['data'] += '$cashier \n';
    data['data'] += customer != ''
        ? '$customer \n--------------------------------\n'
        : '--------------------------------\n';
    data['data'] += salestype != ''
        ? '$salestype \n--------------------------------\n'
        : '--------------------------------\n';

    // if (outletName.isNotEmpty)
    //   data['data'] +=
    //       'OUTLET: $outletName \n--------------------------------\n';
    // data['data'] +=
    //     '${Global.formatDate(date: DateTime.now().toString(), outputPattern: Global.DATETIME_SHOW)}\n--------------------------------\n';
    data['data'] += '$rowItem--------------------------------\n';

    String subtotalLabel = 'SUBTOTAL :'.padLeft(maxChar - maxCharLeft);
    data['data'] +=
        '$subtotalLabel ${subtotal.padLeft(maxChar - subtotalLabel.length - 1)}\n';

    print('subtotal label padleft : ${maxChar - maxCharLeft}');
    print('subtotal padleft : ${maxChar - subtotalLabel.length}');

    if (discPercent != '0') {
      String discLabel = 'DISC($discPercent%) :'.padLeft(maxChar - maxCharLeft);
      data['data'] +=
          '$discLabel ${discValue.padLeft(maxChar - discLabel.length - 1)}\n';
    }
    // if (dpp != '0') {
    //   String dppLabel = 'DPP:'.padLeft(maxChar - maxCharLeft);
    //   data['data'] += '$dppLabel ${dpp.padLeft(maxChar - dppLabel.length)}\n';
    // }
    // if (taxPercent != '0') {
    //   String taxLabel = 'TAX($taxPercent%):'.padLeft(maxChar - maxCharLeft);
    //   data['data'] +=
    //       '$taxLabel ${taxValue.padLeft(maxChar - taxLabel.length)}\n';
    //   print('$taxLabel ${taxValue.padLeft(maxChar - taxLabel.length)}\n');
    // }

    String totalLabel = 'TOTAL :'.padLeft(maxChar - maxCharLeft);
    data['data'] +=
        '$totalLabel ${total.padLeft(maxChar - totalLabel.length - 1)}\n';

    if (bayar != '0') {
      String bayarLabel = 'BAYAR :'.padLeft(maxChar - maxCharLeft);
      data['data'] +=
          '$bayarLabel ${bayar.padLeft(maxChar - bayarLabel.length - 1)}\n';
    }

    String kembaliLabel = 'KEMBALI :'.padLeft(maxChar - maxCharLeft);
    data['data'] +=
        '$kembaliLabel ${kembali.padLeft(maxChar - kembaliLabel.length - 1)}\n';

    data['data'] += '--------------------------------';
    data['data'] += '$footer\n\n';
    //  data['data'] += 'COPY ';

    // data['data'] += '--------------------------------\n';
    // data['data'] += 'Terimakasih';

    // CETAK NOTA DI CONSOLE, command aja baris try di bawah supaya tidak menghabiskan kertas
    print('data: \n ${data['data']}');
    _isPrintSuccess = true;

    try {
      bool result = await platform.invokeMethod('beginPrint', data);
      _isPrintSuccess = result;
    } catch (e) {
      _isPrintSuccess = false;
      print(e);
    }
    return _isPrintSuccess;
  }

  Future<bool> beginPrintKitchen(
      {Invoice invoice, String printerId, String outletName}) async {
    if (invoice == null) {
      return false;
    }

    Map<String, String> data = Map();
    List<InvoiceDetail> listDetail = invoice.invoiceDetail;
    var platform = const MethodChannel("printer");
    bool _isPrintSuccess = false;
    int maxChar = 32;
    String title = 'DAPUR';
    title = title.padLeft(title.length + (maxChar - title.length) ~/ 2);
    String rowItem = convertToCheckerString(listDetail);
    String date =
        'Tanggal: ' + Global.getCurrentDate(format: Global.DATETIME_DATABASE);

    if (invoice.invoiceHeader.date != null) {
      date = 'Tanggal : ' +
          Global.formatDate(
              date: invoice.invoiceHeader.date,
              outputPattern: Global.DATETIME_DATABASE);
    }
    //   title = invoice.code;
    String cashier =
        'Operator: ' + Global.getShared(key: Prefs.PREFS_USER_NAME);
    String customer = 'Pelanggan: ' + invoice.invoiceHeader.customerName;
    String footer = invoice.footer.padLeft(
        invoice.footer.length + (maxChar - invoice.footer.length) ~/ 2);

    String salestype = invoice.invoiceHeader.keterangan2;
    if (invoice.invoiceHeader.keterangan2 == '') {
      salestype = '';
    }

    //    judul = 'Dapur';
    data['device_address'] = printerId;
    //   data['data'] = '$judul' \n\n';
    title = invoice.code;
    data['data'] = '$title \n';
    data['data'] += '$date \n';
    data['data'] += '$cashier \n';
    data['data'] += invoice.invoiceHeader.customerName != ''
        ? '$customer \n--------------------------------\n'
        : '--------------------------------\n';

    data['data'] += salestype != ''
        ? '$salestype \n--------------------------------\n'
        : '--------------------------------\n';

    data['data'] +=
        '${Global.formatDate(date: DateTime.now().toString(), outputPattern: Global.DATETIME_SHOW)}\n--------------------------------\n';
    data['data'] += '$rowItem';

    data['data'] += '================================';
    data['data'] += '$footer\n\n';
//    data['data'] += 'COPY ';

    try {
      bool result = await platform.invokeMethod('beginPrint', data);
      _isPrintSuccess = result;
    } catch (e) {
      _isPrintSuccess = false;
      print(e);
    }
    return _isPrintSuccess;
  }

  void printMultiple(BuildContext context, Invoice invoice, String printerType,
      {void Function() failedAction,
      void Function() successAction,
      bool showLoading = true}) async {
    if (showLoading) Dialogs.showLoading(context: context);
    if (invoice == null) {
      Navigator.pop(context);
      Dialogs.showSimpleText(
          context: context,
          title: 'Data invoice kosong',
          text: 'Print invoice gagal');
      return;
    }

    List<Printer> printers = [];
    String jsonPrinter = '';
    if (printerType == PrinterType.PRINTER_INVOICE) {
      print('printerType is INVOICE');
      if (!Printing().isPrinterInvAvailable()) {
        Dialogs.showSimpleText(
            context: context,
            text: 'Cetak nota gagal. Printer nota belum disetting.');
        return;
      }
      jsonPrinter =
          Global.getShared(key: Prefs.PREFS_BLUETOOTH_PRINTER_INVOICE);
    }
    if (printerType == PrinterType.PRINTER_KITCHEN) {
      print('printerType is KITCHEN');
      if (!Printing().isPrinterKitchenAvailable()) {
        Dialogs.showSimpleText(
            context: context,
            text: 'Cetak dapur gagal. Printer dapur belum disetting.');
        return;
      }
      jsonPrinter =
          Global.getShared(key: Prefs.PREFS_BLUETOOTH_PRINTER_KITCHEN);
    }
    print('jsonPrinter = $jsonPrinter');
    print('printer is currently used ==> $jsonPrinter');

    if (jsonPrinter == null || jsonPrinter.isEmpty) {
      Navigator.pop(context);
      Dialogs.showSimpleText(
          context: context, text: 'Printer $printerType belum disetting.');
      return;
    }

    printers = ArrayOfPrinter.fromJson(jsonDecode(jsonPrinter)).printers;
    if (printers == null || printers.length == 0) {
      Navigator.pop(context);
      Dialogs.showSimpleText(
          context: context, text: 'Printer $printerType belum disetting.');
      return;
    }
    //? log attached printer
    int i = 1;
    for (var printer in printers) {
      print('attached printer $i: ${printer.printerName}');
      i++;
    }

    String outletName = Global.getShared(key: Prefs.PREFS_USER_STORE_NAME);
    if (printerType == PrinterType.PRINTER_INVOICE) {
      print('printing invoice on: $jsonPrinter');
      for (var printer in printers) {
        bool isPrintSuccess = await beginPrintInv(
            invoice: invoice,
            printerId: printer.printerId,
            outletName: outletName);
        Navigator.pop(context);
        if (!isPrintSuccess) {
          if (failedAction != null) {
            failedAction();
          } else {
            Dialogs.showSimpleText(
                context: context,
                title: 'Print invoice',
                text: 'Print invoice gagal');
          }
          break;
        } else {
          if (successAction != null) successAction();
        }
      }
    } else if (printerType == PrinterType.PRINTER_KITCHEN) {
      print('printing kitchen on: $jsonPrinter');
      for (var printer in printers) {
        bool isPrintSuccess = await beginPrintKitchen(
            invoice: invoice,
            printerId: printer.printerId,
            outletName: outletName);
        Navigator.pop(context);
        if (!isPrintSuccess) {
          if (failedAction != null) {
            failedAction();
          } else {
            Dialogs.showSimpleText(
                context: context,
                title: 'Print dapur',
                text: 'Print dapur gagal');
            break;
          }
        } else {
          if (successAction != null) successAction();
        }
      }
    }
  }

  Future<bool> printRecap(
      BuildContext context, String cashier, List<ShiftDetail> shiftDetails,
      {void Function() failedAction,
      void Function() successAction,
      bool showLoading = true}) async {
    if (!Printing().isPrinterInvAvailable()) {
      Dialogs.showSimpleText(
          context: context,
          text: 'Cetak rekap gagal. Printer nota belum disetting.');
      return false;
    }
    if (showLoading) Dialogs.showLoading(context: context);
    if (shiftDetails == null) {
      Navigator.pop(context);
      Dialogs.showSimpleText(
          context: context,
          title: 'No data to print',
          text: 'Print invoice failed');
      return false;
    }

    List<Printer> printers = [];
    String jsonPrinter =
        Global.getShared(key: Prefs.PREFS_BLUETOOTH_PRINTER_INVOICE);
    print('printer is currently used ==> $jsonPrinter');

    printers = ArrayOfPrinter.fromJson(jsonDecode(jsonPrinter)).printers;
    if (printers == null || printers.length == 0) {
      Navigator.pop(context);
      Dialogs.showSimpleText(
          context: context, text: 'Printer recap belum disetting.');
      return false;
    }

    for (var printer in printers) {
      bool isPrintSuccess = await beginPrintRecap(
          shiftDetails: shiftDetails,
          printerId: printer.printerId,
          cashier: cashier);
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

  Future<bool> beginPrintRecap(
      {@required List<ShiftDetail> shiftDetails,
      String printerId,
      String cashier}) async {
    if (shiftDetails == null) {
      return false;
    }

    Map<String, String> data = Map();
    var platform = const MethodChannel("printer");
    bool _isPrintSuccess = false;

//    String title = 'Rekapan';
    String kasir = 'Kasir: ' + cashier;
    String shiftOpen = 'Buka: ' +
        Global.formatDate(
            date: shiftDetails[0].shiftOpen,
            inputPattern: Global.DATETIME_DATABASE,
            outputPattern: Global.DATETIME_SHOW_DETAIL);
    String shiftClose = 'Tutup: ' +
        Global.formatDate(
            date: shiftDetails[0].shiftClose,
            inputPattern: Global.DATETIME_DATABASE,
            outputPattern: Global.DATETIME_SHOW_DETAIL);

    String rowItem = convertToRecapString(shiftDetails);

    data['device_address'] = printerId;
    data['data'] = '$kasir \n--------------------------------\n';
    data['data'] += '$shiftOpen \n';
    data['data'] += '$shiftClose \n--------------------------------\n';
    data['data'] += '$rowItem\n';

    try {
      bool result = await platform.invokeMethod('beginPrint', data);
      _isPrintSuccess = result;
    } catch (e) {
      _isPrintSuccess = false;
      print(e);
    }
    return _isPrintSuccess;
  }

  String convertToRecapString(List<ShiftDetail> listShiftDetail) {
    final int maxCharNama = 20;
    final int maxChar = 32;
    String tempItem = '';
    String tempName = '';
    String result = '';
    String divider = '--------------------------------';
    String eol = '================================';
    double grandTotal = 0;
    double grandTotalDatabase = 0;

    listShiftDetail.forEach((n) {
      int tempIndex = 0;
      tempName = n.paymentmethodName;
      String strTotalSales = Global.delimeter(number: n.shiftTotalSales);
      String strTotalUsers = Global.delimeter(number: n.shiftTotalUsers);
      strTotalSales = strTotalSales.padLeft(maxChar - tempName.length);
      strTotalUsers = strTotalUsers.padLeft(maxChar);
      double total =
          double.parse(n.shiftTotalUsers) - double.parse(n.shiftTotalSales);
      grandTotal += total;
      grandTotalDatabase += double.parse(n.shiftTotalSales);
      String strTotal;
      if (total < 0) {
        total *= -1;
        strTotal = '(-) ' + Global.delimeter(number: total.toString());
      } else if (total > 0) {
        strTotal = '(+) ' + Global.delimeter(number: total.toString());
      } else {
        strTotal = '(=) ' + Global.delimeter(number: total.toString());
      }
      strTotal = strTotal.padLeft(maxChar);

      //? get semua product tiap payment method
      if (n.detailItem != null && n.detailItem.length > 0) {
        n.detailItem.forEach((item) {
          String productName = item.productName;
          String qty = item.productQty;
          String subtotal = Global.delimeter(number: item.productSubtotal);
          print('product name: ' + productName.toString());
          print('tempIndex: ' + tempIndex.toString());
          int pad = 0;
          productName = productName + ' x $qty';
          if (productName.length > maxCharNama) {
            for (int i = 0; i < productName.length ~/ maxCharNama; i++) {
              if (i == 0)
                tempItem += productName.substring(0, maxCharNama) + '\n';
              else {
                tempItem += productName.substring(
                        i * (maxCharNama), (i + 1) * (maxCharNama)) +
                    '\n';
              }
              tempIndex = i + 1;
            }
            print('tempIndex = $tempIndex');
            if (productName.length % maxCharNama > 0) {
              if (productName.substring(tempIndex * (maxCharNama)).length >
                  maxCharNama) {
                tempItem += productName.substring(tempIndex * (maxCharNama),
                        (tempIndex + 1) * (maxCharNama)) +
                    '\n';
              } else {
                pad = maxChar -
                    productName.substring(tempIndex * (maxCharNama)).length;
                tempItem += productName.substring(tempIndex * (maxCharNama)) +
                    subtotal.padLeft(pad) +
                    '\n';
              }
            }
          } else {
            pad = maxChar - productName.length;
            tempItem += productName + subtotal.padLeft(pad) + '\n';
          }
        });
      }

      if (tempName.length > maxCharNama) {
        for (int i = 0; i < tempName.length ~/ maxCharNama; i++) {
          if (i == 0)
            result += tempName.substring(0, maxCharNama) + '\n';
          else
            result +=
                tempName.substring(i * (maxCharNama), (i + 1) * (maxCharNama)) +
                    '\n';
          print('result $i: $result');
          tempIndex = i + 1;
        }
        print('tempIndex = $tempIndex');
        if (tempName.length % maxCharNama > 0) {
          if (tempName.substring(tempIndex * (maxCharNama)).length >
              maxCharNama) {
            result += tempName.substring(tempIndex * (maxCharNama),
                    (tempIndex + 1) * (maxCharNama)) +
                '\n';
          } else {
            result += tempName.substring(tempIndex * (maxCharNama)) +
                '$strTotalSales\n$strTotalUsers\n$strTotal\n';
          }
        }
      } else {
        result += tempName + '$strTotalSales\n$strTotalUsers\n$strTotal\n';
      }
    });
    String totaldatabase =
        Global.delimeter(number: grandTotalDatabase.toString());
    String strGrandtotalDatabse =
        "TOTAL   " + totaldatabase.padLeft(maxChar - totaldatabase.length);

    String strGrandTotal;
    String labelGrandTotal = "TOTAL SELISIH";
    if (grandTotal < 0) {
      grandTotal *= -1;
      strGrandTotal = '(-) ' + Global.delimeter(number: grandTotal.toString());
    } else if (grandTotal > 0) {
      strGrandTotal = '(+) ' + Global.delimeter(number: grandTotal.toString());
    } else {
      strGrandTotal = '(=) ' + Global.delimeter(number: grandTotal.toString());
    }
    strGrandTotal = labelGrandTotal +
        strGrandTotal.padLeft(maxChar - labelGrandTotal.length);

    result = tempItem +
        "\n" +
        divider +
        "\n" +
        strGrandtotalDatabse +
        "\n" +
        divider +
        "\n" +
        result +
        divider +
        "\n" +
        strGrandTotal +
        "\n" +
        eol +
        "\n";
    //result = '$tempItem\n$divider\n$result$divider\n$strGrandTotal\n$strGrandtotalDatabse\n$eol\n';
    return result;
  }

  String convertToInvoiceString(List<InvoiceDetail> listBayar) {
    final int maxCharNama = 20;
    final int maxChar = 32;
    String tempItemName = '';
    String result = '';
    List<InvoiceDetail> listNew = [];
    listBayar.sort((a, b) => a.itemName.compareTo(b.itemName));
    listBayar.forEach((n) {
      listNew.add(InvoiceDetail(
          itemName: n.itemName,
          price: n.price,
          qty: n.qty,
          unit: n.unit,
          productPrints: n.productPrints,
          detailSubtotal: n.detailSubtotal));
    });

    tempItemName = '';
    listBayar = listNew;
    listBayar.forEach((n) {
      String strSubtotal = Global.delimeter(number: n.detailSubtotal);
      int tempIndex = 0;

      String unit = n.unit;
      if (unit == null || unit == 'null' || unit.isEmpty) unit = '';
      String qty = '${Global.delimeter(number: n.qty.toString())} $unit';
      tempItemName = n.itemName + ' x $qty';
      if (tempItemName.length > maxCharNama) {
        for (int i = 0; i < tempItemName.length ~/ maxCharNama; i++) {
          if (i == 0)
            result += tempItemName.substring(0, maxCharNama) + '\n';
          else
            result += tempItemName.substring(
                    i * (maxCharNama), (i + 1) * (maxCharNama)) +
                '\n';
          print('result $i: $result');
          tempIndex = i + 1;
        }
        if (tempItemName.length % maxCharNama > 0) {
          String temp = tempItemName.substring(tempIndex * (maxCharNama));
          strSubtotal = strSubtotal.padLeft(maxChar - temp.length);
          result += tempItemName.substring(tempIndex * (maxCharNama)) +
              strSubtotal +
              '\n';
        } else {
          strSubtotal = strSubtotal.padLeft(maxChar - 19);
          result = result.trim() + strSubtotal + '\n';
        }
      } else {
        strSubtotal = strSubtotal.padLeft(maxChar - tempItemName.length);
        result += tempItemName + strSubtotal + '\n';
      }
    });
    return result;
  }

  String convertToCheckerString(List<InvoiceDetail> listBayar) {
    final int maxCharNama = 20;
    //   final int maxChar = 32;
    String tempItemName = '';
    String result = '';
    List<InvoiceDetail> listNew = [];
    listBayar.sort((a, b) => a.itemName.compareTo(b.itemName));
    listBayar.forEach((n) {
      listNew.add(InvoiceDetail(
          itemName: n.itemName,
          price: n.price,
          qty: n.qty,
          unit: n.unit,
          productPrints: n.productPrints,
          detailSubtotal: n.detailSubtotal));
    });

    tempItemName = '';
    listBayar = listNew;
    listBayar.forEach((n) {
      int tempIndex = 0;

      String unit = n.unit;
      if (unit == null || unit == 'null' || unit.isEmpty) unit = '';
      String qty = '${Global.delimeter(number: n.qty.toString())}$unit';
      tempItemName = n.itemName + ' x $qty';
      if (tempItemName.length > maxCharNama) {
        for (int i = 0; i < tempItemName.length ~/ maxCharNama; i++) {
          if (i == 0)
            result += tempItemName.substring(0, maxCharNama) + '\n';
          else
            result += tempItemName.substring(
                    i * (maxCharNama), (i + 1) * (maxCharNama)) +
                '\n';
          tempIndex = i + 1;
        }
        if (tempItemName.length % maxCharNama > 0) {
          if (tempItemName.substring(tempIndex * (maxCharNama)).length >
              maxCharNama) {
            result += tempItemName.substring(tempIndex * (maxCharNama),
                    (tempIndex + 1) * (maxCharNama)) +
                '\n';
          } else
            result += tempItemName.substring(tempIndex * (maxCharNama)) + '\n';
        }
      } else
        result += tempItemName + '\n';
    });
    return result;
  }
}
