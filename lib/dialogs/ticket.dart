
import 'package:PesenSayur/util/dialog.dart';
import 'package:flutter/material.dart';

class TicketDialog {
  
  static void show({
    @required BuildContext context,
    @required void Function(bool, String, String) action}) {

    TextEditingController _title = TextEditingController();
    TextEditingController _text = TextEditingController();

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
                        action(false, "", "");
                      },
                    ),
                    TextButton(
                      child: Text("Buat"),
                      onPressed: () {
                        Dialogs.hideDialog(context: context);
                        action(true, _title.text, _text.text);
                      },
                    )
                  ],
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Buat Tiket",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _title,
                              decoration: InputDecoration(
                                labelText: "Judul"
                              ),
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                fontWeight: FontWeight.w300
                              )
                            )
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _text,
                              decoration: InputDecoration(
                                labelText: "Pertanyaan"
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
