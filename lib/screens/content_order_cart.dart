
import 'package:PesenSayur/dialogs/qty.dart';
import 'package:PesenSayur/models/api.dart';
import 'package:PesenSayur/models/order.dart';
import 'package:PesenSayur/models/order_detail.dart';
import 'package:PesenSayur/models/product.dart';
import 'package:PesenSayur/screens/content_order.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';
import 'package:PesenSayur/util/const.dart';

class ContentOrderCart extends StatefulWidget {
  final Order order;
  final List<OrderDetail> orderDetail;
  final DateTime datetime;
  const ContentOrderCart({Key key, this.order, this.orderDetail, this.datetime}) : super(key: key);

  @override
  _ContentOrderCartState createState() => _ContentOrderCartState();
}

class _ContentOrderCartState extends State<ContentOrderCart> {
  
  TextEditingController _searchController = new TextEditingController();
  List<Product> _productFull = [];
  List<Product> _product = [];
  bool showOnlyCart = false;

  @override
  void initState() {
    _searchController.addListener(search);
    Future.delayed(Duration.zero, () async {
      getItem();
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / (size.height / 350);
    final double itemWidth = size.width / 2;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.of(context).pop(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.lightNavbarBG,
          title: Text(
            "Order",
            style: TextStyle(color: Constants.lightAccent),
          ),
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: "Cari",
                            hintText: "Cari",
                            prefixIcon: Icon(Icons.search)
                          ),
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 5),
                        decoration: BoxDecoration(
                          color: Constants.darkAccent,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(15),
                            right: Radius.circular(15),
                          ),
                        ),
                        child: IconButton(
                            icon:
                                Icon((showOnlyCart) ? Icons.shopping_bag : Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                            onPressed: () {
                              onlyCart();
                            }),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: (itemWidth / itemHeight)),
                    itemBuilder: (_, index){
                      double qty = 0;
                      String notes = "";
                      for(int i=0; i<widget.orderDetail.length; i++){
                        if(widget.orderDetail[i].product == _product[index].id){
                          qty = widget.orderDetail[i].qty;
                          notes = widget.orderDetail[i].notes;
                        }
                      }
                      return Container(
                        child: InkWell(
                          onTap: (){
                            QtyDialog.show(
                              context: context, 
                              name: _product[index].name, 
                              product: _product[index].id, 
                              qty: qty, 
                              notes: notes, 
                              action: (result, product, qty, notes){
                                  if(result){
                                    int indexExist = -1;
                                    for(int i=0; i<widget.orderDetail.length; i++){
                                      if(product == widget.orderDetail[i].product){
                                        widget.orderDetail[i].qty = qty;
                                        widget.orderDetail[i].notes = notes;
                                        indexExist = i;
                                      }
                                    }

                                    if(indexExist==-1){
                                      widget.orderDetail.add(OrderDetail(product, _product[index].name, int.parse(_product[index].price), _product[index].unit, 1, qty, notes));
                                    }
                                    else if(qty==0){
                                      widget.orderDetail.removeAt(indexExist);
                                    }
                                    setState(() {});
                                  }
                              }
                            );
                          },
                          child: Card(
                            borderOnForeground: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.network(_product[index].photo, fit: BoxFit.fitHeight, height: 210,
                                    loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null ? 
                                              loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // FlutterLogo(size: 210),
                                SizedBox(height: 5),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    _product[index].name,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                  )
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Rp " + Global.delimeter(number: _product[index].price),
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      Text(
                                        " /" + _product[index].unit,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ],
                                  )
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8, right: 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if(qty>0) ...[
                                            // Container(
                                            //   width: 35,
                                            //   height: 35,
                                            //   margin: EdgeInsets.only(right: 10),
                                            //   decoration: BoxDecoration(
                                            //     color: Constants.darkAccent,
                                            //     borderRadius: BorderRadius.horizontal(
                                            //       left: Radius.circular(10),
                                            //       right: Radius.circular(10),
                                            //     ),
                                            //   ),
                                            //   child: InkWell(
                                            //     child: Container(
                                            //       margin: EdgeInsets.all(10),
                                            //       child: Center(child: Text("-", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)))
                                            //     ),
                                            //   )
                                            // ),
                                            Text(
                                              Global.delimeter(number: qty.toString()),
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                                            ),
                                          ],
                                          Container(
                                            width: 35,
                                            height: 35,
                                            margin: EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                              color: Constants.darkAccent,
                                              borderRadius: BorderRadius.horizontal(
                                                left: Radius.circular(10),
                                                right: Radius.circular(10),
                                              ),
                                            ),
                                            child: InkWell(
                                              child: Container(
                                                margin: EdgeInsets.all(10),
                                                child: Center(child: Text("+", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)))
                                              ),
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: _product.length,
                  )
                ),

                if(widget.orderDetail.length > 0)...[
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Global.materialNavigate(context, ContentOrder(datetime: widget.datetime, order: widget.order, orderDetail: widget.orderDetail));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            margin: EdgeInsets.only(left: 10, right: 5),
                            decoration: BoxDecoration(
                              color: Constants.darkAccent,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Order >",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20)
                ]
              ]
            )
          )
        )
      ),
    );
  }

  void search() {
    _product = [];
    _productFull.forEach((data) {
      if(Global.contains(textData: data.name, textSearch: _searchController.text))
      _product.add(data);
    });
    setState(() {});
  }

  void onlyCart() {
    showOnlyCart = !showOnlyCart;
    _product = [];
    _productFull.forEach((data) {
      if(!showOnlyCart) _product.add(data);
      else{
        for(int i=0; i<widget.orderDetail.length; i++){
          if(data.id == widget.orderDetail[i].product){
            _product.add(data);
          }
        }
      }
    });
    setState(() {});
  }

  Future<void> getItem() async {
    final response = API.fromJson(await Product.select(context: context));
    if (response.success) {
      _product = [];
      _productFull = [];
      response.data.forEach((data) {
        _productFull.add(Product.fromJson(data));
        _product.add(Product.fromJson(data));
      });
      setState(() {});
    }
    else Dialogs.showSimpleText(context: context, text: "Tidak ada data sayur");
  }
}
