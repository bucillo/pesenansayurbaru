import 'package:PesenSayur/models/api.dart';
import 'package:PesenSayur/models/order.dart';
import 'package:PesenSayur/screens/content_order.dart';
import 'package:PesenSayur/screens/content_order_send.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:PesenSayur/models/product.dart';

import '../bluetooth_printer.dart';

class ContentOrderHistory extends StatefulWidget {
  final DateTime dateTimeStart;
  final DateTime dateTimeEnd;

  const ContentOrderHistory({Key key, this.dateTimeStart, this.dateTimeEnd})
      : super(key: key);

  @override
  _ContentOrderHistoryState createState() => _ContentOrderHistoryState();
}

class _ContentOrderHistoryState extends State<ContentOrderHistory> {
  int totalTransaction = 0;
  List<Order> _order = [];
  List<Product> product;
  DateTime dateStart = DateTime.now();
  DateTime dateEnd = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.dateTimeStart != null) dateStart = widget.dateTimeStart;
    if (widget.dateTimeEnd != null) dateEnd = widget.dateTimeEnd;
    dateStart = new DateTime(dateStart.year, dateStart.month, dateStart.day);
    dateEnd = new DateTime(dateEnd.year, dateEnd.month, dateEnd.day);
    Future.delayed(Duration.zero, () async {
      select();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.lightNavbarBG,
        title: Text(
          "Order List",
          style: TextStyle(color: Constants.lightAccent),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              select();
            },
            child: Icon(Icons.sync)
          )
        ],
      ),
      body: SafeArea(
          child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Global.selectDate(context,
                                    initialDate: dateStart,
                                    firstDate: DateTime(DateTime.now().year - 1))
                                .then((dateNew) {
                              if (dateNew != null) {
                                dateStart = dateNew;
                                select();
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            margin: EdgeInsets.only(left: 10, right: 5),
                            decoration: BoxDecoration(
                              color: Constants.darkAccent,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                Global.formatDate(
                                    date: dateStart.toString(),
                                    inputPattern: Global.DATETIME_DATABASE,
                                    outputPattern: Global.DATETIME_SHOW_DATE),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Global.selectDate(context,
                                    initialDate: dateEnd, firstDate: dateStart)
                                .then((dateNew) {
                              if (dateNew != null) {
                                dateEnd = dateNew;
                                select();
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            margin: EdgeInsets.only(right: 10, left: 5),
                            decoration: BoxDecoration(
                              color: Constants.darkAccent,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                Global.formatDate(
                                    date: dateEnd.toString(),
                                    inputPattern: Global.DATETIME_DATABASE,
                                    outputPattern: Global.DATETIME_SHOW_DATE),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("Total Transaksi",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                            Global.delimeter(
                                                number: totalTransaction.toString()),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Text("Aktifitas",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black26))),
                        if (Global.getShared(key: Prefs.PREFS_USER_TYPE) == "3") ...[
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: Constants.darkAccent,
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(15),
                                    right: Radius.circular(15),
                                  ),
                                ),
                                child: IconButton(
                                    icon: Icon(Icons.add,
                                        color: Colors.white, size: 20),
                                    onPressed: () {
                                      Global.materialNavigate(context,
                                              ContentOrder(datetime: dateEnd))
                                          .then((value) => select());
                                    }),
                              ),
                            ),
                          )
                        ] else ...[
                          if (_order.length > 0) ...[
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: Constants.darkAccent,
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(15),
                                      right: Radius.circular(15),
                                    ),
                                  ),
                                  child: IconButton(
                                      icon: Icon(Icons.print,
                                          color: Colors.white, size: 20),
                                      onPressed: () async {
                                        List<Order> order = [];
                                        Dialogs.showPrintCategory(
                                            context: context,
                                            action: (result) async {
                                              Dialogs.hideDialog(context: context);
                                              int error = 0;
                                              for (int i = 0;
                                                  i < _order.length;
                                                  i++) {
                                                if (_order[i].active == "1") {
                                                  if (result == -1 || result == 0) {
                                                    if (_order[i].statusConfirm ==
                                                        "0") {
                                                      final response = API.fromJson(
                                                          await Order.print(
                                                              context: context,
                                                              code: _order[i].id));
                                                      if (!response.success) {
                                                        error++;
                                                      }
                                                    }
                                                  }

                                                  if (result == 0) {
                                                    if (_order[i].statusConfirm ==
                                                        "0") order.add(_order[i]);
                                                  } else if (result == 2) {
                                                    if (_order[i].statusConfirm ==
                                                        "2") order.add(_order[i]);
                                                  } else if (result == 3) {
                                                    if (_order[i].statusConfirm ==
                                                        "2") order.add(_order[i]);
                                                  } else
                                                    order.add(_order[i]);
                                                }
                                              }

                                              if (error == 0) {
                                                Printing()
                                                    .printReseller(context, order);
                                                select();
                                              }
                                            });
                                      }),
                                ),
                              ),
                            )
                          ]
                        ]
                      ],
                    ),
                  ),
                  if (_order.length > 0) ...[
                    Center(
                      child: ListView.builder(
                        // physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _order.length,
                        itemBuilder: (context, index) {
                          String detail = "";
                          if (_order[index].active == "1") {
                            if (_order[index].statusConfirm == "0")
                              detail = "\n[BELUM KONFIRMASI]\n";
                            else if (_order[index].statusConfirm == "1")
                              detail = "\n[SUDAH KONFIRMASI]\n";
                            else if (_order[index].statusConfirm == "2")
                              detail = "\n[ON PROSES]\n";
                            else if (_order[index].statusConfirm == "3")
                              detail = "\n[ON SEND]\n";
                            else if (_order[index].statusConfirm == "4")
                              detail = "\n[SUDAH KONFIRMASI]\n";
                          }

                          detail += "\nCustomer: " + _order[index].customerName;
                          detail += "\nAlamat: " + _order[index].customerAddress;
                          detail += "\nTelp: " + _order[index].customerPhone;
                          detail += "\n\nPesanan:\n" + _order[index].description;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                onTap: () {
                                  if (Global.getShared(key: Prefs.PREFS_USER_TYPE) ==
                                      "3") {
                                    if (_order[index].statusConfirm == "0" &&
                                        _order[index].active == "1")
                                      _dialogAction(_order[index]);
                                  } else {
                                    if (_order[index].statusConfirm == "2" &&
                                        _order[index].active == "1")
                                      _dialogAction(_order[index]);
                                  }
                                },
                                title: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (_order[index].active == "0") ...[
                                          Text(
                                            "[BATAL]",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                          Text(
                                            _order[index].code,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                        ] else ...[
                                          Text(
                                            _order[index].code,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]
                                      ],
                                    )
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    Expanded(child: Text(detail)),
                                    if (_order[index].imageSent != "") ...[
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(12),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          width: 200,
                                                          height: 200,
                                                          child: CachedNetworkImage(
                                                            imageUrl:
                                                                "https://gatewaybucil2.my.id/order/" +
                                                                    _order[index]
                                                                        .imageSent,
                                                            placeholder: (context,
                                                                    url) =>
                                                                new CircularProgressIndicator(),
                                                            errorWidget: (context,
                                                                    url, error) =>
                                                                new Icon(Icons.error),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Container(
                                                          width: 200,
                                                          height: 200,
                                                          child: CachedNetworkImage(
                                                            imageUrl:
                                                                "https://gatewaybucil2.my.id/order/" +
                                                                    _order[index]
                                                                        .imageReceipt,
                                                            placeholder: (context,
                                                                    url) =>
                                                                new CircularProgressIndicator(),
                                                            errorWidget: (context,
                                                                    url, error) =>
                                                                new Icon(Icons.error),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Text("GAMBAR",
                                            style: TextStyle(color: Colors.blue)),
                                      )
                                    ]
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ] else ...[
                    SizedBox(height: 80),
                    Image.asset(
                      'assets/file-storage.png',
                      width: 100.0,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Text("Tidak ada data")
                  ]
                ],
              ))),
    );
  }

  Future<void> select() async {
    totalTransaction = 0;
    _order = [];

    final response = API.fromJson(await Order.select(
        context: context,
        dateStart: dateStart.toString(),
        dateEnd: dateEnd.toString()));
    if (response.success) {
      response.data.forEach((data) {
        Order orderData = Order.fromJson(data);
        bool canShow = true;
        if (Global.getShared(key: Prefs.PREFS_USER_TYPE) == "2") {
          if (orderData.statusConfirm == "5") {
            canShow = false;
          }
        }

        if (canShow) {
          totalTransaction++;
          _order.add(orderData);
        }
      });
    }

    setState(() {});
  }

  Future<void> delete(Order _order) async {
    final response =
        API.fromJson(await Order.delete(context: context, code: _order.id));
    if (response.success) {
      Dialogs.hideDialog(context: context);
      select();
    } else
      Dialogs.showSimpleText(context: context, text: response.message);
  }

  Future<void> confirm(Order _order) async {
    // final response = API.fromJson(await Order.confirm(context: context, code: _order.id));
    // if (response.success) {
    //   Dialogs.hideDialog(context: context);
    //   select();
    // } else
    //   Dialogs.showSimpleText(context: context, text: response.message);
  }

  void _dialogAction(Order _order) {
    if (Global.getShared(key: Prefs.PREFS_USER_TYPE) == "3") {
      showDialog(
          context: context,
          builder: (context) => StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  elevation: 24,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  content: Container(
                    width: 150,
                    height: 100,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Global.materialNavigate(
                                      context, ContentOrder(order: _order))
                                  .then((value) {
                                Dialogs.hideDialog(context: context);
                                select();
                              });
                            },
                            child: Image.asset(
                              'assets/edit.png',
                              width: 50.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Dialogs.showYesNo(
                                  context: context,
                                  text:
                                      "Apakah yakin menghapus data pembelian?",
                                  action: (result) {
                                    if (result) {
                                      delete(_order);
                                    }
                                  });
                            },
                            child: Image.asset(
                              'assets/delete.png',
                              width: 50.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }));
    } else {
      if (_order.statusConfirm == "2") {
        Global.materialNavigate(context, ContentOrderSend(order: _order))
            .then((value) {
          select();
        });
      }
    }
  }
}
