import 'package:PesenSayur/screens/content_login.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:PesenSayur/widgets/widget_hotrestart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((_) {
    runApp(new HotRestartController(child: new MyApp()));
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSwitchedDarkMode = false;
  SharedPreferences sharedPrefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      this.getDarkMode();
    });
  }

  void getDarkMode() async {
    final bool tempDarkMode = sharedPrefs.getBool('isSwitchedDarkMode');
    this.isSwitchedDarkMode = (tempDarkMode == null) ? false : tempDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Constants.appName,
        theme: (this.isSwitchedDarkMode == true)
            ? Constants.darkTheme
            : Constants.lightTheme,
        home: ContentLogin());
  }
}
