import 'package:PesenSayur/screens/content_home.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';

//PAGE SUCCESS PAYMENT
class ContentSuccessPay extends StatefulWidget {
  final String method;
  final double change;

  ContentSuccessPay({this.method, this.change});

  @override
  _ContentSuccessPayState createState() => _ContentSuccessPayState();
}

class _ContentSuccessPayState extends State<ContentSuccessPay> {
  String method;
  double change;
  @override
  void initState() {
    super.initState();
    method = widget.method ?? '';
    change = widget.change ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Constants.darkAccent,
          title: Text(
            'Pembayaran Sukses',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: Container(
                          color: Constants.darkAccent,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Pembayaran dengan $method berhasil dilakukan',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Uang Kembali',
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      'Rp. ${Global.delimeter(number: change.toString())}',
                      style: TextStyle(fontSize: 50),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
        bottomSheet: InkWell(
          child: Container(
            width: double.infinity,
            color: Constants.darkAccent,
            padding: EdgeInsets.all(8.0),
            child: Center(
              heightFactor: 2,
              child: Text(
                'SELESAI',
                style: TextStyle(
                    color: Constants.lightPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          onTap: () {
            Global.materialNavigateReplace(context, ContentHome(),
                deletePrevious: true);
          },
        ),
      ),
    );
  }
}
