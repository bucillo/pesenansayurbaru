import 'dart:convert';

import 'package:PesenSayur/models/order.dart';
import 'package:PesenSayur/printer_list.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:flutter/material.dart';

import 'bluetooth_printer.dart';
import 'models/printer.dart';
import 'util/global.dart';

class PrinterSettings extends StatefulWidget {
  @override
  _PrinterSettingsState createState() => _PrinterSettingsState();
}

class _PrinterSettingsState extends State<PrinterSettings> {
  List<Printer> printerInvoice = [];

  @override
  void initState() {
    super.initState();
    loadPrinterList();
  }

  void loadPrinterList() {
    if (Global.getShared(key: Prefs.PREFS_BLUETOOTH_PRINTER_INVOICE)
        .toString()
        .isNotEmpty) {
      ArrayOfPrinter arrayOfPrinter = ArrayOfPrinter.fromJson(jsonDecode(
          Global.getShared(key: Prefs.PREFS_BLUETOOTH_PRINTER_INVOICE)));
      printerInvoice = arrayOfPrinter.printers;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Printer Settings',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: getPrinterList(),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        color: Constants.lightAccent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  child: Text(
                    'Test Print',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async {
                    List<Order> orders = [];
                    Order order = Order(
                        code: "TEST-2021010001",
                        customerName: "TEST",
                        customerAddress: "TEST",
                        customerPhone: "0000",
                        date: "2021-01-01 10:00:00",
                        active: "1",
                        statusConfirm: "0",
                        description: "1x coklat\n2x vanila\n3x strawberry");
                    orders.add(order);

                    print("TEST");
                    Printing().printReseller(context, orders);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getPrinterList() {
    Widget printerInvoiceHeader = Container(
        color: Colors.grey,
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Printer',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            IconButton(
              icon: Icon(
                Icons.list,
                color: Colors.white,
              ),
              onPressed: () async {
                await Global.materialNavigate(
                    context,
                    PrinterList(
                      type: PrinterType.PRINTER_INVOICE,
                    )).then((_) {
                  loadPrinterList();
                });
              },
            ),
          ],
        ));

    Widget listPrinterInvoice = ListView.builder(
      shrinkWrap: true,
      itemCount: printerInvoice != null ? printerInvoice.length : 0,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  '${printerInvoice[index].printerName} (${printerInvoice[index].printerId})'),
              Divider(),
            ],
          ),
        );
      },
    );

    return <Widget>[
      printerInvoiceHeader,
      Divider(),
      listPrinterInvoice,
    ];
  }
}
