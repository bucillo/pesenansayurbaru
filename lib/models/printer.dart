class ArrayOfPrinter {
  final List<Printer> printers;

  ArrayOfPrinter({this.printers});

  factory ArrayOfPrinter.fromJson(Map<String, dynamic> json) {
    return ArrayOfPrinter(
      printers: json['printers'] != null
          ? (json['printers'] as List).map((i) => Printer.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'printers': this.printers.map((v) => v.toJson()).toList(),
      };
}

class Printer {
  final String printerId;
  final String printerName;

  Printer({this.printerId, this.printerName});

  factory Printer.fromJson(Map<String, dynamic> json){
    return Printer(
      printerId: json['printerId'],
      printerName: json['printerName']
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'printerId': this.printerId,
        'printerName': this.printerName,
      };
}
