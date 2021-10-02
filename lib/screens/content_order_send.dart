import 'dart:io';

import 'package:PesenSayur/models/absence.dart';
import 'package:PesenSayur/models/absenceType.dart';
import 'package:PesenSayur/models/api.dart';
import 'package:PesenSayur/models/auth.dart';
import 'package:PesenSayur/models/employee.dart';
import 'package:PesenSayur/models/order.dart';
import 'package:PesenSayur/screens/content_absence_result.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';

class ContentOrderSend extends StatefulWidget {
  final Order order;
  const ContentOrderSend({Key key, this.order}) : super(key: key);

  @override
  _ContentOrderSendState createState() => _ContentOrderSendState();
}

class _ContentOrderSendState extends State<ContentOrderSend> {
  File image;
  File imageReceipt;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.of(context).pop(true);
      },
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Center(
                child: Text(
              "Kirim Pesanan",
              style: TextStyle(color: Constants.lightAccent),
            ))),
        body: _content(),
      )),
    );
  }

  Widget _content() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(top: 50),
              width: double.infinity,
              child: FlatButton(
                child: Text(
                  "Simpan",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10),
                  side: BorderSide(color: Constants.darkAccent),
                ),
                color: Constants.lightAccent,
                textColor: Colors.white,
                onPressed: submit,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            "Foto Pack",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          )),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () => picker(context, ImageSource.camera),
                          child: Container(
                            width: 150,
                            height: 250,
                            color: Colors.black12,
                            child: (image == null)
                                ? Icon(FontAwesome.camera, size: 60)
                                : Image.file(image, width: 300),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            "Foto Nota",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          )),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () =>
                              picker(context, ImageSource.camera, type: 1),
                          child: Container(
                            width: 150,
                            height: 250,
                            color: Colors.black12,
                            child: (imageReceipt == null)
                                ? Icon(FontAwesome.camera, size: 60)
                                : Image.file(imageReceipt, width: 300),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void submit() async {
    if (image == null) {
      Dialogs.showSimpleText(
          context: context, text: "Foto pesanan terlebih dahulu");
    }
    if (imageReceipt == null) {
      Dialogs.showSimpleText(
          context: context, text: "Foto nota terlebih dahulu");
    } else {
      final response = API.fromJson(await Order.send(
          context: context,
          code: widget.order.id,
          attachment: Global.base64Image(file: image),
          receipt: Global.base64Image(file: imageReceipt)));
      if (response.success) {
        Dialogs.hideDialog(context: context);
      } else
        Dialogs.showSimpleText(context: context, text: response.message);
    }
  }

  Future picker(BuildContext _context, ImageSource _imageSource,
      {int type = 0}) async {
    try {
      File img = await ImagePicker.pickImage(
          source: _imageSource, maxWidth: 800, maxHeight: 800);
      if (img != null) {
        // String img64 = Global.base64Image(file: img);
        if (type == 0)
          image = img;
        else
          imageReceipt = img;

        setState(() {});
      }
    } catch (ex) {
      print(ex);
    }
  }
}
