import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:PesenSayur/util/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ENUM FOR OFFLINE DATA
enum Prefs {
  PREFS_USER_TOKEN,
  PREFS_USER_HASH,
  PREFS_USER_SHIFT,
  PREFS_USER_SHIFT_REMARK,
  PREFS_USER_TYPE,
  PREFS_USER_NAME,
  PREFS_USER_STORE_ID,
  PREFS_USER_STORE_NAME,
  PREFS_USER_STORE_ADDRESS,
  PREFS_USER_STORE_PHONE,
  PREFS_USER_STORE_CITY,
  PREFS_OFFLINE_CATEGORY,
  PREFS_OFFLINE_PRODUCT,
  PREFS_OFFLINE_PAYMENTMETHOD,
  PREFS_OFFLINE_SALESTYPE,
  PREFS_OFFLINE_CUSTOMER,
  PREFS_FAVOURITE,
  PREFS_CART,
  PREFS_CART_DETAIL,
  PREFS_PENDING_SALES,
  PREFS_PENDING_SHIFT,
  PREFS_BLUETOOTH_PRINTER_ID,
  PREFS_BLUETOOTH_PRINTER_INVOICE,
  PREFS_BLUETOOTH_PRINTER_KITCHEN,
  PREFS_BLUETOOTH_PRINTER_FOOD,
  PREFS_BLUETOOTH_PRINTER_DRINK,
}

//API URL
//const String API_URL = "https://PesenSayurloproject.com/PesenSayur-api/index.php/api/"; //NEW
//const String API_URL = "http://128.199.225.66/PesenSayur-api/index.php/api/"; //DO
//  const String API_URL = "http://103.247.10.14/PesenSayur-api/index.php/api/"; //Rumahweb
const String API_URL =
    "https://gatewaybucil2.my.id/bucil-api/index.php/api/"; //DEV

class Global {
  // POST ============================================================================
  static const API_CODE = 'code';
  static const API_SUCCESS = 'success';
  static const API_DATA = 'data';
  static const API_MESSAGE = 'message';

  //GET SERVER CODE
  static String getServerCode() {
    String serverCode = '';
    if (API_URL.contains('128.199.225.66'))
      serverCode = '- DO';
    else if (API_URL.contains('103.247.10.14'))
      serverCode = '- RW';
    else if (API_URL.contains('PesenSayurloproject.com')) serverCode = '- LIVE';

    return serverCode;
  }

  //CONNECT TO API WITH METHOD GET
  static Future getTimeout(
      {@required context,
      @required url,
      @required data,
      withLoading = true,
      timeout = const Duration(seconds: 10)}) async {
    try {
      String _parameterUrl = (data.length > 0) ? "?" : "";

      for (var item in data.entries) {
        _parameterUrl += "&" + item.key + "=" + item.value.toString();
      }

      print("API :: " + API_URL + url + _parameterUrl);
      if (withLoading) Dialogs.showLoading(context: context);
      final response = await http.get(Uri.parse(API_URL + url + _parameterUrl)).timeout(timeout);
      print("RESPONSE :: " + response.body);

      final result = json.decode(response.body);
      if (withLoading) Dialogs.hideDialog(context: context);

      return result;
    } catch (error) {
      if (withLoading) Dialogs.hideDialog(context: context);
      print(error);
      return {
        API_CODE: 400,
        API_SUCCESS: false,
        API_MESSAGE: "Connection failed"
      };
    }
  }

  //CONNECT TO API WITH METHOD POST
  static Future postTimeout(
      {@required context,
      @required url,
      @required data,
      withLoading = true,
      Duration timeout = const Duration(seconds: 30)}) async {
    try {
      print("API :: " + API_URL + url);
      print("PARAMETER :: " + json.encode(data));

      if (withLoading) Dialogs.showLoading(context: context);
      final response = await http
          .post(Uri.parse(API_URL + url),
              headers: {'Content-Type': 'application/json'},
              body: json.encode(data))
          .timeout(timeout);
      print("RESPONSE :: " + response.body);

      final result = json.decode(response.body);
      if (withLoading) Dialogs.hideDialog(context: context);

      return result;
    } catch (error) {
      if (withLoading) Dialogs.hideDialog(context: context);
      print(error);
      return {
        API_CODE: 400,
        API_SUCCESS: false,
        API_MESSAGE: "Connection failed"
      };
    }
  }
  // =================================================================================

  // DATA OFFLINE ====================================================================
  static SharedPreferences prefs;

  static Future<bool> init() async {
    prefs = await SharedPreferences.getInstance();
    return true;
  }

  static getShared({@required Prefs key, String defaults = ""}) {
    return prefs.get(key.toString()) ?? defaults;
  }

  static getSharedInt({@required Prefs key}) {
    return prefs.get(key.toString()) ?? -1;
  }

  static List<String> getSharedList({@required Prefs key}) {
    List<String> list = [];
    return prefs.getStringList(key.toString()) ?? list;
  }

  static setShared({@required Prefs key, String value}) {
    prefs.setString(key.toString(), value);
    print(prefs.getString(key.toString()) ?? "");
  }

  static setSharedInt({@required Prefs key, int value}) {
    prefs.setInt(key.toString(), value);
    print(prefs.getString(key.toString()) ?? "");
  }

