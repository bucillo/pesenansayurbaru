import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'global.dart';

//CURRENCY FORMAT WHEN EDITING TEXTFIELD
class CurrencyFormat extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    bool useDecimal = false;
    String afterDecimal = "";
    String newText = newValue.text;
    if (newValue.text.contains(",")) {
      int posDecimal = newValue.text.indexOf(",");
      afterDecimal = newValue.text.substring(posDecimal);
      newText = newValue.text.substring(0, posDecimal);
      useDecimal = true;
    }

    if (afterDecimal.length > 3) afterDecimal = afterDecimal.substring(0, 3);

    newText = Global.unformatNumber(number: newText);
    newText = Global.delimeter(number: newText);
    if (useDecimal) newText = newText + "," + afterDecimal.replaceAll(',', '');

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
