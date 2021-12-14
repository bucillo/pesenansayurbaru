import 'dart:io';

import 'package:PesenSayur/models/api.dart';
import 'package:PesenSayur/models/order.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocation/geolocation.dart';

class ContentOrderImage extends StatefulWidget {
  final Order order;
  const ContentOrderImage({Key key, this.order}) : super(key: key);

  @override
  _ContentOrderImageState createState() => _ContentOrderImageState();
}

class _ContentOrderImageState extends State<ContentOrderImage> {
  File image;
  String latitude = '0';
  String longitude = '0';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    print("ENABLE");

    Geolocation.enableLocationServices().then((result) {
      // Request location
      print(result);
    }).catchError((e) {
      // Location Services Enablind Cancelled
      print(e);
    });

    Geolocation.currentLocation(accuracy: LocationAccuracy.best)
        .listen((result) {
      if (result.isSuccessful) {
        setState(() {
          latitude = result.location.latitude.toString();
          longitude = result.location.longitude.toString();
        });
        print("LAT: " + latitude);
        print("LON: " + longitude);
      }
    });
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
              "Atur Gambar",
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => picker(context, ImageSource.camera),
                      child: Container(
                        width: 350,
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
    } else {
      final response = API.fromJson(await Order.setImage(
          context: context,
          code: widget.order.id,
          lat: latitude,
          lon: longitude,
          attachment: Global.base64Image(file: image)));
      if (response.success) Dialogs.hideDialog(context: context);
      else Dialogs.showSimpleText(context: context, text: response.message);
    }
  }

  Future picker(BuildContext _context, ImageSource _imageSource,
      {int type = 0}) async {
    try {
      File img = await ImagePicker.pickImage(
          source: _imageSource, maxWidth: 800, maxHeight: 800);
      if (img != null) {
        // String img64 = Global.base64Image(file: img);
        if (type == 0) image = img;

        setState(() {});
      }
    } catch (ex) {
      print(ex);
    }
  }
}
