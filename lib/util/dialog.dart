import 'package:PesenSayur/util/currency_format.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Dialogs {
  //TO DISMISS A DIALOG
  static void hideDialog({@required BuildContext context}) {
    Navigator.pop(context);
  }

  //TO SHOW A LOADING DIALOG
  static void showLoading({@required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor)),
                  ],
                ))));
  }

  //TO SHOW A SIMPLE TEXT DIALOG
  static void showSimpleText(
      {@required BuildContext context,
      @required String text,
      String title = '',
      void Function() action}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                title: title != ''
                    ? Text(title, style: TextStyle(fontWeight: FontWeight.bold))
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                actions: <Widget>[
                  TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        hideDialog(context: context);
                        if (action != null) action();
                      })
                ],
                content: Text(text))));
  }

  //TO SHOW A YES NO DIALOG
  //Action digunakan untuk mengirimkan action yang akan dilakukan ketika user memilih yes atau no
  static void showYesNo(
      {@required BuildContext context,
      @required String text,
      @required void Function(bool) action}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                actions: <Widget>[
                  TextButton(
                    child: Text("Batal"),
                    onPressed: () {
                      hideDialog(context: context);
                      action(false);
                    },
                  ),
                  TextButton(
                    child: Text("Ya"),
                    onPressed: () {
                      hideDialog(context: context);
                      action(true);
                    },
                  )
                ],
                content: Text(text))));
  }

  //TO SHOW A EDIT QTY CART DIALOG
  static void showQtyDetail(
      {@required BuildContext context,
      @required double qty,
      @required String notes,
      @required void Function(bool, double, String) action}) {
    TextEditingController _qty = TextEditingController();
    TextEditingController _notes = TextEditingController();
    _qty.text = Global.delimeter(number: qty.toString());
    _notes.text = notes;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                actions: <Widget>[
                  TextButton(
                    child: Text("Batal"),
                    onPressed: () {
                      hideDialog(context: context);
                      action(false, 0, "");
                    },
                  ),
                  TextButton(
                    child: Text("Simpan"),
                    onPressed: () {
                      hideDialog(context: context);
                      action(
                          true,
                          double.parse(
                              Global.unformatNumber(number: _qty.text)),
                          _notes.text);
                    },
                  )
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          controller: _qty,
                          decoration: InputDecoration(
                              labelText: "Qty", hintText: "Qty"),
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          style: TextStyle(fontWeight: FontWeight.w500),
                          inputFormatters: [
                            //WhitelistingTextInputFormatter.digitsOnly,
                            CurrencyFormat()
                          ],
                        ))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                                controller: _notes,
                                decoration: InputDecoration(
                                    labelText: "Catatan", hintText: "Catatan"),
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(fontWeight: FontWeight.w300))),
                      ],
                    )
                  ],
                ))));
  }

  //TO SHOW A CASH DIALOG
  static void showCash(
      {@required BuildContext context,
      @required int type,
      @required void Function(bool, int, String) action}) {
    TextEditingController _value = TextEditingController();
    TextEditingController _catatan = TextEditingController();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                actions: <Widget>[
                  TextButton(
                    child: Text("Batal"),
                    onPressed: () {
                      hideDialog(context: context);
                      action(false, 0, "");
                    },
                  ),
                  TextButton(
                    child: Text("Simpan"),
                    onPressed: () {
                      hideDialog(context: context);
                      action(
                          true,
                          int.parse(Global.unformatNumber(number: _value.text)),
                          _catatan.text);
                    },
                  )
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (type == 0)
                          Text("Kas Masuk",
                              style: TextStyle(color: Colors.black))
                        else if (type == 1)
                          Text("Kas Keluar",
                              style: TextStyle(color: Colors.black))
                        else if (type == 2)
                          Text("Rekapan Shift",
                              style: TextStyle(color: Colors.black))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          controller: _value,
                          decoration: InputDecoration(
                              labelText: "Nominal",
                              hintText: "Nominal",
                              prefixIcon: Icon(Icons.payment)),
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontWeight: FontWeight.w500),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyFormat()
                          ],
                        )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          controller: _catatan,
                          decoration: InputDecoration(
                            labelText: "Catatan",
                            hintText: "Catatan",
                            prefixIcon: Icon(Icons.note),
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        )),
                      ],
                    )
                  ],
                ))));
  }

  //TO SHOW A REPRINT DIALOG
  static void showReprint(
      {@required BuildContext context,
      @required void Function(int) action,
      bool skipButton = false,
      String title = '',
      bool allowBack = true}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                title: title.isNotEmpty ? Text(title) : Container(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                actions: <Widget>[
                  allowBack
                      ? TextButton(
                          child: Text("Batal"),
                          onPressed: () => hideDialog(context: context),
                        )
                      : Container()
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Print Nota"),
                      ),
                      onTap: () {
                        action(0);
                      },
                    ),
                    Divider(),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Print Dapur"),
                      ),
                      onTap: () {
                        action(1);
                      },
                    ),
                    Divider(),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Print Makanan"),
                      ),
                      onTap: () {
                        action(3);
                      },
                    ),
                    Divider(),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Print Minuman"),
                      ),
                      onTap: () {
                        action(4);
                      },
                    ),
                    Divider(),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Print Semua"),
                      ),
                      onTap: () {
                        action(2);
                      },
                    ),
                    Divider(),
                    skipButton
                        ? InkWell(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Lewati",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            onTap: () {
                              action(3);
                            },
                          )
                        : Container(),
                  ],
                ))));
  }

  //TO SHOW A REPRINT DIALOG
  static void showPrintCategory(
      {@required BuildContext context,
      @required void Function(int) action,
      bool skipButton = false,
      String title = '',
      bool allowBack = true}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                title: title.isNotEmpty ? Text(title) : Container(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                actions: <Widget>[
                  allowBack
                      ? TextButton(
                          child: Text("Batal"),
                          onPressed: () => hideDialog(context: context),
                        )
                      : Container()
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Semua"),
                      ),
                      onTap: () {
                        action(-1);
                      },
                    ),
                    Divider(),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Baru"),
                      ),
                      onTap: () {
                        action(0);
                      },
                    ),
                    Divider(),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("On Proses"),
                      ),
                      onTap: () {
                        action(2);
                      },
                    ),
                    Divider(),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("On Send"),
                      ),
                      onTap: () {
                        action(3);
                      },
                    ),
                    Divider(),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("On FINISH"),
                      ),
                      onTap: () {
                        action(4);
                      },
                    ),
                  ],
                ))));
  }

  //TO SHOW A REPRINT RECAP DIALOG
  static void showReprintRecap({
    @required BuildContext context,
    @required void Function(int) action,
    bool skipButton = false,
    String title = '',
  }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                title: title.isNotEmpty ? Text(title) : Container(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                actions: <Widget>[Container()],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Print ulang"),
                      ),
                      onTap: () {
                        action(0);
                      },
                    ),
                    Divider(),
                    skipButton
                        ? InkWell(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Lewati",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            onTap: () {
                              action(1);
                            },
                          )
                        : Container(),
                  ],
                ))));
  }
}
