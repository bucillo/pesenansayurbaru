import 'dart:ffi';
import 'dart:io';

import 'package:PesenSayur/models/absence.dart';
import 'package:PesenSayur/models/absenceType.dart';
import 'package:PesenSayur/models/api.dart';
import 'package:PesenSayur/models/auth.dart';
import 'package:PesenSayur/models/employee.dart';
import 'package:PesenSayur/models/system.dart';
import 'package:PesenSayur/screens/content_home.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'content_absence.dart';

class ContentAbsenceStart extends StatefulWidget {
  @override
  _ContentAbsenceStartState createState() => _ContentAbsenceStartState();
}

class _ContentAbsenceStartState extends State<ContentAbsenceStart> {
  String dateNow = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      getDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _content(),
    ));
  }

  Widget _content() {
    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: availableHeight * 2 / 3,
          width: MediaQuery.of(context).size.width,
          color: Constants.darkAccent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (dateNow == "")
                    ? ""
                    : Global.formatDate(
                        date: dateNow,
                        outputPattern: Global.DATETIME_SHOW_TIME),
                style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              Text(
                (dateNow == "")
                    ? ""
                    : Global.formatDate(
                            date: dateNow,
                            outputPattern: Global.DATETIME_DAY_NAME) +
                        ", " +
                        Global.formatDate(
                            date: dateNow,
                            outputPattern: Global.DATETIME_SHOW_DATE),
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 150),
              Text(
                "Selamat Datang di Aplikasi Absensi",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                "Silahkan Check-In sebelum anda",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                "mulai bekerja",
                style: TextStyle(fontSize: 18, color: Colors.white),
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
              "Mulai Absen",
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
      return ContentAbsence();
    }));
    // final response = API.fromJson(await Absence.insert(context: context, employee: employeeSelected.id, absenceType: absenceTypeSelected.id, type: (typeAbsence+1).toString(), attachment: Global.base64Image(file: image)));
    // if (response.success) {
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
    //       return ContentHome();
    //   }));
    // }
    // else Dialogs.showSimpleText(context: context, text: response.message);
  }

  Future<void> getDate() async {
    final response =
        API.fromJson(await System.date(context: context, showLoading: false));

    if (response.success) {
      dateNow = response.data;
    }

    setState(() {});
  }
}
