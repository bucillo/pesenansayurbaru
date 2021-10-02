import 'dart:io';

import 'package:PesenSayur/models/absence.dart';
import 'package:PesenSayur/models/absenceType.dart';
import 'package:PesenSayur/models/api.dart';
import 'package:PesenSayur/models/auth.dart';
import 'package:PesenSayur/models/employee.dart';
import 'package:PesenSayur/screens/content_absence_result.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';

class ContentAbsence extends StatefulWidget {
  @override
  _ContentAbsenceState createState() => _ContentAbsenceState();
}

class _ContentAbsenceState extends State<ContentAbsence> {
  Employee employeeSelected;
  AbsenceType absenceTypeSelected;
  List<Employee> listEmployee = [];
  List<AbsenceType> listAbsenceType = [];
  int typeAbsence;
  File image;
  bool chooseShift = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      fetchEmployee();
      fetchAbsenceType();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.sync, color: Constants.lightNavbarBG),
            //   onPressed: null,
            // ),
          ],
          backgroundColor: Colors.white,
          title: Center(
              child: Text(
            "Absen",
            style: TextStyle(color: Constants.lightAccent),
          ))),
      body: _content(),
    ));
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => picker(context, ImageSource.camera),
                child: Container(
                  width: 250,
                  height: 350,
                  color: Colors.black12,
                  child: (image == null)
                      ? Icon(FontAwesome.camera, size: 60)
                      : Image.file(image, width: 300),
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(15)),
                child: DropdownButton(
                  hint: Text("Pilih Karyawan"),
                  icon: Icon(Icons.arrow_drop_down_rounded),
                  iconSize: 36,
                  isExpanded: true,
                  underline: SizedBox(),
                  value: employeeSelected,
                  items: listEmployee.map((valueItem) {
                    return DropdownMenuItem(
                        value: valueItem, child: Text(valueItem.name));
                  }).toList(),
                  onChanged: (newValue) {
                    employeeSelected = newValue;
                    setState(() {});
                    checkEmployee();
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(15)),
                child: DropdownButton(
                  hint: Text("Pilih Tipe Shift"),
                  icon: Icon(Icons.arrow_drop_down_rounded),
                  iconSize: 36,
                  isExpanded: true,
                  underline: SizedBox(),
                  value: absenceTypeSelected,
                  items: listAbsenceType.map((valueItem) {
                    return DropdownMenuItem(
                        value: valueItem, child: Text(valueItem.name));
                  }).toList(),
                  onChanged: (!chooseShift)
                      ? null
                      : (newValue) {
                          absenceTypeSelected = newValue;
                          setState(() {});
                          checkAbsence();
                        },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void submit() async {
    if (employeeSelected == null) {
      Dialogs.showSimpleText(
          context: context, text: "Pilih karyawan terlebih dahulu");
    } else if (absenceTypeSelected == null) {
      Dialogs.showSimpleText(
          context: context, text: "Pilih tipe absen terlebih dahulu");
    } else if (image == null) {
      Dialogs.showSimpleText(
          context: context, text: "Ambil foto terlebih dahulu");
    } else {
      final response = API.fromJson(await Absence.insert(
          context: context,
          employee: employeeSelected.id,
          absenceType: absenceTypeSelected.id,
          type: (typeAbsence + 1).toString(),
          attachment: Global.base64Image(file: image)));
      if (response.success) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return ContentAbsenceResult(
              type: typeAbsence.toString(),
              name: employeeSelected.name,
              date: response.data);
        }));
      } else
        Dialogs.showSimpleText(context: context, text: response.message);
    }
  }

  Future picker(BuildContext _context, ImageSource _imageSource) async {
    try {
      File img = await ImagePicker.pickImage(
          source: _imageSource, maxWidth: 800, maxHeight: 800);
      if (img != null) {
        String img64 = Global.base64Image(file: img);
        print(img64);
        setState(() {
          image = img;
        });
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future<void> fetchEmployee() async {
    listEmployee = [];

    final response = API
        .fromJson(await Employee.select(context: context, showLoading: false));

    if (response.success) {
      response.data.forEach((data) {
        listEmployee.add(Employee.fromJson(data));
      });
    } else {
      if (response.code == 401) {
        Auth.logout(context);
      } else
        Dialogs.showSimpleText(context: context, text: response.message);
    }

    setState(() {});
  }

  Future<void> fetchAbsenceType() async {
    listAbsenceType = [];

    final response = API.fromJson(
        await AbsenceType.select(context: context, showLoading: false));

    if (response.success) {
      response.data.forEach((data) {
        listAbsenceType.add(AbsenceType.fromJson(data));
      });
    } else {
      if (response.code == 401) {
        Auth.logout(context);
      } else
        Dialogs.showSimpleText(context: context, text: response.message);
    }

    setState(() {});
  }

  Future<void> checkEmployee() async {
    if (employeeSelected != null) {
      final response = API.fromJson(await Absence.checkEmployee(
          context: context, employee: employeeSelected.id, showLoading: true));

      typeAbsence = 0;
      chooseShift = true;
      if (response.success) {
        for (int i = 0; i < listAbsenceType.length; i++) {
          if (listAbsenceType[i].id == response.data)
            absenceTypeSelected = listAbsenceType[i];
          typeAbsence = 1;
          chooseShift = false;
        }
      } else {
        if (response.code == 401) {
          Auth.logout(context);
        }
        // else Dialogs.showSimpleText(context: context, text: response.message);
      }
    }

    setState(() {});
  }

  Future<void> checkAbsence() async {
    if (employeeSelected != null && absenceTypeSelected != null) {
      final response = API.fromJson(await Absence.check(
          context: context,
          absenceType: absenceTypeSelected.id,
          employee: employeeSelected.id,
          showLoading: true));

      if (response.success) {
        print(response.data);
        typeAbsence = response.data;
      } else {
        if (response.code == 401) {
          Auth.logout(context);
        } else
          Dialogs.showSimpleText(context: context, text: response.message);
      }
    }

    setState(() {});
  }
}
