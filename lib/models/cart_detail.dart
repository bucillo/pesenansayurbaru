class CartDetail {
  final String product;
  final String name;
  final String hasStock;
  final String qtyDatabase;
  final List<dynamic> productPrints;
  double qty;
  final int price;
  String notes;

  CartDetail.fromJson(Map<String, dynamic> json) :
    product = json["product"],
    name = json["name"],
    hasStock = json["has_stock"],
    qtyDatabase = json["qty_database"],
    qty = json["qty"],
    price = json["price"],
    notes = json["notes"],
    productPrints = json["product_print"];
  
  Map<String, dynamic> toJson() =>
    <String, dynamic>{
        'product' : this.product,
        'name' : this.name,
        'has_stock' : this.hasStock,
        'qty_database' : this.qtyDatabase,
        'qty' : this.qty,
        'price' : this.price,
        'notes' : this.notes,
        'product_print': this.productPrints
    };
}

