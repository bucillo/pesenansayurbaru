import 'package:PesenSayur/dialogs/customer.dart';
import 'package:PesenSayur/models/api.dart';
import 'package:PesenSayur/models/customer.dart';
import 'package:PesenSayur/models/order.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:flutter/services.dart';

import 'content_order_history.dart';

class ContentOrder extends StatefulWidget {
  final Order order;
  final DateTime datetime;
  const ContentOrder({Key key, this.order, this.datetime}) : super(key: key);

  @override
  _ContentOrderState createState() => _ContentOrderState();
}

class _ContentOrderState extends State<ContentOrder> {
  var _isVisible;
  bool _loading = false;
  List<Customer> _customerFull = [];
  List<Customer> _customer = [];
  DateTime date = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  TextEditingController _searchController = new TextEditingController();
  TextEditingController _customerController = new TextEditingController();
  TextEditingController _alamatController = new TextEditingController();
  TextEditingController _telpController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  TextEditingController _descController2 = new TextEditingController();
  String hour = "";
  String minute = "";

  @override
  void initState() {
    _searchController.addListener(search);
    if (widget.order != null) {
      _customerController.text = widget.order.customerName;
      _alamatController.text = widget.order.customerAddress;
      _telpController.text = widget.order.customerPhone;
      _descController.text = widget.order.description;
      //    _descController2.text = widget.order.description2;
      date = DateTime(
          int.parse(Global.formatDate(
              date: widget.order.date, outputPattern: Global.DATETIME_YEAR)),
          int.parse(Global.formatDate(
              date: widget.order.date, outputPattern: Global.DATETIME_MONTH)),
          int.parse(Global.formatDate(
              date: widget.order.date, outputPattern: Global.DATETIME_DAY)));
      hour = Global.formatDate(
          date: widget.order.date, outputPattern: Global.DATETIME_HOUR);
      minute = Global.formatDate(
          date: widget.order.date, outputPattern: Global.DATETIME_MINUTE);

      setState(() {});
    }
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customerController.dispose();
    _alamatController.dispose();
    _telpController.dispose();
    _descController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.of(context).pop(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.lightNavbarBG,
          title: Text(
            "Order",
            style: TextStyle(color: Constants.lightAccent),
          ),
        ),
        body: SafeArea(
            child: Container(
                child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Global.selectDate(context, initialDate: date)
                                  .then((dateNew) {
                                if (dateNew != null) {
                                  if (date != dateNew) {
                                    hour = "";
                                    minute = "";
                                  }
                                  date = dateNew;
                                  setState(() {});
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: Constants.darkAccent,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                  right: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_today,
                                        color: Colors.white),
                                    SizedBox(width: 5),
                                    Text(
                                      Global.formatDate(
                                          date: date.toString(),
                                          inputPattern:
                                              Global.DATETIME_DATABASE,
                                          outputPattern:
                                              Global.DATETIME_SHOW_DATE),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final time = await showTimePicker(
                                context: context,
                                builder: (BuildContext context, Widget child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child,
                                  );
                                },
                                initialTime:
                                    TimeOfDay.fromDateTime(DateTime.now()));
                            if (time != null) {
                              String dateNow = Global.getCurrentDate(
                                  format: Global.DATETIME_DATABASE_DATE);
                              String dateCompare = date.year.toString() +
                                  "-" +
                                  date.month.toString().padLeft(2, '0') +
                                  "-" +
                                  date.day.toString().padLeft(2, '0');
                              if (dateNow == dateCompare) {
                                if (TimeOfDay.fromDateTime(DateTime.now())
                                            .hour +
                                        2 >
                                    time.hour) {
                                  print(time.hour);
                                  Dialogs.showSimpleText(
                                      context: context,
                                      text: "Jam dipilih " +
                                          time.hour.toString().padLeft(2, "0") +
                                          ":" +
                                          time.minute
                                              .toString()
                                              .padLeft(2, "0") +
                                          "\nPaling cepat 2 jam dari sekarang");
                                } else {
                                  hour = time.hour.toString().padLeft(2, '0');
                                  minute =
                                      time.minute.toString().padLeft(2, '0');
                                  setState(() {});
                                }
                              } else {
                                hour = time.hour.toString().padLeft(2, '0');
                                minute = time.minute.toString().padLeft(2, '0');
                                setState(() {});
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 14),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Constants.darkAccent,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.alarm, color: Colors.white),
                                  if (hour != "") ...[
                                    SizedBox(width: 5),
                                    Text(
                                      hour + ":" + minute,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Customer: "),
                              Flexible(
                                child: TextFormField(
                                  controller: _customerController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await getCustomer();
                                },
                                child: Text(
                                  "      CARI",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Alamat: "),
                              Flexible(
                                child: TextFormField(
                                  controller: _alamatController,
                                  keyboardType: TextInputType.multiline,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Telp: "),
                              Flexible(
                                child: TextFormField(
                                  controller: _telpController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {},
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Pemberitahuan : "),
                              Flexible(
                                child: TextFormField(
                                  controller: _descController2,
                                  keyboardType: TextInputType.multiline,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text("Pesanan: "),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: TextFormField(
                                  maxLines: 5,
                                  controller: _descController,
                                  keyboardType: TextInputType.multiline,
                                  onChanged: (value) {},
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                save();
              },
              child: Container(
                margin: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Constants.darkAccent,
                ),
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "SIMPAN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ))),
      ),
    );
  }

  void search() {
    setState(() {
      _customer = [];
      _customerFull.forEach((data) {
        if (Global.contains(
            textData: data.name, textSearch: _searchController.text)) {
          _customer.add(data);
        }
      });
      _loading = false;
    });
  }

  Future<void> getCustomer() async {
    final response = API.fromJson(await Customer.select(context: context));
    if (response.success) {
      _customerFull = [];
      _customer = [];
      response.data.forEach((data) {
        _customerFull.add(Customer.fromJson(data));
        _customer.add(Customer.fromJson(data));
      });
      setState(() {});

      CustomerDialog.show(
          context: context,
          list: _customerFull,
          action: (name, code, phone, address) {
            _customerController.text = name;
            if (address != "") _alamatController.text = address;
            if (phone != "") _telpController.text = phone;
          });
    } else
      Dialogs.showSimpleText(
          context: context, text: "Tidak ada data pelanggan");
  }

  Future<void> save() async {
    bool success = true;
    String dateSend = date.year.toString() +
        "-" +
        date.month.toString().padLeft(2, "0") +
        "-" +
        date.day.toString().padLeft(2, "0") +
        " " +
        hour.toString().padLeft(2, "0") +
        ":" +
        minute.toString().padLeft(2, "0") +
        ":00";
    if (hour == "") {
      success = false;
      Dialogs.showSimpleText(
          context: context,
          text:
              "Pilih jam kirim terlebih dahulu,\nPaling cepat 2 jam dari sekarang");
    } else if (_customerController.text == "") {
      success = false;
      Dialogs.showSimpleText(context: context, text: "Customer dibutuhkan");
    } else if (_alamatController.text == "") {
      success = false;
      Dialogs.showSimpleText(
          context: context, text: "Alamat customer dibutuhkan");
    } else if (_telpController.text == "") {
      success = false;
      Dialogs.showSimpleText(
          context: context, text: "Telepon customer dibutuhkan");
    } else if (_descController.text == "") {
      success = false;
      Dialogs.showSimpleText(context: context, text: "Pesanan masih kosong");
    }

    if (success) {
      if (widget.order == null) {
        //ORDER BARU
        final response = API.fromJson(await Order.insert(
            context: context,
            date: dateSend,
            customerName: _customerController.text,
            customerAddress: _alamatController.text,
            customerPhone: _telpController.text,
            description: _descController.text,
            description2: _descController2.text));
        if (response.success) {
          Global.materialNavigateReplace(context, ContentOrderHistory());
          Dialogs.hideDialog(context: context);
        } else
          Dialogs.showSimpleText(context: context, text: response.message);
      } else {
        //UPDATE ORDER
        final response = API.fromJson(await Order.update(
            context: context,
            code: widget.order.id,
            date: dateSend,
            customerName: _customerController.text,
            customerAddress: _alamatController.text,
            customerPhone: _telpController.text,
            description: _descController.text,
            description2: _descController2.text));
        if (response.success) {
          Dialogs.hideDialog(context: context);
        } else
          Dialogs.showSimpleText(context: context, text: response.message);
      }
    }
  }
}
