import 'package:package_info/package_info.dart';
import 'package:PesenSayur/models/api.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:flutter/material.dart';
import 'package:PesenSayur/models/auth.dart';
import 'package:PesenSayur/screens/content_home.dart';
import 'package:PesenSayur/screens/content_order_start.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:PesenSayur/util/global.dart';

//PAGE LOGIN
class ContentLogin extends StatefulWidget {
  ContentLogin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ContentLoginState createState() => _ContentLoginState();
}

class _ContentLoginState extends State<ContentLogin> {
  String version = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController etEmail = new TextEditingController();
  final TextEditingController etPassword = new TextEditingController();
  FocusNode pwdFocusNode = new FocusNode();

  @override
  void dispose() {
    super.dispose();
    etEmail.dispose();
    etPassword.dispose();
    pwdFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      setState(() {});
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (Global.getShared(key: Prefs.PREFS_USER_TOKEN, defaults: "") != "") {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return ContentHome();
          //  return ContentOrderStart();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new SafeArea(
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 150),
                Text(
                  "PESANAN ",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "v$version${Global.getServerCode()}",
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: etEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "User",
                      hintText: "Masukkan User",
                      prefixIcon: Icon(Icons.mail_outline)),
                  validator: (_) {
                    if (etEmail.text.trim().isEmpty) {
                      return "User wajib diisi";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: etPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Masukkan Password",
                      prefixIcon: Icon(Icons.lock_outline)),
                  validator: (_) {
                    if (etPassword.text.trim().isEmpty) {
                      return "Password wajib diisi";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10),
                      side: BorderSide(color: Constants.darkAccent),
                    ),
                    color: Constants.lightAccent,
                    textColor: Colors.white,
                    onPressed: submitLogin,
                  ),
                ),
                SizedBox(height: 60)
              ],
            ),
          )),
    ));
  }

  // Submit Login
  void submitLogin() async {
    if (_formKey.currentState.validate()) {
      final response = API.fromJson(await Auth.login(
          context: context, email: etEmail.text, password: etPassword.text));

      if (response.success) {
        Auth auth = Auth.fromJson(response.data);
        Global.setShared(key: Prefs.PREFS_USER_TOKEN, value: auth.token);
        Global.setShared(key: Prefs.PREFS_USER_HASH, value: auth.hash);
        Global.setShared(key: Prefs.PREFS_USER_TYPE, value: auth.type);
        Global.setShared(key: Prefs.PREFS_USER_NAME, value: auth.name);
        Global.setShared(key: Prefs.PREFS_USER_STORE_ID, value: auth.storeId);
        Global.setShared(
            key: Prefs.PREFS_USER_STORE_NAME, value: auth.storeName);
        Global.setShared(
            key: Prefs.PREFS_USER_STORE_ADDRESS, value: auth.storeAddress);
        Global.setShared(
            key: Prefs.PREFS_USER_STORE_PHONE, value: auth.storePhone);
        Global.setShared(
            key: Prefs.PREFS_USER_STORE_CITY, value: auth.storeCity);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          //    return ContentOrderStart();
          return ContentHome();
        }));
      } else
        Dialogs.showSimpleText(context: context, text: response.message);
    }
  }
}
