class OrderDetail {
  final String product;
  final String name;
  final int price;
  final String unit;
  final int unitConversion;
  double qty;
  String notes;

  OrderDetail.fromJson(Map<String, dynamic> json) :
    product = json["product"],
    name = json["name"],
    price = (json["price"] is String) ? int.parse(json["price"]) : json["price"],
    unit = json["unit"],
    unitConversion = (json["unit_conversion"] is String) ? int.parse(json["unit_conversion"]) : json["unit_conversion"],
    qty = (json["qty"] is String) ? double.parse(json["qty"]) : json["qty"],
    notes = json["notes"];
  
  Map<String, dynamic> toJson() =>
    <String, dynamic>{
        'product' : this.product,
        'name' : this.name,
        'price' : this.price,
        'unit' : this.unit,
        'unit_conversion' : this.unitConversion,
        'qty' : this.qty,
        'notes' : this.notes
    };

  OrderDetail(this.product, this.name, this.price, this.unit, this.unitConversion, this.qty, this.notes);
}