  static setSharedList({@required Prefs key, List<String> value}) {
    prefs.setStringList(key.toString(), value);
  }

  static void clearSharedPrefAll() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  // =================================================================================

  // DATETIME ========================================================================
  static const DATETIME_NOSPACE = "yyyyMMddHHmmss";
  static const DATETIME_DATABASE = "yyyy-MM-dd HH:mm:ss";
  static const DATETIME_DATABASE_DATE = "yyyy-MM-dd";
  static const DATETIME_DATABASE_TIME = "HH:mm:ss";
  static const DATETIME_SHOW = "dd-MM-yyyy HH:mm";
  static const DATETIME_SHOW_DETAIL = "dd MMMM yyyy, HH:mm";
  static const DATETIME_SHOW_DATE = "dd MMMM yyyy";
  static const DATETIME_SHOW_DATE_SHORT = "dd MMM yyyy";
  static const DATETIME_SHOW_DATE_SHORT_DETAIL = "dd MMM yyyy, HH:mm";
  static const DATETIME_SHOW_TIME = "HH:mm";
  static const DATETIME_HOUR = "HH";
  static const DATETIME_MINUTE = "mm";
  static const DATETIME_YEAR = "yyyy";
  static const DATETIME_MONTH = "MM";
  static const DATETIME_MONTHYEAR = "MMMM yyyy";
  static const DATETIME_DAY = "dd";
  static const DATETIME_DAY_NAME = "EEEE";

  static String getCurrentDate({String format = DATETIME_DATABASE}) {
    initializeDateFormatting('id_ID', null);
    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat(format, Locale("id", "ID").toString()).format(now);

    return formattedDate;
  }

  static String formatDate(
      {@required String date,
      String inputPattern = DATETIME_DATABASE,
      @required String outputPattern}) {
    initializeDateFormatting('id_ID', null);
    String result = "";
    if (date != "" && date != "0000-00-00 00:00:00" && date != "0000-00-00") {
      DateFormat df = new DateFormat(inputPattern, "id_ID");
      DateFormat dfResult = new DateFormat(outputPattern, "id_ID");

      result = dfResult.format(df.parse(date));
    }
    return result;
  }

  static Future<DateTime> selectDate(BuildContext context,
      {DateTime initialDate, DateTime firstDate}) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        //  firstDate: DateTime(DateTime.now().year - 10),
        //  lastDate: DateTime.now());
        firstDate: firstDate ?? DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 10));
    if (picked != null)
      return picked;
    else
      return null;
  }
  // =================================================================================

  // ROUTE ===========================================================================
  static cupertinoNavigate(BuildContext context, Widget screen) {
    Navigator.push(context, new CupertinoPageRoute(builder: (context) {
      return screen;
    }));
  }

  static Future<dynamic> materialNavigate(
      BuildContext _context, Widget screen) {
    return Navigator.push(_context, new MaterialPageRoute(builder: (context) {
      return screen;
    }));
  }

  static Future<dynamic> materialNavigateReplace(
      BuildContext _context, Widget screen,
      {bool deletePrevious = false}) {
    if (deletePrevious) {
      return Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(builder: (BuildContext context) => screen),
          (Route<dynamic> route) => false);
    }
    return Navigator.pushReplacement(_context,
        new MaterialPageRoute(builder: (context) {
      return screen;
    }));
  }
  // =================================================================================

  // FUNCTION ========================================================================
  static String delimeter({@required String number}) {
    if (number == "") return number;
    if (number == "null" || number == null) return "";

    final formatter = new NumberFormat("#,###.####");
    double raw = double.parse(number);
    String result = formatter.format(raw).toString();
    result = result.replaceAll(",", "~~");
    result = result.replaceAll(".", "||");
    result = result.replaceAll("~~", ".");
    result = result.replaceAll("||", ",");

    return result;
  }

  static String unformatNumber({@required String number}) {
    String result = number;
    result = result.replaceAll(",", "~~");
    result = result.replaceAll(".", "||");
    result = result.replaceAll("~~", ".");
    result = result.replaceAll("||", "");

    return result;
  }

  static bool contains(
      {@required String textData, @required String textSearch}) {
    bool result = true;

    List<String> piecesSearch = textSearch.toLowerCase().trim().split(" ");
    List<String> piecesData = textData.toLowerCase().trim().split(" ");
    List<bool> checked = [];
    for (String aPiecesSearch in piecesSearch) {
      int ctrFound = 0;
      for (String aPiecesData in piecesData) {
        if (aPiecesData.contains(aPiecesSearch)) ctrFound++;
      }
      if (ctrFound == 0)
        checked.add(false);
      else
        checked.add(true);
    }

    for (int j = 0; j < checked.length; j++) {
      if (!checked[j]) result = false;
    }

    return result;
  }
  // =================================================================================

  // IMAGE ========================================================================
  static String base64Image({@required File file}) {
    List<int> imageBytes = file.readAsBytesSync();
    String string64 = base64Encode(imageBytes);
    return string64;
  }

  static String base64ImageUint8({@required Uint8List file}) {
    String string64 = base64Encode(file);
    return string64;
  }
  // =================================================================================

}
