import 'dart:io';

import 'package:PesenSayur/models/absence.dart';
import 'package:PesenSayur/models/absenceType.dart';
import 'package:PesenSayur/models/api.dart';
import 'package:PesenSayur/models/auth.dart';
import 'package:PesenSayur/models/employee.dart';
import 'package:PesenSayur/models/order.dart';
import 'package:PesenSayur/models/order_detail.dart';
import 'package:PesenSayur/screens/content_absence_result.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';

class ContentOrderDetail extends StatefulWidget {
  final String orderId;
  const ContentOrderDetail({Key key, this.orderId}) : super(key: key);

  @override
  _ContentOrderDetailState createState() => _ContentOrderDetailState();
}

class _ContentOrderDetailState extends State<ContentOrderDetail> {
  Order _order;
  String detail = "";
  double total = 0;
  List<OrderDetail> detailList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      load();
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
              "Detail",
              style: TextStyle(color: Constants.lightAccent),
            ))),
        body: _content(),
      )),
    );
  }

  Widget _content() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Stack(
        children: [
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if(_order != null) ...[
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_order.active == "0") ...[
                            Text(
                              "[BATAL]",
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),
                            ),
                            Text(
                              _order.code,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                          ] 
                          else ...[
                            Text(
                              _order.code,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ]
                        ],
                      )
                    ],
                  ),
                  Text(
                    _order.code,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(detail)
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  void load() async {
    final response = API.fromJson(await Order.get(
      context: context,
      id: widget.orderId
    ));
    if (response.success) {
      // Dialogs.hideDialog(context: context);
      
      response.data.forEach((data) {
        print("data");
        print(data);
        _order = Order.fromJson(data);
      });

      List<dynamic> temp = List<dynamic>.from(_order.detail as List);

      detail += "\nTanggal: " + Global.formatDate(date: _order.date, outputPattern: Global.DATETIME_SHOW);
      detail += "\nCustomer: " + _order.customerName;
      if(_order.customerArea != "") detail += "\nArea: " + _order.customerArea;
      detail += "\nAlamat: " + _order.customerAddress;
      detail += "\nTelp: " + _order.customerPhone;

      if(_order.description != ""){
        detail += "\n\nKeterangan tambahan : \n " + _order.description;
      }
      detail += "\n\nPesanan:";

      temp.forEach((data) {
        OrderDetail orderDetail = new OrderDetail.fromJson(data);
        detailList.add(orderDetail);
        double subtotal = orderDetail.qty * orderDetail.price;
        total += subtotal;
        detail += "\n" + Global.delimeter(number: orderDetail.qty.toString()) + " x " + orderDetail.name + " (Rp. " + Global.delimeter(number: subtotal.toString()) + ")";
      });

      detail += "\n\nTotal: Rp. " + Global.delimeter(number: total.toString()); 

      setState(() {});
    } 
    else Dialogs.showSimpleText(context: context, text: response.message);
  }
}
