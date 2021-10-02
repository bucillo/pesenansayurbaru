import 'package:PesenSayur/screens/content_absence_start.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';

class ContentAbsenceResult extends StatefulWidget {
  final String name;
  final String date;
  final String type;

  const ContentAbsenceResult({Key key, this.name, this.date, this.type})
      : super(key: key);

  @override
  _ContentAbsenceResultState createState() => _ContentAbsenceResultState();
}

class _ContentAbsenceResultState extends State<ContentAbsenceResult> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _content(),
    ));
  }

  Widget _content() {
    String type = "Absen Masuk";
    if (widget.type == "1") type = "Absen Pulang";

    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: availableHeight * 2 / 3,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_sharp,
                size: 200,
              ),
              SizedBox(height: 50),
              Text(
                "ABSEN BERHASIL",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: Text(
                  "Selamat " +
                      widget.name +
                      ", kamu berhasil " +
                      type +
                      " pada " +
                      Global.formatDate(
                          date: widget.date,
                          outputPattern: Global.DATETIME_SHOW),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: availableHeight * 1 / 3,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: FlatButton(
            child: Text(
              "Kembali",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(50),
              side: BorderSide(color: Constants.darkAccent),
            ),
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            color: Constants.lightAccent,
            textColor: Colors.white,
            onPressed: submit,
          ),
        ),
      ],
    );
  }

  void submit() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return ContentAbsenceStart();
    }));
  }
}
