import 'dart:io';

import 'package:PesenSayur/models/api.dart';
import 'package:PesenSayur/models/order.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';

class ContentImageUrl extends StatefulWidget {
  final String url;
  const ContentImageUrl({Key key, this.url}) : super(key: key);

  @override
  _ContentImageUrlState createState() => _ContentImageUrlState();
}

class _ContentImageUrlState extends State<ContentImageUrl> {

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
        body: _content(),
      )),
    );
  }

  Widget _content() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: widget.url,
            placeholder: (context,url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Icon(Icons.error)
          )
        ],
      )
    );
  }
}
