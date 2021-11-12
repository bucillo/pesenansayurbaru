
import 'package:PesenSayur/dialogs/ticket.dart';
import 'package:PesenSayur/models/api.dart';
import 'package:PesenSayur/models/ticket.dart';
import 'package:PesenSayur/models/ticket_detail.dart';
import 'package:PesenSayur/util/dialog.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';
import 'package:PesenSayur/util/const.dart';

class ContentTicketDetail extends StatefulWidget {

  final Ticket ticket;

  const ContentTicketDetail({Key key, this.ticket})
      : super(key: key);

  @override
  _ContentTicketDetailState createState() => _ContentTicketDetailState();
}

class _ContentTicketDetailState extends State<ContentTicketDetail> {
  List<TicketDetail> _ticketDetail = [];
  TextEditingController _text = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      select();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _text.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.lightNavbarBG,
        title: Text(
          "Ticket",
          style: TextStyle(color: Constants.lightAccent),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                select();
              },
              child: Icon(Icons.sync))
        ],
      ),
      body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10, left: 10, bottom: 5),
                decoration: BoxDecoration(
                  color: Constants.darkAccent,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(15),
                    right: Radius.circular(15),
                  ),
                ),
                child: InkWell(
                  onTap: (){
                    Dialogs.showYesNo(context: context, text: "Apakah yakin untuk menyelesaikan ticket?", action: (result){
                      if(result){
                        close();
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: double.infinity,
                    child: Text("SELESAIKAN", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                  ),
                )
              ),
              if (_ticketDetail.length > 0) ...[
                Expanded(
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _ticketDetail.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            if(_ticketDetail[index].me == "1") ...[
                              Expanded(
                                flex: 1,
                                child: Container()
                              )
                            ],
                            Expanded(
                              flex: 5,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: (_ticketDetail[index].me == "1") ? Colors.green[100] : Colors.blue[50],
                                child: ListTile(
                                  onTap: () {
                                    
                                  },
                                  subtitle: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(child: Text(_ticketDetail[index].user, style: TextStyle(color: Colors.grey, fontSize: 12)))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(child: Text(_ticketDetail[index].date, style: TextStyle(color: Colors.grey, fontSize: 12)))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(child: Text(_ticketDetail[index].text, style: TextStyle(color: Colors.black, fontSize: 20)))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if(_ticketDetail[index].me == "0") ...[
                              Expanded(
                                flex: 1,
                                child: Container()
                              )
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ] 
              else ...[
                Expanded(
                  child: Center(
                    child: Image.asset(
                      'assets/file-storage.png',
                      width: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
              if(widget.ticket.status == "0")...[
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 15, right: 10, bottom: 10),
                        child: TextFormField(
                          controller: _text,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.w300
                          )
                        ),
                      )
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10, bottom: 5),
                      decoration: BoxDecoration(
                        color: Constants.darkAccent,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(15),
                          right: Radius.circular(15),
                        ),
                      ),
                      child: InkWell(
                        onTap: (){
                          fill();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Text("SEND")
                        ),
                      )
                    ),
                  ],
                )
              ]
            ],
          )),
    );
  }

  Future<void> select() async {
    _ticketDetail = [];
    final response = API.fromJson(await TicketDetail.select(context: context, ticket: widget.ticket.id));
    if (response.success) {
      response.data.forEach((data) {
        TicketDetail ticketDetail = TicketDetail.fromJson(data);
        _ticketDetail.add(ticketDetail);
      });
    }

    setState(() {});
  }

  Future<void> fill() async {
    final response = API.fromJson(await TicketDetail.fill(context: context, ticket: widget.ticket.id, text: _text.text));
    if (response.success) {
      _text.text = "";
      select();
    }
  }

  Future<void> close() async {
    final response = API.fromJson(await Ticket.close(context: context, ticket: widget.ticket.id));
    if (response.success) {
      Dialogs.hideDialog(context: context);
    }
  }
}
