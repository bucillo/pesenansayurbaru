import 'dart:convert';

import 'package:PesenSayur/models/customer.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';

class CustomerDialog {
  static List<Customer> customerFull = [];
  static List<Customer> customer = [];

  static void show(
      {@required BuildContext context,
      @required List<Customer> list,
      @required void Function(String, String, String, String) action}) {
    customer = list;
    customerFull = list;

    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                content: Container(
                  width: double.maxFinite,
                  height: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            customer = [];
                            customerFull.forEach((data) {
                              if (Global.contains(
                                  textData: data.name, textSearch: value)) {
                                customer.add(data);
                              }
                            });
                          });
                        },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) {
                          Dialogs.hideDialog(context: context);
                          action(value, "", "", "");
                        },
                        decoration: InputDecoration(labelText: "Pelanggan"),
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                          child: ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                    color: Colors.black,
                                    height: .2,
                                  ),
                              shrinkWrap: true,
                              itemCount: customer.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Dialogs.hideDialog(context: context);
                                    action(
                                        customer[index].name,
                                        customer[index].code,
                                        customer[index].phone,
                                        customer[index].address);
                                  },
                                  child: ListTile(
                                    title: ((customer[index].code == "")
                                        ? Text(customer[index].name,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold))
                                        : Text(
                                            customer[index].name +
                                                " (" +
                                                customer[index].code +
                                                ")",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold))),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (customer[index].address != "")
                                          Text(customer[index].address,
                                              style: TextStyle(fontSize: 12)),
                                        if (customer[index].phone != "")
                                          Text(customer[index].phone,
                                              style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                  ),
                                );
                              }))
                    ],
                  ),
                ),
              );
            }));
  }
}
