import 'dart:async';
import 'dart:convert';

import 'package:PesenSayur/bluetooth_printer.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/printer.dart';
import 'util/global.dart';

class PrinterList extends StatefulWidget {
  final String type;

  PrinterList({@required this.type});

  @override
  _PrinterListState createState() => _PrinterListState();
}

class _PrinterListState extends State<PrinterList> {
  static const platform = const MethodChannel("printer");
  List<Printer> _printers = [];
  List<Printer> _selectedDevices = [];
  List<Printer> _hiddenDevices =
      []; //? sembunyikan device yg sudah terpilih di kategori lain
  String type;
  bool _isDisposed = false;
  bool _isBluetoothEnabled = false;
  Timer t;
  Prefs key;

  @override
  void initState() {
    super.initState();
    type = widget.type;
    _selectedDevices = [];
    if (type == PrinterType.PRINTER_INVOICE) {
      key = Prefs.PREFS_BLUETOOTH_PRINTER_INVOICE;
    } else if (type == PrinterType.PRINTER_KITCHEN) {
      key = Prefs.PREFS_BLUETOOTH_PRINTER_KITCHEN;
    } else if (type == PrinterType.PRINTER_FOOD) {
      key = Prefs.PREFS_BLUETOOTH_PRINTER_FOOD;
    } else if (type == PrinterType.PRINTER_DRINK) {
      key = Prefs.PREFS_BLUETOOTH_PRINTER_DRINK;
    }
    t = Timer.periodic(Duration(seconds: 5), (timer) {
      _checkBTEnabled();
    });
    _checkBTEnabled();
  }

  void _hideDevices() {
    //todo jika device sudah dipilih sebagai printer type berbeda, jangan tampilkan lagi
    String jsonPrinter;
    if (type == PrinterType.PRINTER_INVOICE) {
      jsonPrinter =
          Global.getShared(key: Prefs.PREFS_BLUETOOTH_PRINTER_KITCHEN);
    } else if (type == PrinterType.PRINTER_KITCHEN) {
      jsonPrinter =
          Global.getShared(key: Prefs.PREFS_BLUETOOTH_PRINTER_INVOICE);
    } else if (type == PrinterType.PRINTER_FOOD) {
      jsonPrinter = Global.getShared(key: Prefs.PREFS_BLUETOOTH_PRINTER_FOOD);
    } else if (type == PrinterType.PRINTER_DRINK) {
      jsonPrinter = Global.getShared(key: Prefs.PREFS_BLUETOOTH_PRINTER_DRINK);
    }
    // print(
    //     'shared printer: ${Global.getShared(key: Prefs.PREFS_BLUETOOTH_PRINTER_INVOICE)}');
    if (jsonPrinter.isNotEmpty) {
      _hiddenDevices =
          ArrayOfPrinter.fromJson(jsonDecode(jsonPrinter)).printers;
      if (_hiddenDevices.length > 0) {
        for (var i = 0; i < _printers.length; i++) {
          for (var j = 0; j < _hiddenDevices.length; j++) {
            if (_hiddenDevices[j].printerId == _printers[i].printerId) {
              setState(() {
                _printers.removeAt(i);
              });
              i = 0;
            }
          }
        }
      }
    }
  }

  void _checkBTEnabled() async {
    if (_isDisposed) return;
    try {
      bool tempBool = await platform.invokeMethod('isBluetoothEnabled');
      setState(() {
        _isBluetoothEnabled = tempBool;
      });
      print('_isBluetoothEnabled : $_isBluetoothEnabled');
    } catch (e) {
      setState(() {
        _isBluetoothEnabled = false;
      });
    } finally {
      if (_isBluetoothEnabled) {
        t.cancel();
        showPairedDevices();
      }
    }
  }

  void showPairedDevices() async {
    Map<dynamic, dynamic> pairedDevices =
        await platform.invokeMethod('get_paired_devices');
    // print(pairedDevices.toString());
    List<Printer> tempList = [];
    if (pairedDevices == null || pairedDevices.isEmpty) return;
    pairedDevices
        .forEach((k, v) => tempList.add(Printer(printerId: k, printerName: v)));
    setState(() {
      _printers = tempList;
    });
    // _hideDevices();
    _showSelectedDevices();
  }

  void _showSelectedDevices() {
    print('showing selected devices');
    if (Global.getShared(key: key).toString().isEmpty) return;
    // _selectedDevices = jsonDecode(Global.getShared(key: key));
    var result =
        ArrayOfPrinter.fromJson(jsonDecode(Global.getShared(key: key)));
    _selectedDevices = result.printers;
  }

  void _gotoBTSettings() async {
    await platform.invokeMethod('bluetooth_settings').then((_) {
      _checkBTEnabled();
    });
  }

  Widget _screenBTOff() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Bluetooth tidak aktif'),
          TextButton(
            child: Text('Aktifkan bluetooth'),
            onPressed: () async {
              _gotoBTSettings();
            },
          )
        ],
      ),
    );
  }

  Widget _screenNoPairedDevices() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Tidak ada device yang terpasang'),
          TextButton(
            child: Text('Pasang device'),
            onPressed: () async {
              _gotoBTSettings();
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    t.cancel();
    _isDisposed = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah printer $type',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              _checkBTEnabled();
            },
          ),
        ],
      ),
      body: Container(
        child: !_isBluetoothEnabled
            ? _screenBTOff()
            : _printers.length > 0
                ? listViewPrinter()
                : _screenNoPairedDevices(),
      ),
    );
  }

  Widget listViewPrinter() {
    return ListView.builder(
      itemCount: _printers.length,
      itemBuilder: (BuildContext context, int index) {
        bool selected = false;
        Color textColor = Colors.black;
        Color cardColor = Colors.white;
        for (var item in _selectedDevices) {
          if (_printers[index].printerId == item.printerId) {
            selected = true;
            textColor = Colors.white;
            cardColor = Colors.orange;
          }
        }
        return InkWell(
          child: Card(
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _printers[index].printerName,
                      style: TextStyle(color: textColor),
                    ),
                    Text(
                      selected ? 'ON' : 'OFF',
                      style: TextStyle(color: textColor),
                    ),
                  ],
                )),
            color: cardColor,
          ),
          onTap: () {
            Dialogs.showYesNo(
                context: context,
                text: selected
                    ? 'Hapus ${_printers[index].printerName}?'
                    : 'Pilih ${_printers[index].printerName}?',
                action: (yes) {
                  if (yes) {
                    toggleSelect(index);
                  }
                });
          },
        );
      },
    );
  }

  void toggleSelect(int index) {
    bool isNewData = true;
    for (var i = 0; i < _selectedDevices.length; i++) {
      if (_printers[index].printerId == _selectedDevices[i].printerId) {
        _selectedDevices.removeAt(i);
        isNewData = false;
        i = 0;
        setState(() {});
      }
    }
    if (isNewData) {
      _selectedDevices.add(Printer(
          printerId: _printers[index].printerId,
          printerName: _printers[index].printerName));
      setState(() {});
    }
    Global.setShared(
        key: key,
        value: jsonEncode(ArrayOfPrinter(printers: _selectedDevices).toJson()));
    print(Global.getShared(key: key));
  }
}
