import 'dart:convert';

import 'package:PesenSayur/models/customer.dart';
import 'package:PesenSayur/util/currency_format.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';

class QtyDialog {
  
  static void show({
    @required BuildContext context,
    @required String name,
    @required String product,
    @required double qty,
    @required String notes,
    @required void Function(bool, String, double, String) action}) {

    TextEditingController _qty = TextEditingController();
    TextEditingController _notes = TextEditingController();
    _qty.text = Global.delimeter(number: qty.toString());
    _notes.text = notes;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setStatee){
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Batal"),
                      onPressed: () {
                        Dialogs.hideDialog(context: context);
                        action(false, "0", 0, "");
                      },
                    ),
                    TextButton(
                      child: Text("Simpan"),
                      onPressed: () {
                        Dialogs.hideDialog(context: context);
                        action(
                            true,
                            product,
                            double.parse(Global.unformatNumber(number: _qty.text)),
                            _notes.text
                        );
                      },
                    )
                  ],
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: Text(
                          name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _qty,
                              decoration: InputDecoration(
                                labelText: "Qty",
                                hintText: "Qty"
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                                signed: false
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.w500
                              ),
                              inputFormatters: [
                                //WhitelistingTextInputFormatter.digitsOnly,
                                CurrencyFormat()
                              ],
                            )
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _notes,
                              decoration: InputDecoration(
                                labelText: "Catatan",
                                hintText: "Catatan"
                              ),
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                fontWeight: FontWeight.w300
                              )
                            )
                          ),
                        ],
                      ),
                    ],
                  )));
          }
        ));
  }
}
