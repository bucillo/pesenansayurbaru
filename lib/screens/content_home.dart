import 'package:package_info/package_info.dart';
import 'package:PesenSayur/models/auth.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';
import '../printer_settings.dart';
import '../util/global.dart';
import 'package:PesenSayur/screens/content_order_history.dart';

//PAGE CART
class ContentHome extends StatefulWidget {
  @override
  _ContentHomeState createState() => _ContentHomeState();
}

class _ContentHomeState extends State<ContentHome> {
  String version = "";
  bool logout = false;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
    });

    Future.delayed(Duration.zero, () async {
      fetchData();
      // if (Global.getShared(key: Prefs.PREFS_USER_TYPE) == "2"){
      //   Global.materialNavigate(context, ContentOrderHistory());
      // }
    });
  }

  Future<void> fetchData() async {
    logout = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  "v$version${Global.getServerCode()}",
                  style: TextStyle(fontSize: 8),
                ),
                SizedBox(height: 10),
                Text(
                  Global.getShared(key: Prefs.PREFS_USER_NAME),
                  style: TextStyle(
                      fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  Global.getShared(key: Prefs.PREFS_USER_STORE_NAME),
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                ),
                SizedBox(height: 30),
                if (Global.getShared(key: Prefs.PREFS_USER_TYPE) == "2") ...[
                  InkWell(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text("Pengaturan Printer"),
                      ),
                    ),
                    onTap: () =>
                        Global.materialNavigate(context, PrinterSettings()),
                  ),
                  Divider(),
                ],
                Expanded(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    child: Container(
                      width: double.infinity,
                      color: Constants.darkAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(
                        "Keluar",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      Dialogs.showYesNo(
                          context: context,
                          text: "Apakah anda yakin untuk keluar?",
                          action: (result) {
                            if (result) {
                              Auth.logout(context);
                            }
                          });
                    },
                  ),
                ))
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Constants.lightNavbarBG,
          ),
          body: _body()),
    );
  }

  Widget _body() {
    if (Global.getShared(key: Prefs.PREFS_USER_TYPE) == "2") {
      return ContentOrderHistory();
    } else {
      return Column(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/image_onboarding.png',
                  width: 355,
                ),
                SizedBox(
                  height: 80,
                ),
                Text(
                  'Order',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Reseller silakan order ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Global.materialNavigateReplace(context, ContentOrderHistory());
                        Global.materialNavigate(context, ContentOrderHistory());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Start order >',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
